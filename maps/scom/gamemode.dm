
/datum/game_mode/scom
	name = "The SCOM Project"
	round_description = "Commander, you have been chosen to lead the defence of Earth and all her colonies against the invading xrays."
	extended_round_description = "Commander, you have been chosen to lead the defence of Earth and all her colonies against the invading xrays."
	config_tag = "scom"

/datum/game_mode/scom/pre_setup()
	. = ..()

	//spawn in comms
	new /obj/item/device/mobilecomms/commsbackpack/covenant(locate(1,1,1))
	new /obj/item/device/mobilecomms/commsbackpack/sec/permanent(locate(1,1,1))

	//I DONT CARE THIS IS HAPPENING
	//I WILL REMOVE UNDERWEAR IF I HAVE TO DO IT TO EVERY MOB ON THE SERVER
	var/datum/species/S = all_species["Human"]
	S.appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_LIPS | HAS_EYE_COLOR// | HAS_UNDERWEAR

/datum/game_mode/scom/get_respawn_time()
	return 0.5
