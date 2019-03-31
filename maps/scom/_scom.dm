
#if !defined(using_map_DATUM)

	#include "../geminus_city/areas.dm"
	#include "../geminus_city/geminus_city_overmap.dm"
	#include "../geminus_city/geminuscity_2.dmm"
	#include "../geminus_city/geminuscity_3.dmm"
	#include "spawns.dm"
	#include "alien_items.dm"
	#include "species.dm"
	#include "overmap.dm"
	#include "gamemode.dm"
	#include "outfit_alien.dm"
	#include "jobs_alien.dm"
	#include "jobs_human.dm"
	#include "outfit_scom.dm"
	#include "outfit_geminus_colonist.dm"

	#define using_map_DATUM /datum/map/scom_project

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring SCOM-GeminusCity

#endif
