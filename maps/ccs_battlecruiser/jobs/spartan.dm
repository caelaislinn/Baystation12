
/datum/job/opredflag_spartan
	title = "Spartan II"
	faction_flag = UNSC
	supervisors = "the mission commander"
	selection_color = "#33ff00"
	account_allowed = 0               // Does this job type come with a station account?
	outfit_type = /decl/hierarchy/outfit/spartan_two
	loadout_allowed = TRUE            // Whether or not loadout equipment is allowed and to be created when joining.
	announced = FALSE                  //If their arrival is announced on radio
	generate_email = 0
	whitelisted_species = list(/datum/species/spartan)
	spawn_positions = 99
	total_positions = 99
	track_players = 1

/datum/job/opredflag_spartan/commander
	title = "Spartan II Commander"
	total_positions = 1
	spawn_positions = 1

/decl/hierarchy/outfit/spartan_two
	name = "Spartan II"
	uniform = /obj/item/clothing/under/spartan_internal
	suit = /obj/item/clothing/suit/armor/special/spartan
	belt = /obj/item/weapon/storage/belt/marine_ammo
	shoes = /obj/item/clothing/shoes/magboots
	gloves = /obj/item/clothing/gloves/thick/unsc
	head = /obj/item/clothing/head/helmet/spartan
	mask = /obj/item/clothing/mask/breath
	l_ear = /obj/item/device/radio/headset/spartan
	suit_store = /obj/item/weapon/tank/emergency/oxygen/double
	backpack = null
