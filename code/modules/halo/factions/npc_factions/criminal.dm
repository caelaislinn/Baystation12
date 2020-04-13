
/datum/faction/random_criminal
	defender_mob_types = list(\
		/mob/living/simple_animal/hostile/criminal = 2,\
		/mob/living/simple_animal/hostile/criminal/ranged = 2,\
		/mob/living/simple_animal/hostile/criminal/ranged/space = 1)

/datum/faction/random_criminal/New()
	name = "[random_syndicate_name()]"
	GLOB.criminal_factions.Add(src)
	GLOB.criminal_factions_by_name[name] = src
	. = ..()

/mob/living/simple_animal/hostile/criminal
	name = "\improper Syndicate operative"
	desc = "Death to the Company."
	icon_state = "syndicate"
	icon_living = "syndicate"
	icon_dead = "syndicate_dead"
	icon_gib = "syndicate_gib"
	speed = 4
	maxHealth = 100
	health = 100
	resistance = 10
	harm_intent_damage = 5
	melee_damage_lower = 10
	melee_damage_upper = 10
	attacktext = "punched"
	a_intent = I_HURT
	combat_tier = 2

/mob/living/simple_animal/hostile/criminal/set_faction(var/datum/faction/F)
	. = ..()
	name = "[F.name] operative"

/mob/living/simple_animal/hostile/criminal/ranged
	ranged = 1
	burst_size = 3
	icon_state = "syndicateranged"
	icon_living = "syndicateranged"
	casingtype = /obj/item/ammo_casing/a10mm
	projectilesound = 'sound/weapons/gunshot/gunshot_smg.ogg'
	projectiletype = /obj/item/projectile/bullet/pistol/medium

/mob/living/simple_animal/hostile/criminal/ranged/space
	icon_state = "syndicaterangedpsace"
	icon_living = "syndicaterangedpsace"
	resistance = 15
	combat_tier = 3
