
/datum/faction
	var/list/base_techprints = list()
	var/list/base_designs = list()

/datum/faction/proc/get_base_techprints()
	return base_techprints.Copy()

/datum/faction/proc/get_base_designs()
	return base_techprints.Copy()

/datum/faction/unsc
	base_techprints = list(\
		/datum/techprint/unknown,\
		/datum/techprint/nanolaminate,\
		/datum/techprint/kemocite,\
		/datum/techprint/duridium,\
		/datum/techprint/corundum,\
		/datum/techprint/holo,\
		/datum/techprint/liquid_nanocrystal,\
		/datum/techprint/ablative,\
		/datum/techprint/energy,\
		/datum/techprint/armour_compact_one)