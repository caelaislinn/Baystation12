
/obj/machinery/rust/rad_source
	var/light_radiation = 0
	var/heavy_radiation = 0
	var/owner_alive = 0
	New()
		..()
		processing_objects.Add(src)

/obj/machinery/rust/rad_source/process()

	//fade away over time
	if(owner_alive <= 0 && light_radiation < 1 && heavy_radiation < 1)
		qdel(src)

	//update nearby radiation monitors
	var/lightrad_range = 7 + light_radiation / RUST_RAD_FALLOFF
	if(light_radiation == 0)
		lightrad_range = 0
	var/heavyrad_range = 14
	if(heavy_radiation == 0)
		heavyrad_range = 0

	for(var/obj/machinery/computer/rust_radiation_monitor/R in range(max(lightrad_range, heavyrad_range), src))
		var/distance = get_dist(src, R)

		//tell the monitor exactly how much radiation it is recieving at that distance
		if(distance <= lightrad_range)
			R.ambient_lightrads += max(light_radiation - RUST_RAD_FALLOFF * distance, 0)

		//as the monitor being in range of heavy rads kind of defeats the purpose, just detect any occurring nearby
		if(distance <= heavyrad_range)
			R.ambient_heavyrads += max(heavy_radiation, 0)

	//light radiation penetrates very far but does relatively little damage
	if(lightrad_range >= 1)
		for(var/mob/living/M in range(7 + light_radiation / RUST_RAD_FALLOFF, src))
			var/dist = get_dist(src, M)
			var/rads = light_radiation
			if(dist > 7)
				rads = max(light_radiation - RUST_RAD_FALLOFF * dist, 0)
			M.apply_effect(rads, IRRADIATE)
		light_radiation /= 2		//halflife
		if(light_radiation < 1)
			light_radiation = 0

	//heavy radiation is very easily blocked but is quite damaging
	if(heavyrad_range >= 1)
		for(var/mob/living/M in view(7, src))
			M.take_overall_damage(0, min( heavy_radiation * (M.getarmor(null, "rad") / 100), 30 ), used_weapon = "Severe Radiation Burns")
			M.apply_effect(heavy_radiation, IRRADIATE)
		heavy_radiation /= 2		//halflife
		if(heavy_radiation < 1)
			heavy_radiation = 0
