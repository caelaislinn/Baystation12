
/obj/effect/rust_em_field/process()

	//--- make sure the field generator is still intact

	if(!owned_core)
		del(src)
		return

	if(!radiator)
		radiator = new /obj/machinery/rust/rad_source(owned_core.loc)
	radiator.owner_alive = 1

	//--- some atmospheric stuff

	var/turf/cur_turf = get_turf(loc)
	var/turf/simulated/floor/source_turf
	sufficient_core_size = 0

	//check if the core vessel is large enough for our field
	if(istype(cur_turf, /turf/simulated/floor))
		source_turf = cur_turf
	else
		source_turf = locate() in range(size)

	if(source_turf)
		var/numturfs = source_turf.zone.contents.len
		sufficient_core_size = min(1, numturfs / (size * size) )
		environment = source_turf.return_air()
	else
		environment = cur_turf.return_air()


	//--- recalculate field volume

	recalculate_volume()


	//--- have the core field interact with the ambient environmental gases

	process_phoron_capture()


	//recalculate fuel properties

	recalculate_fuel()


	//--- handle fuel wastage

	process_fuelwastage()


	//--- update energy density (done here in case energy was added in between ticks)

	recalculate_energy_density()


	//--- let the fuel inside the field react

	var/avail_fuel = total_fuel
	React()
	react_rate_this_cycle = 0
	if(avail_fuel > 0)
		react_rate_this_cycle = reacted_this_cycle / avail_fuel


	//--- if we have excess energy, phase or radiate it away

	process_excess_energy()


	//--- recalculate reaction rate

	recalculate_catalysis()


	return 1
