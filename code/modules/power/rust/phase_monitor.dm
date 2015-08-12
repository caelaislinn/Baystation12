
/obj/machinery/computer/rust_phase_monitor
	name = "RUST Power Phasing Monitor"
	icon = 'icons/rust.dmi'
	icon_state = "core_control"
	var/list/connected_devices = list()
	var/id_tag = ""
	var/scan_range = 25
	var/list/generate_tensec = list(0)

	var/list/phase_inducers = list()
	var/list/generated_this_tick = 0

/obj/machinery/computer/rust_phase_monitor/New()
	..()

	for(var/obj/machinery/portable_atmospherics/rust_phaseinducer/I in range(25, src))
		I.phase_monitors.Add(src)
		phase_inducers.Add(I)

/obj/machinery/computer/rust_phase_monitor/process()
	..()

	generate_tensec.Add(generated_this_tick)
	generated_this_tick = 0
	while(generate_tensec.len > 10)
		generate_tensec.Cut(1,2)

/obj/machinery/computer/rust_phase_monitor/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/computer/rust_phase_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()

	data["chartValues"] = generate_tensec

	// update the ui with data if it exists, returns null if no ui is passed/found or if force_open is 1/true
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "phase_monitor.tmpl", "RUST Power Phase Monitor", 520, 410)

		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)

		// open the new ui window
		ui.open()

		// auto update every Master Controller tick
		ui.set_auto_update(1)

/obj/machinery/computer/rust_phase_monitor/Del()
	for(var/obj/machinery/portable_atmospherics/rust_phaseinducer/I in phase_inducers)
		I.phase_monitors.Remove(src)

	..()
