//The phase inducer combines functionality between two different types of machines - /portable_atmospherics and /power
//the /portable_atmospherics functionality interacts with the pipe connector port and pumps the phoron into the piping network
//the /power functionality interacts with the powernet, producing power for it
//i've decided it would be beyond the scope of this project to try and merge functionality for the two
//instead i decided to use both with a dummy /power object and an actual /portable_atmospherics for interaction with the world

/obj/machinery/power/rust_phaseinducer
	density = 0
	invisibility = 101
	anchored = 1

/obj/machinery/portable_atmospherics/rust_phaseinducer
	name = "Phoron phase inducer"
	desc = "Machinery for inducing phased phoron and stripping it of it's energy load."
	icon = 'icons/rust.dmi'
	icon_state = "heater"	//todo: custom sprites
	var/id_tag = "inducerID"

	density = 1
	anchored = 0
	req_access = list(access_engine)
	//
	use_power = 1
	idle_power_usage = 10
	power_channel = ENVIRON

	var/remote_access_enabled = 1

	var/list/owning_cores = list()

	start_pressure = 0
	maximum_pressure = 90 * ONE_ATMOSPHERE

	var/list/induced_tensec = list()
	var/list/consume_tensec = list()
	var/list/generate_tensec = list()
	var/generated_this_tick = 0

	var/phase_capacity_max = 10000
	var/phase_capacity_left = 0
	var/obj/machinery/power/rust_phaseinducer/collector = new()
	var/list/phase_monitors = list()

/obj/machinery/portable_atmospherics/rust_phaseinducer/New()
	..()

	for(var/obj/machinery/power/rust_core/C in range(RUST_PHASE_RANGE, src))
		C.phase_inducers.Add(src)

	for(var/obj/machinery/computer/rust_phase_monitor/M in range(25, src))
		phase_monitors.Add(M)
		M.phase_inducers.Add(src)

/obj/machinery/portable_atmospherics/rust_phaseinducer/process()
	..()

	if(!collector)
		collector = new(src.loc)
		if(anchored)
			collector.anchored = 1
			collector.connect_to_network()

	generate_tensec.Add(generated_this_tick)
	if(generated_this_tick > 0)
		for(var/obj/machinery/computer/rust_phase_monitor/M in phase_monitors)
			M.generated_this_tick += generated_this_tick

	generated_this_tick = 0
	while(generate_tensec.len > 10)
		generate_tensec.Cut(1,2)

	phase_capacity_left = phase_capacity_max

/obj/machinery/portable_atmospherics/rust_phaseinducer/connect()
	if(..())
		collector.disconnect_from_network()
		collector.loc = src.loc
		collector.connect_to_network()

/obj/machinery/portable_atmospherics/rust_phaseinducer/disconnect()
	if(..())
		collector.disconnect_from_network()

/obj/machinery/portable_atmospherics/rust_phaseinducer/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	..()
	if(connected_port)
		collector.disconnect_from_network()
		collector.loc = src.loc
		collector.connect_to_network()
		collector.anchored = 1
	else
		collector.disconnect_from_network()
		collector.anchored = 0

/obj/machinery/portable_atmospherics/rust_phaseinducer/proc/TryInduce(var/num_moles, var/energy_load, var/temp)
	var/power_draw = -1
	var/induced_moles = min(num_moles, phase_capacity_left)
	var/power_produced = 0

	var/datum/gas_mixture/induced_phoron = new()
	induced_phoron.adjust_gas("phoron", num_moles)
	induced_phoron.temperature = temp
	power_draw = pump_gas(src, induced_phoron, air_contents)

	var/energy_per_mole = energy_load / num_moles
	power_produced = induced_moles * energy_per_mole * RUST_INDUCER_POWER_RATE
	collector.add_avail(power_produced)
	generate_tensec.Add(power_produced)
	while(generate_tensec.len > 10)
		generate_tensec.Cut(1,2)
	generated_this_tick += power_produced

	update_connected_network()

	consume_tensec.Add(power_draw)
	while(consume_tensec.len > 10)
		consume_tensec.Cut(1,2)

	induced_tensec.Add(induced_moles)
	while(induced_tensec.len > 10)
		induced_tensec.Cut(1,2)

	phase_capacity_left -= induced_moles

	world << "induced [num_moles] phoron and generated [power_produced]W"
	return induced_moles

/obj/machinery/portable_atmospherics/rust_phaseinducer/Del()

	for(var/obj/machinery/power/rust_core/C in owning_cores)
		C.phase_inducers.Remove(src)

	for(var/obj/machinery/computer/rust_phase_monitor/M in phase_monitors)
		M.phase_inducers.Remove(src)

	..()
