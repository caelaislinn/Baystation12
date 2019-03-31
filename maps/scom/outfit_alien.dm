
/decl/hierarchy/outfit/xray/sectoid
	uniform = /obj/item/clothing/under/xray
	shoes = /obj/item/clothing/shoes/swat/xray
	suit = /obj/item/clothing/suit/xray
	head = /obj/item/clothing/head/xray
	l_ear = /obj/item/device/radio/headset/covenant

/decl/hierarchy/outfit/xray/sectoid/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/weapon/gun/projectile/needler

/decl/hierarchy/outfit/xray/sectoid
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma

/decl/hierarchy/outfit/xray/thin_man/pre_equip(mob/living/carbon/human/H)
	if(prob(50))
		r_hand = pick(\
			/obj/item/weapon/gun/energy/plasmapistol,\
			/obj/item/weapon/gun/projectile/needler)
		l_hand = /obj/item/clothing/gloves/shield_gauntlet
	else
		r_hand = pick(\
			/obj/item/weapon/gun/projectile/type51carbine,\
			/obj/item/weapon/gun/energy/beam_rifle)

/decl/hierarchy/outfit/xray/thin_man
	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma

/decl/hierarchy/outfit/xray/muton
	r_hand = /obj/item/weapon/gun/energy/plasmarifle
	l_hand = /obj/item/weapon/gun/energy/plasmarifle

	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma
	belt = /obj/item/weapon/melee/energy/elite_sword

/decl/hierarchy/outfit/xray/chryssalid
	r_hand = /obj/item/weapon/melee/energy/elite_sword
	l_hand = /obj/item/weapon/melee/energy/elite_sword

/decl/hierarchy/outfit/xray/ethereal
	r_hand = /obj/item/weapon/gun/energy/plasmarifle/brute
	l_hand = /obj/item/weapon/gun/energy/plasmarifle/brute

	l_pocket = /obj/item/weapon/grenade/plasma
	r_pocket = /obj/item/weapon/grenade/plasma
