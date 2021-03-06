
/datum/map/scom_project
	name = "Sol System"
	full_name = "Geminus City Colony"
	system_name = "Geminus City"
	path = "scom_project"
	//lobby_icon = 'maps/example/example_lobby.dmi'
	lobby_icon = 'scom_final.png'
	//id_hud_icons = '../first_contact/maps/UNSC_Heaven_Above/frigate_hud_icons.dmi'
	station_networks = list("Exodus")
	station_name  = "Geminus City"
	station_short = "Geminus City"
	dock_name     = "Space Elevator"
	boss_name     = "First Speaker"
	boss_short    = "First Speaker"
	company_name  = "SCOM Project"
	company_short = "SCOM Project"

	allowed_jobs = list(\
		/datum/job/xray/sectoid,\
		/datum/job/xray/thin_man,\
		/datum/job/xray/muton,\
		/datum/job/xray/chryssalid,\
		/datum/job/xray/ethereal,\
		//
		/datum/job/scom/commander,\
		/datum/job/scom/squad_leader,\
		/datum/job/scom/assault,\
		/datum/job/scom/heavy,\
		/datum/job/scom/sniper,\
		/datum/job/scom/support,\
		//
		/datum/job/colonist\
	)

	allowed_spawns = list(\
		"SCOM Spawns",\
		"XRAY Spawns",\
		"Geminus Colonist Spawns")

	default_spawn = "Geminus Colonist Spawns"

/datum/map/scom_project/New()
	. = ..()

/lobby_music/breaking_ground
	artist = "Michael McCann"
	title = "Breaking Ground"
	album = "XCOM Enemy Unknown OST"
	song = 'breaking_ground.ogg'
