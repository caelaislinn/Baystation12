//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/obj/effect/accelerated_particle
	name = "Accelerated Particles"
	desc = "Small things moving very fast."
	icon = 'icons/obj/machines/particle_accelerator2.dmi'
	icon_state = "particle"//Need a new icon for this
	anchored = 1
	density = 1
	var/movement_range = 10
	var/energy = 10
	var/particle_type
	var/additional_particles = 0
	var/turf/target
	var/turf/source
	var/movetotarget = 1

/obj/effect/accelerated_particle/weak
	movement_range = 8
	energy = 5

/obj/effect/accelerated_particle/strong
	movement_range = 15
	energy = 15


/obj/effect/accelerated_particle/New(loc, dir = 2)
	src.loc = loc
	src.set_dir(dir)
	if(movement_range > 20)
		movement_range = 20
	spawn(0)
		move(1)
	return

//todo: does this even work? not sure if it does -Cael
/obj/effect/accelerated_particle/Bump(atom/A)
	if (A)
		if(ismob(A))
			toxmob(A)
		if((istype(A,/obj/machinery/the_singularitygen))||(istype(A,/obj/singularity/)))
			A:energy += energy
	return


/obj/effect/accelerated_particle/Bumped(atom/A)
	if(ismob(A))
		Bump(A)
	return


/obj/effect/accelerated_particle/ex_act(severity)
	qdel(src)
	return



/obj/effect/accelerated_particle/proc/toxmob(var/mob/living/M)
	var/radiation = (energy*2)
	M.apply_effect((radiation*3),IRRADIATE,0)
	M.updatehealth()
	//M << "\red You feel odd."
	return


/obj/effect/accelerated_particle/proc/move(var/lag)
	if(target)
		if(movetotarget)
			if(!step_towards(src,target))
				src.loc = get_step(src, get_dir(src,target))
			if(get_dist(src,target) < 1)
				movetotarget = 0
		else
			if(!step(src, get_step_away(src,source)))
				src.loc = get_step(src, get_step_away(src,source))
	else
		if(!step(src,dir))
			src.loc = get_step(src,dir)
	movement_range--

	//todo: this is not a nice way to handle this. it was good enough for singulo but that is it
	var/obj/effect/rust_particle_catcher/catcher = locate() in src.loc
	if(catcher && catcher.TryAddParticles(src))
		movement_range = 0
	var/obj/machinery/power/rust_core/core = locate() in src.loc
	if(core && core.AddParticles(src))
		movement_range = 0

	var/mob/living/M = locate() in src.loc
	if(M)
		toxmob(M)
		movement_range = 0

	if(movement_range <= 0)
		qdel(src)
	else
		sleep(lag)
		move(lag)
