//the em field is where the fun happens
/*
Deuterium-deuterium fusion : 40 x 10^7 K
Deuterium-tritium fusion: 4.5 x 10^7 K
*/

//#DEFINE MAX_STORED_ENERGY (held_phoron.phoron * held_phoron.phoron * SPECIFIC_HEAT_TOXIN)

/obj/effect/rust_em_field
	name = "EM Field"
	desc = "A coruscating, barely visible field of energy. It is shaped like a slightly flattened torus."
	icon = 'icons/rust.dmi'
	icon_state = "emfield_s1"
	//
	var/size = 1			//diameter in tiles
	var/obj/machinery/power/rust_core/owned_core
	var/datum/gas_mixture/environment

	var/field_volume = 0	//atmospheric volume covered in litres
	var/sufficient_core_size = 1

	var/held_phoron_max = 0
	var/datum/gas_mixture/held_phoron = new/datum/gas_mixture()

	var/total_fuel = 0
	var/fuel_density = 0

	var/catalyst_rate = 0
	var/reacted_this_cycle = 0
	var/react_rate_this_cycle = 0
	var/excitation_level = 0
	var/archived_excitation_level = 0

	var/energy_density_threshold = RUST_ENERGY_PER_LITRE
	var/phoron_phase_rate = RUST_PHORON_PER_PHASE
	var/field_phase_difference = 0

	var/average_fuel_wastage = 0
	var/list/fuel_wasted = list()

	var/list/reaction_tensec = list()
	var/list/excitation_tensec = list()
	var/list/phase_tensec = list()
	var/list/phaseloss_tensec = list()
	var/list/phaselossrate_tensec = list()

	var/list/dormant_reactant_quantities = new
	var/particle_catchers[13]

	//luminosity = 1
	layer = 3.1
	var/total_energy = 0		//MeV
	var/energy_density = 0

	var/field_frequency = MIN_RUST_FREQ		//1 to 10, 1 is default setting
	var/field_strength = MIN_RUST_STR		//in teslas, max is 50T
	var/field_projection = MIN_RUST_PROJ	//radius in metres from 1-7

	var/trigger_react = 0

	var/obj/machinery/rust/rad_source/radiator
	var/phase_range = RUST_PHASE_RANGE
	var/lost_phasing_phoron = 0

/obj/effect/rust_em_field/New()
	..()
	//make sure there's a field generator
	for(var/obj/machinery/power/rust_core/core in loc)
		owned_core = core

	if(!owned_core)
		qdel(src)
		return

	//create radiator
	for(var/obj/machinery/rust/rad_source/rad in range(0))
		radiator = rad
	if(!radiator)
		radiator = new /obj/machinery/rust/rad_source(owned_core.loc)
	radiator.owner_alive = 1

	//create the gimmicky things to handle field collisions
	var/obj/effect/rust_particle_catcher/catcher
	//
	catcher = new (locate(src.x,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(1)
	particle_catchers.Add(catcher)
	//
	catcher = new (locate(src.x-1,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x+1,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y+1,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y-1,src.z))
	catcher.parent = src
	catcher.SetSize(3)
	particle_catchers.Add(catcher)
	//
	catcher = new (locate(src.x-2,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x+2,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y+2,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y-2,src.z))
	catcher.parent = src
	catcher.SetSize(5)
	particle_catchers.Add(catcher)
	//
	catcher = new (locate(src.x-3,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x+3,src.y,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y+3,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)
	catcher = new (locate(src.x,src.y-3,src.z))
	catcher.parent = src
	catcher.SetSize(7)
	particle_catchers.Add(catcher)

	processing_objects.Add(src)

//todo: change this to stimulate reactions
/obj/effect/rust_em_field/proc/AddEnergy(var/a_total_energy, var/can_exceed_threshold = 1)
	//this is so emitters cant add enough energy to start phasing, only fusion reactions can
	if(!can_exceed_threshold)
		if( field_volume < 0 ||(a_total_energy + total_energy) / field_volume >= energy_density_threshold )
			radiator.light_radiation += a_total_energy
			return

	total_energy += a_total_energy

	//increase the temperature of the suspended phoron
	//todo: this needs balancing, this is probably way too low a heat increase
	if(held_phoron.heat_capacity())
		held_phoron.temperature += RUST_ENERGY_HEAT_MULTIPLIER * a_total_energy / held_phoron.heat_capacity()
		//world << "field temperature increased by [RUST_ENERGY_HEAT_MULTIPLIER * a_total_energy / held_phoron.heat_capacity()] degrees"

	recalculate_energy_density()

/obj/effect/rust_em_field/proc/AddParticles(var/name, var/quantity = 1)
	if(name in dormant_reactant_quantities)
		dormant_reactant_quantities[name] += quantity
		return 1
	else if(name != "proton" && name != "electron" && name != "neutron")
		dormant_reactant_quantities.Add(name)
		dormant_reactant_quantities[name] = quantity
		return 1

/obj/effect/rust_em_field/proc/ChangeFieldProjection(var/new_projection)
	field_projection = new_projection
	recalculate_volume()	//this is also done every process() in case someone is messing with turfs in the core

	recalculate_size()

/obj/effect/rust_em_field/proc/ChangeFieldFrequency(var/new_frequency)
	field_frequency = new_frequency
	energy_density_threshold = RUST_ENERGY_PER_LITRE * (field_frequency / MAX_RUST_FREQ)

	recalculate_phase_difference()

/obj/effect/rust_em_field/proc/ChangeFieldStrength(var/new_strength)
	field_strength = new_strength
	phoron_phase_rate = RUST_PHORON_PER_PHASE * (MIN_RUST_STR / field_strength)

	recalculate_phase_difference()

/obj/effect/rust_em_field/bullet_act(var/obj/item/projectile/Proj)
	//world << "catcher hit by [Proj] [Proj.type] [Proj.damage]"
	if(Proj.check_armour != "bullet")
		AddEnergy(Proj.damage / 10, 0)
		excitation_level += Proj.damage / 10
		update_icon()
	else
		visible_message("\icon[src] [Proj] \icon[Proj] hits an invisible wall of force!")
	return 0

/obj/effect/rust_em_field/proc/DestroyField()
	//radiate everything in one giant burst
	for(var/obj/effect/rust_particle_catcher/catcher in particle_catchers)
		qdel (catcher)

	//release all held particles
	for(var/particle in dormant_reactant_quantities)
		radiator.heavy_radiation += dormant_reactant_quantities[particle]
		dormant_reactant_quantities.Remove(particle)
	radiator.light_radiation += total_energy
	radiator.owner_alive = 0
	total_energy = 0

	//lose all held phoron back into the air
	var/datum/gas_mixture/environment = loc.return_air()
	environment.merge(held_phoron)

	processing_objects.Remove(src)
	..()
