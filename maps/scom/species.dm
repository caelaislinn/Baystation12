
/datum/species/human
	appearance_flags = 0

/mob/living/carbon/human
	var/override_icon// = 'icons/mob/human.dmi'
	var/override_icon_state// = "blank"

/datum/species/xray
	var/override_icon
	var/override_icon_state = "preview"
	flesh_color = "#4A4A64"
	blood_color = "#4A4A64"
	var/size_multiplier = 0.5
	var/damage_multiplier = 0.5
	appearance_flags = 0

/datum/species/xray/handle_pre_spawn(var/mob/living/carbon/human/H)
	H.override_icon = src.override_icon
	H.override_icon_state = src.override_icon_state
	H.size_multiplier = src.size_multiplier
	H.damage_multiplier = src.damage_multiplier

/datum/species/xray/get_random_name(var/gender)
	return "[name] ([rand(100,999)])"

/datum/species/xray/sectoid
	name = "Sectoid"
	override_icon = 'sectoid.dmi'
	icobase = 'sectoid.dmi'
	deform = 'sectoid.dmi'
	icon_template = 'sectoid.dmi'
	total_health = 150

/datum/species/xray/thin_man
	name = "Thin Man"
	override_icon = 'thin_man.dmi'
	icobase = 'thin_man.dmi'
	deform = 'thin_man.dmi'
	icon_template = 'thin_man.dmi'
	damage_multiplier = 1
	slowdown = -1

/datum/species/xray/muton
	name = "Muton"
	override_icon = 'muton.dmi'
	icobase = 'muton.dmi'
	deform = 'muton.dmi'
	icon_template = 'muton.dmi'
	damage_multiplier = 1.5
	inherent_verbs = list(/mob/living/carbon/human/proc/dual_wield_weapons)
	total_health = 300

/datum/species/xray/chryssalid
	name = "Chryssalid"
	override_icon = 'chryssalid.dmi'
	icobase = 'chryssalid.dmi'
	deform = 'chryssalid.dmi'
	icon_template = 'chryssalid.dmi'
	damage_multiplier = 1.5
	inherent_verbs = list(/mob/living/carbon/human/proc/dual_wield_weapons)
	total_health = 300
	slowdown = -3

/datum/species/xray/ethereal
	name = "Ethereal"
	override_icon = 'ethereal.dmi'
	icobase = 'ethereal.dmi'
	deform = 'ethereal.dmi'
	icon_template = 'ethereal.dmi'
	inherent_verbs = list(/mob/living/carbon/human/proc/dual_wield_weapons)
