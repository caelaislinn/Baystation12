
/decl/hierarchy/outfit/scom
	uniform = /obj/item/clothing/under/tactical
	suit = /obj/item/clothing/suit/storage/vest/solgov
	shoes = /obj/item/clothing/shoes/swat
	gloves = /obj/item/clothing/gloves/thick/swat
	head = /obj/item/clothing/head/helmet/tactical
	l_ear = /obj/item/device/radio/headset
	belt = /obj/item/weapon/storage/belt/marine_ammo
	back = /obj/item/weapon/storage/backpack/dufflebag
	flags = OUTFIT_HAS_BACKPACK

/decl/hierarchy/outfit/scom/commander
	suit = /obj/item/clothing/suit/storage/vest/solgov/command
	head = /obj/item/clothing/head/beret/sol/expedition/security

	r_hand = /obj/item/weapon/gun/projectile/br85
	l_pocket = /obj/item/ammo_magazine/m95_sap
	r_pocket = /obj/item/ammo_magazine/m95_sap

	backpack_contents = list(\
		/obj/item/weapon/gun/projectile/m6d_magnum = 1,\
		/obj/item/ammo_magazine/m127_saphe = 1,\
		/obj/item/weapon/material/knife/combat_knife = 1\
	)
/decl/hierarchy/outfit/scom/squad_leader
	suit = /obj/item/clothing/suit/storage/vest/solgov/security
	head = /obj/item/clothing/head/helmet/tactical/mirania

	r_hand = /obj/item/weapon/gun/projectile/br85
	l_pocket = /obj/item/ammo_magazine/m95_sap
	r_pocket = /obj/item/ammo_magazine/m95_sap

	backpack_contents = list(\
		/obj/item/weapon/gun/projectile/m6d_magnum = 1,\
		/obj/item/ammo_magazine/m127_saphe = 1,\
		/obj/item/weapon/material/knife/combat_knife = 1\
	)

/decl/hierarchy/outfit/scom/support
	r_hand = /obj/item/weapon/gun/projectile/ma5b_ar
	l_hand = /obj/item/weapon/storage/firstaid/combat
	belt = /obj/item/weapon/storage/firstaid/adv
	suit_store = /obj/item/weapon/reagent_containers/syringe/biofoam
	l_pocket = /obj/item/ammo_magazine/m762_ap/MA5B
	r_pocket = /obj/item/ammo_magazine/m762_ap/MA5B
	backpack_contents = list(\
		/obj/item/weapon/storage/firstaid/combat = 1,\
		/obj/item/weapon/storage/firstaid/adv = 1,\
		/obj/item/weapon/storage/firstaid/regular = 1,\
		/obj/item/weapon/reagent_containers/syringe/ld50_syringe/triadrenaline = 1,\
		/obj/item/weapon/storage/pill_bottle/iron = 1,\
		/obj/item/weapon/reagent_containers/syringe/biofoam = 1,\
		/obj/item/weapon/material/knife/combat_knife = 1\
	)

/decl/hierarchy/outfit/scom/assault
	r_hand = /obj/item/weapon/gun/projectile/shotgun/pump/m90_ts
	l_pocket = /obj/item/ammo_box/shotgun
	r_pocket = /obj/item/ammo_box/shotgun/slug

	backpack_contents = list(\
		/obj/item/weapon/gun/projectile/m6d_magnum = 1,\
		/obj/item/ammo_magazine/m127_saphe = 1,\
		/obj/item/weapon/material/knife/combat_knife = 1\
	)
	suit_store = /obj/item/weapon/grenade/frag/m9_hedp

/decl/hierarchy/outfit/scom/heavy
	r_hand = /obj/item/weapon/gun/projectile/m739_lmg
	l_hand = /obj/item/weapon/gun/launcher/rocket/m41_ssr
	l_pocket = /obj/item/ammo_magazine/a762_box_ap
	r_pocket = /obj/item/ammo_magazine/a762_box_ap

	backpack_contents = list(\
		/obj/item/ammo_casing/rocket = 2,\
		/obj/item/weapon/grenade/frag/m9_hedp = 2,\
		/obj/item/weapon/material/knife/combat_knife = 1\
		)

/decl/hierarchy/outfit/scom/sniper
	r_hand = /obj/item/weapon/gun/projectile/srs99_sniper
	l_pocket = /obj/item/ammo_magazine/m145_ap
	r_pocket = /obj/item/ammo_magazine/m145_ap

	backpack_contents = list(\
		/obj/item/weapon/gun/projectile/m6d_magnum = 1,\
		/obj/item/ammo_magazine/m127_saphe = 1,\
		/obj/item/weapon/material/knife/combat_knife = 1\
	)
