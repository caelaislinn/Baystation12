
/datum/game_mode/opredflag
	name = "Operation: Red Flag"
	config_tag = "opredflag"
	round_description = "The UNSC Spartan-IIs are dispatched to take down a Covenant Prophet."
	extended_round_description = "Everyone single Spartan II has been summoned from the far reaches of space. \
		Their mission is to board a Covenant battlecruiser and identify then terminate one of the Covenant's religous leaders... a Prophet."

	end_on_antag_death = 1
	round_autoantag = 1
	required_players = 0
	required_enemies = 1
	antag_tags = list("prophet")
	latejoin_antag_tags = list("hunter")

	var/elite_shipmaster
	var/elite_shipmaster_ckey
	var/spartan_commander
	var/spartan_commander_ckey

	var/list/living_prophets = list()
	var/list/dead_prophets = list()

	var/list/living_spartans = list()
	var/list/dead_spartans = list()

	var/round_start = 0
	var/round_completion_delay = 0

/datum/game_mode/opredflag/pre_setup()
	//world << "/datum/game_mode/opredflag/pre_setup()"
	var/retval = ..()
	. = retval

	round_start = world.time

	//grab the prophets
	for(var/datum/antagonist/opredflag_prophet/prophets in antag_templates)
		//world << "	check1"
		for(var/datum/mind/D in prophets.current_antagonists)
			//world << "	[D] ([D.ckey])"
			living_prophets.Add(D)

	//grab the spartan list
	var/datum/job/spartans = job_master.occupations_by_title["Spartan II"]
	living_spartans = spartans.assigned_players
	spartans = job_master.occupations_by_title["Spartan II Commander"]
	living_spartans += spartans.assigned_players

	//dont let spartans latejoin
	spartans.total_positions = -1

/datum/game_mode/opredflag/fail_setup()
	. = ..()

	//let spartans join again
	var/datum/job/spartans = job_master.occupations_by_title["Spartan II"]
	spartans.total_positions = -1

/datum/game_mode/opredflag/post_setup()
	. = ..()

	//grab some stuff we need for round completion

	//grab the elite shipmaster
	var/datum/job/opredflag_elite/shipmaster = job_master.occupations_by_title["Sangheili Shipmaster"]
	for(var/mob/M in shipmaster.assigned_players)
		elite_shipmaster = M.name
		elite_shipmaster_ckey = M.ckey
		break

	//grab the spartan commander
	var/datum/job/opredflag_spartan/commander = job_master.occupations_by_title["Spartan II Commander"]
	commander.total_positions = -1
	for(var/mob/M in commander.assigned_players)
		spartan_commander = M.name
		spartan_commander_ckey = M.ckey
		break

/datum/game_mode/opredflag/get_respawn_time()
	return 0.5		//minutes

/datum/game_mode/opredflag/handle_mob_death(var/mob/M, var/list/args = list())
	if(istype(M, /mob/living/simple_animal/prophet))
		living_prophets -= M
		dead_prophets += M
		return 1

	if(istype(M, /mob/living/carbon/human/spartan))
		living_spartans -= M
		dead_spartans += M
		return 1

	return ..()

/datum/game_mode/opredflag/check_finished()
	//dont finish the game for the first 15 seconds
	if(world.time < round_start + round_completion_delay)
		return 0

	if(!living_prophets.len)
		return 1
	if(!living_spartans.len)
		return 1

	return 0

/datum/game_mode/opredflag/declare_completion()
	var/text = ""
	if(!living_prophets.len)
		text += "All Prophets were slain!<br>"

	text += "The Prophets were:<br>"
	for(var/datum/mind/D in living_prophets)
		text += "<br>[D] (played by [D.ckey])"
	for(var/mob/living/simple_animal/P in dead_prophets)
		text += "<br>[P] (played by [P.ckey])(slain)"
	text += "<br>"
	text += "The Elite Shipmaster was [elite_shipmaster] (played by [elite_shipmaster_ckey])<br>"

	text += "The Spartan 2 commander was [spartan_commander] (played by [spartan_commander_ckey])<br>"
	if(!living_spartans.len)
		text = "All Spartans have failed to return!<br>"
	text += "The Spartan IIs were:<br>"
	for(var/mob/M in living_spartans)
		text += "<br>[M] (played by [M.ckey])"
	for(var/mob/M in dead_spartans)
		text += "<br>[M] (played by [M.ckey])(MIA)"
	text += "<br>"

	if(!living_prophets.len)
		if(living_spartans.len)
			text += "UNSC Major Victory"
		else
			text += "UNSC Pyrrhic Victory"
	else if(living_spartans.len)
		text += "Covenant Minor Victory"
	else
		text += "Covenant Major Victory"

	to_world(text)

	return 0
