GLOBAL_LIST_EMPTY(scom_spawn_turfs)
GLOBAL_LIST_EMPTY(colony_spawn_turfs)

/proc/create_scom_colony_spawn_turfs()
	if(!GLOB.colony_spawn_turfs.len)
		for(var/obj/effect/landmark/drop_pod_landing/D in world)
			GLOB.colony_spawn_turfs += D.loc

	if(!GLOB.scom_spawn_turfs.len)
		for(var/obj/effect/landmark/start/joinlate/D in world)
			GLOB.scom_spawn_turfs += D.loc




/datum/spawnpoint/scom_humans
	display_name =  "SCOM Spawns"
	restrict_job_type = list(\
		/datum/job/scom/assault,\
		/datum/job/scom/heavy,\
		/datum/job/scom/sniper,\
		/datum/job/scom/support,\
		//
		/datum/job/scom/squad_leader,\
		/datum/job/scom/commander\
	)

/datum/spawnpoint/scom_humans/New()
	..()
	create_scom_colony_spawn_turfs()
	turfs = GLOB.scom_spawn_turfs




/datum/spawnpoint/scom_aliens
	display_name =  "XRAY Spawns"
	restrict_job_type = list(\
		/datum/job/xray/sectoid,\
		/datum/job/xray/thin_man,\
		/datum/job/xray/muton,\
		/datum/job/xray/chryssalid,\
		/datum/job/xray/ethereal\
		)

/datum/spawnpoint/scom_aliens/New()
	..()
	create_scom_colony_spawn_turfs()
	turfs = list()
	for(var/i=0,i<3,i++)
		var/turf/T = pick(GLOB.colony_spawn_turfs)
		GLOB.colony_spawn_turfs -= T
		for(var/turf/simulated/floor/F in view(2,T))
			turfs += F
			new /obj/item/energybarricade(F)
		turfs |= T
		new /obj/structure/weapon_rack(T)




/datum/spawnpoint/geminus_colonist
	display_name =  "Geminus Colonist Spawns"
	restrict_job_type = list(/datum/job/colonist)

/datum/spawnpoint/geminus_colonist/New()
	..()
	create_scom_colony_spawn_turfs()
	turfs = GLOB.colony_spawn_turfs
