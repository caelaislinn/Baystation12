
/proc/get_overmap_sector(var/atom/A)
	//aggressive coding: dont do safety checks and rely on runtimes to tell you when you have an unintended edge case
	/*if(istype(A, /obj/effect/overmapobj))
		return A*/
	var/obj/effect/overmapobj/sector

	var/turf/T = get_turf(A)
	if(!T)
		return
	sector = map_sectors["[T.z]"]
	if(!sector)
		//special handling
		var/obj/machinery/overmap_vehicle/craft

		//check if we are in a shuttle
		if(istype(T, /turf/simulated/shuttle/hull))
			var/turf/simulated/shuttle/hull/H = T
			craft = H.my_shuttle
		else
			//check if we are in a cruising fighter etc
			//this should only loop perhaps 2-4 times at most
			var/atom/container = A
			while(container && !istype(container, /turf) && !istype(container, /area))
				container = container.loc
				if(istype(container, /obj/machinery/overmap_vehicle))
					craft = container
					break

		if(craft)
			sector = craft.get_sector()

	//that should cover all the edge cases here. it's possible there will be zlevels
	return sector
