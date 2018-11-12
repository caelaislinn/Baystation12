#define URFC_OVERRIDE 'code/modules/halo/clothing/urf_commando.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/urf_commando.dmi'

/obj/item/clothing/under/urf/commando_jumpsuit
	name = "URF Commando uniform"
	desc = "Standard issue URF Commando uniform, more badass than that, you die."
	icon = ITEM_INHAND
	icon_override = URFC_OVERRIDE
	item_state = "commando_uni"
	icon_state = "commando_uni"
	worn_state = "uni_worn"
	armor = list(melee = 10, bullet = 10, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/head/helmet/urf_commando
	name = "URFC Helmet"
	desc = "Somewhat expensive and hand crafted, this helmet has been clearly converted from an old spec ops grade EVA combat helmet as the foundation. Despite the old age, a lot of work has been put into adding additional armor and refining the base processes, such as an internal oxygen filter and the replacement of the visor. It's quite heavy, but a lot of soft material has been added to the inside to make the metal more comfy. Outdated, but can be expected in combat engagements to perform on par with modern equipment, due to the extensive modifications."
	icon = ITEM_INHAND
	icon_override = URFC_OVERRIDE
	item_state = "rifleman_worn"
	icon_state = "rifleman_helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 35, bullet = 30, laser = 25,energy = 10, bomb = 20, bio = 0, rad = 5)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/suit/armor/special/urfc_armor
	name = "URFC Armour"
	desc = "Somewhat expensive and hand crafted, this armor is the pinnacle of the work force of the URF and it's many workers. Filled with pouches and storage compartments, while still keeping a scary amount of both mobility and protection. An ideal collage of the strengths of the URF, but with the added protection found only in high tier UNSC equipment. It's quite comfy, probably won't last long in space."
	icon = ITEM_INHAND
	item_state = "rifleman_a_worn"
	icon_state = "rifleman_a_obj"
	icon_override = URFC_OVERRIDE
	blood_overlay_type = "armor"
	armor = list(melee = 40, bullet = 45, laser = 30, energy = 35, bomb = 70, bio = 80, rad = 15)
	//specials = list(/datum/armourspecials/internal_air_tank/human) This line is disabled untill a dev can fix the internals code for it.
	item_flags = THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	armor_thickness = 10


//Defines for armour subtypes//

/obj/effect/urfc_armour_set
	var/obj/helmet = /obj/item/clothing/head/helmet/urfc/rifleman
	var/obj/armour = /obj/item/clothing/suit/armor/special/urfc_armor

/obj/effect/urfc_armour_set/New()
	.=..()
	new helmet(src.loc)
	new armour(src.loc)

/obj/effect/urfc_armour_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL

/obj/effect/urfc_armour_set/rifleman
	helmet = /obj/item/clothing/head/helmet/urfc/rifleman
	armour = /obj/item/clothing/suit/armor/special/urfc/rifleman

/obj/item/clothing/head/helmet/urfc/rifleman
	name = "URFC Rifleman Helmet"

	item_state = "rifleman_worn"
	icon_state = "rifleman_helmet"

/obj/item/clothing/suit/armor/special/urfc/rifleman
	name = "URFC Rifleman Armour"

	item_state = "rifleman_a_worn"
	icon_state = "rifleman_a_obj"

/obj/effect/urfc_armour_set/cqb
	helmet = /obj/item/clothing/head/helmet/urfc/cqb
	armour = /obj/item/clothing/suit/armor/special/urfc/cqb

/obj/item/clothing/suit/armor/special/urfc/cqb
	name = "URFC CQB Armour"

	item_state = "death_a_worn"
	icon_state = "death_a_obj"

/obj/item/clothing/head/helmet/urfc/cqb
	name = "URFC CQB Helmet"

	item_state = "cqc_worn"
	icon_state = "cqc_helmet"

/obj/effect/urfc_armour_set/sniper
	helmet = /obj/item/clothing/head/helmet/urfc/sniper
	armour = /obj/item/clothing/suit/armor/special/urfc/sniper

/obj/item/clothing/suit/armor/special/urfc/sniper
	name = "URFC Sniper Armour"

	item_state = "sniper_worn"
	icon_state = "sniper_obj"

/obj/item/clothing/head/helmet/urfc/sniper
	name = "URFC Sniper Helmet"

	item_state = "sniper_a_worn"
	icon_state = "sniper_a_obj"

/obj/effect/urfc_armour_set/medic
	helmet = /obj/item/clothing/head/helmet/urfc/medic
	armour = /obj/item/clothing/suit/armor/special/urfc/medic

/obj/item/clothing/suit/armor/special/urfc/medic
	name = "URFC Medic Armour"

	item_state = "medi_a_worn"
	icon_state = "medi_a_obj"

/obj/item/clothing/head/helmet/urfc/medic
	name = "URFC Medic Helmet"

	item_state = "medi_worn"
	icon_state = "medi_helmet"

///obj/item/clothing/head/helmet/odst/medic/health/process_hud(var/mob/M)
//	process_med_hud(M, 1)

/obj/effect/urfc_armour_set/engineer
	helmet = /obj/item/clothing/head/helmet/urfc/engineer
	armour = /obj/item/clothing/suit/armor/special/urfc/engineer

/obj/item/clothing/head/helmet/urfc/engineer
	name = "URFC Engineer Helmet"
	flash_protection = FLASH_PROTECTION_MAJOR
	item_state = "engi_worn"
	icon_state = "engi_helmet"

/obj/item/clothing/suit/armor/special/urfc/engineer
	name = "URFC Engineer Armour"

	item_state "engi_a_worn"
	icon_state = "engi_a_obj"

/obj/effect/urfc_armour_set/squadleader
	helmet = /obj/item/clothing/head/helmet/urfc/squadleader
	armour = /obj/item/clothing/suit/armor/special/urfc/squadleader

/obj/item/clothing/head/helmet/urfc/squadleader
	name = "URFC Squad Leader Helmet"

	item_state = "sl_worn"
	icon_state = "sl_helmet"

/obj/item/clothing/suit/armor/special/urfc/squadleader
	name = "URFC Squad Leader Armour"

	item_state = "sl_a_worn"
	icon_state = "sl_a_obj"

/obj/effect/urfc_armour_set/death
	helmet = /obj/item/clothing/head/helmet/urfc/death
	armour = /obj/item/clothing/suit/armor/special/urfc/death

/obj/item/clothing/head/helmet/urfc/death
	name = "URFC Death Helmet

	item_state = "death_worn"
	icon_state = "death_helmet"

/obj/item/clothing/suit/armor/special/urfc/death
	name = "URFC Death Armour"

	item_state = "death_a_worn"
	icon_state = "death_a_obj"

//DONATOR GEAR



//END DONATOR GEAR

/obj/effect/random_URFC_set/New()
	.=..()
	var/obj/armour_set = pick(list(/obj/effect/urfc_armour_set/medic,/obj/effect/urfc_armour_set/sniper,/obj/effect/urfc_armour_set/cqb,/obj/effect/urfc_armour_set,/obj/effect/urfc_armour_set/engineer,/obj/effect/urfc_armour_set/squadleader,/obj/effect/urfc_armour_set/death))
	new armour_set(src.loc)

/obj/effect/random_URFC_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL

//This item is an idea, since we do not have modular armors yet. It just needs a sprite.
//obj/item/clothing/accessory/storage/urfc_vest
//	name = "Tactical Pouches"
//	icon_state = "tactical_pouches"

//obj/item/weapon/storage/backpack/urfc/example
//	icon = ITEM_INHAND
//	icon_override = URFC_OVERRIDE
//	name = "Example of a backpack item"
//	item_state = "example_state"
//	icon_state = "example_state"

//DONATOR GEAR

///obj/item/weapon/storage/backpack/urfc/donator/example
//	icon = ITEM_INHAND
//	icon_override = URFC_OVERRIDE
//	name = "Example's Backpack"
//	item_state = "example_state"
//	icon_state = "example_state"

//END DONATOR GEAR

/obj/item/clothing/shoes/urfc/magboots
	desc = "Experimental black magnetic boots, used to ensure the user is safely attached to any surfaces during extra-vehicular operations. They're large enough to be worn over other footwear."
	name = "URFC Magboots"
	item_state = "magboots_worn"
	icon_state = "magboots"
	can_hold_knife = 1
	species_restricted = null
	force = 3
	overshoes = 1
	var/magpulse = 0
	var/icon_base = "magboots"
	action_button_name = "Toggle Magboots"
	var/obj/item/clothing/shoes/shoes = null	//Undershoes
	var/mob/living/carbon/human/wearer = null	//For shoe procs
	center_of_mass = null
	randpixel = 0

/obj/item/clothing/shoes/urfc/magboots/proc/set_slowdown()
	slowdown_per_slot[slot_shoes] = shoes? max(SHOES_SLOWDOWN, shoes.slowdown_per_slot[slot_shoes]): SHOES_SLOWDOWN	//So you can't put on magboots to make you walk faster.
	if (magpulse)
		slowdown_per_slot[slot_shoes] += 3

/obj/item/clothing/shoes/urfc/magboots/attack_self(mob/user)
	if(magpulse)
		item_flags &= ~NOSLIP
		magpulse = 0
		set_slowdown()
		force = 3
		if(icon_base) icon_state = "[icon_base]"
		to_chat(user, "You disable the mag-pulse traction system.")
	else
		item_flags |= NOSLIP
		magpulse = 1
		set_slowdown()
		force = 5
		if(icon_base) icon_state = "[icon_base]"
		to_chat(user, "You enable the mag-pulse traction system.")
	user.update_inv_shoes()	//so our mob-overlays update
	user.update_action_buttons()
	user.update_floating()

/obj/item/clothing/shoes/urfc/magboots/mob_can_equip(mob/user)
	var/mob/living/carbon/human/H = user

	if(H.shoes)
		shoes = H.shoes
		if(shoes.overshoes)
			to_chat(user, "You are unable to wear \the [src] as \the [H.shoes] are in the way.")
			shoes = null
			return 0
		H.drop_from_inventory(shoes)	//Remove the old shoes so you can put on the magboots.
		shoes.forceMove(src)

	if(!..())
		if(shoes) 	//Put the old shoes back on if the check fails.
			if(H.equip_to_slot_if_possible(shoes, slot_shoes))
				src.shoes = null
		return 0

	if (shoes)
		to_chat(user, "You slip \the [src] on over \the [shoes].")
	set_slowdown()
	wearer = H //TODO clean this up
	return 1

/obj/item/clothing/shoes/urfc/magboots/equipped()
	..()
	var/mob/M = src.loc
	if(istype(M))
		M.update_floating()

/obj/item/clothing/shoes/urfc/magboots/dropped()
	..()
	if(!wearer)
		return

	var/mob/living/carbon/human/H = wearer
	if(shoes && istype(H))
		if(!H.equip_to_slot_if_possible(shoes, slot_shoes))
			shoes.forceMove(get_turf(src))
		src.shoes = null
	wearer.update_floating()
	wearer = null

/obj/item/clothing/shoes/urfc/magboots/examine(mob/user)
	. = ..(user)
	var/state = "disabled"
	if(item_flags & NOSLIP)
		state = "enabled"
	to_chat(user, "Its mag-pulse traction system appears to be [state].")

#undef URFC_OVERRIDE
#undef ITEM_INHAND
