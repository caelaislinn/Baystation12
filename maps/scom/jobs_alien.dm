
/datum/job/xray
	selection_color = "#9900FF"
	spawnpoint_override = "XRAY Spawns"
	open_slot_on_death = 1
	intro_blurb = "Objective: Slay all humans!"

/datum/job/xray/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)

	/*for(var/obj/item/underwear/U in H)
		U.RemoveUnderwear(H, H)
		H.remove_from_mob(U)
		qdel(U)*/

	if(!H.species || H.species.name != title)
		H.set_species(title)
		H.appearance_flags = 0
	H.fully_replace_character_name(H.species.get_random_name())
	H.pixel_x = -32

	. = ..()

/datum/job/xray/sectoid
	title = "Sectoid"
	outfit_type = /decl/hierarchy/outfit/xray/sectoid
	total_positions = -1
	spawn_positions = -1

/datum/job/xray/thin_man
	title = "Thin Man"
	outfit_type = /decl/hierarchy/outfit/xray/thin_man
	total_positions = -1
	spawn_positions = -1

/datum/job/xray/muton
	title = "Muton"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/xray/muton

/datum/job/xray/chryssalid
	title = "Chryssalid"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/xray/chryssalid

/datum/job/xray/ethereal
	title = "Ethereal"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/xray/ethereal
