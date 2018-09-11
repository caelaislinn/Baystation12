/datum/species/sangheili
	name = "Sangheili"
	name_plural = "Sangheili"
	blurb = ""
	flesh_color = "#4A4A64"
	blood_color = "#4A4A64"
	icobase = 'code/modules/halo/icons/species/r_elite.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_elite.dmi'
	icon_template = 'code/modules/halo/icons/species/r_elite_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	flags = NO_MINOR_CUT
	total_health = 250 // Stronger than humans at base health.
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	spawn_flags = SPECIES_CAN_JOIN
	brute_mod = 0.9
	pain_mod = 0.5 //Pain has half an effect on them.
	slowdown = -1 //negates noshoes
	item_icon_offsets = list(-1,2)

	has_organ = list(
	BP_HEART =    /obj/item/organ/internal/heart,
	"second heart" =	 /obj/item/organ/heart_secondary,
	BP_LUNGS =    /obj/item/organ/internal/lungs,
	BP_LIVER =    /obj/item/organ/internal/liver,
	BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
	BP_BRAIN =    /obj/item/organ/internal/brain,
	BP_APPENDIX = /obj/item/organ/internal/appendix,
	BP_EYES =     /obj/item/organ/internal/eyes
	)

/datum/species/sangheili/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	return

/datum/species/sangheili/get_random_name(var/gender)
	var/newname = pick(GLOB.first_names_sangheili)
	newname += " "
	newname += pick(GLOB.last_names_sangheili)
	return newname

// Species appearance flags
#define HAS_SKIN_TONE     0x1    // Skin tone selectable in chargen. (0-255)
#define HAS_SKIN_COLOR    0x2    // Skin colour selectable in chargen. (RGB)
#define HAS_LIPS          0x4    // Lips are drawn onto the mob icon. (lipstick)
#define HAS_UNDERWEAR     0x8    // Underwear is drawn onto the mob icon.
#define HAS_EYE_COLOR     0x10   // Eye colour selectable in chargen. (RGB)
#define HAS_HAIR_COLOR    0x20   // Hair colour selectable in chargen. (RGB)
#define RADIATION_GLOWS   0x40   // Radiation causes this character to glow.
