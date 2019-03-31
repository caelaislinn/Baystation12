
/datum/job/colonist
	title = "Geminus Colonist"
	selection_color = "#FFFF00"
	spawnpoint_override = "Geminus Colonist Spawns"
	outfit_type = /decl/hierarchy/outfit/geminus_colonist
	open_slot_on_death = 1
	total_positions = -1
	spawn_positions = -1
	intro_blurb = "Objective: Survive"

/datum/job/colonist/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	if(H.species && H.species.name != "Human")
		H.set_species("Human")
	. = ..()

/datum/job/scom
	selection_color = "#33dd00"
	spawnpoint_override = "SCOM Spawns"
	open_slot_on_death = 1
	intro_blurb = "Objective: Slay all aliens! Rescue the colonists"

/datum/job/scom/equip(var/mob/living/carbon/human/H, var/alt_title, var/datum/mil_branch/branch)
	H.set_species("Human")
	. = ..()

/datum/job/scom/assault
	title = "SCOM Assault Class"
	outfit_type = /decl/hierarchy/outfit/scom/assault
	total_positions = -1
	spawn_positions = -1

/datum/job/scom/heavy
	title = "SCOM Heavy Class"
	total_positions = 3
	spawn_positions = 3
	outfit_type = /decl/hierarchy/outfit/scom/heavy

/datum/job/scom/sniper
	title = "SCOM Sniper Class"
	total_positions = 2
	spawn_positions = 2
	outfit_type = /decl/hierarchy/outfit/scom/sniper

/datum/job/scom/support
	title = "SCOM Support Class"
	outfit_type = /decl/hierarchy/outfit/scom/support
	total_positions = -1
	spawn_positions = -1

/datum/job/scom/commander
	title = "SCOM Project Commander"
	total_positions = 1
	spawn_positions = 1
	outfit_type = /decl/hierarchy/outfit/scom/commander

/datum/job/scom/squad_leader
	title = "SCOM Squad Leader"
	spawn_positions = 3
	total_positions = 3
	outfit_type = /decl/hierarchy/outfit/scom/squad_leader

/obj/effect/landmark/start/colony_AI
	name = "UEG Colonial AI"
