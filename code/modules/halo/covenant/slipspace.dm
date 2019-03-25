
/obj/structure/covenant_slipspace
	name = "Slipspace Generator"
	icon = 'slipspace.dmi'
	icon_state = "slipspace"
	desc = "An incredibly advanced machine capable of precise slipspace jumps."
	anchored = 1
	density = 1
	bound_width = 64
	bound_height = 64
	var/slipspace_activate_timer = 10 SECONDS
	var/slipspace_chargeup_timer = 60 SECONDS
	var/slipspace_jump_time = 0

/obj/structure/covenant_slipspace/allowed(var/mob/user)
	var/mob/living/carbon/human/h = user
	if(istype(h) && h.species.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	if(user.type in COVENANT_SPECIES_AND_MOBS)
		return 1
	return 0

/obj/structure/covenant_slipspace/attack_hand(var/mob/user)
	if(allowed(user))
		var/obj/effect/overmap/ship/ship = map_sectors["[z]"]
		if(istype(ship))
			if(slipspace_jump_time)
				if(alert("Do you want to shutdown the slipspace engine and remain in the system?","Shutdown slipspace jump","Shutdown","Cancel") == "Shutdown")
					slipspace_jump_time = 0
					GLOB.processing_objects -= src
					src.visible_message("<span class='info'>[user] begins working at the console of [src]...</span>")
					to_chat(user,"<span class='notice'>You shutdown the slipspace engine.</span>")
			else
				if(alert("Do you want to activate the slipspace engine to leave the system?","Enter slipspace","Engage","Cancel") == "Engage")
					message_admins("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) has begun activating the slipspace engine. Without interference, the ship will enter slipspace in [(slipspace_activate_timer + slipspace_chargeup_timer) / 10] seconds from now.")
					src.visible_message("<span class='info'>[user] begins working at the console of [src]...</span>")
					if(do_after(user, slipspace_activate_timer))
						slipspace_jump_time = world.time + slipspace_chargeup_timer
						GLOB.processing_objects += src
						log_admin("[user] the [user.mind.assigned_role] (CKEY: [user.ckey]) activated the slipspace engine. Jump timer: [slipspace_chargeup_timer / 10] seconds.")
						if(istype(ship))
							to_chat(user,"<span class='notice'>[src] has been activated. [ship] will enter slipspace in [slipspace_chargeup_timer / 10] seconds.</span>")
	else
		to_chat(user,"<span class='warning'>You are unable to decipher how [src] works.</span>")

/obj/structure/covenant_slipspace/process()
	if(slipspace_jump_time && world.time > slipspace_jump_time)
		slipspace_jump_time = 0
		GLOB.processing_objects -= src
		var/datum/game_mode/invasion = ticker.mode
		//this is hacky but it will work without invasion gamemode compiled
		if(istype(invasion) && hasvar(invasion,"covenant_ship_slipspaced"))
			invasion:covenant_ship_slipspaced = 1
		var/obj/effect/overmap/ship/ship = map_sectors["[z]"]
		if(istype(ship))
			spawn(0)
				var/headingdir = ship.get_heading()
				if(!headingdir)
					headingdir = ship.dir
				var/turf/T = ship.loc
				for(var/i=0, i<6, i++)
					T = get_step(T,headingdir)
				new /obj/effect/slipspace_rupture(T)
				for(var/i=0, i<6, i++)
					ship.loc = get_step(ship, headingdir)
					sleep(1)
				ship.do_superstructure_fail()

/obj/effect/slipspace_rupture
	name = "slipspace rupture"
	icon = 'code/modules/halo/covenant/slipspace.dmi'
	icon_state = "slipspace_effect"
	pixel_x = -16
	pixel_y = -16

/obj/effect/slipspace_rupture/New()
	spawn(6)
		qdel(src)
