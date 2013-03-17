
//distance is measured in AU
//lol jks its all 1d and directly relates to travel time
/datum/trade_destination/centcomm
	name = "CentComm"
	description = "NanoTrasen's administrative centre for Tau Ceti."
	distance = 1.2
	viable_random_events = list(SECURITY_BREACH, CORPORATE_ATTACK, AI_LIBERATION)
	viable_mundane_events = list(ELECTION, RESIGNATION, CELEBRITY_DEATH)

	//centcomm can be a "trade hub" for now
	orderable_categories_supply = list(\
		"SPECIAL" = 1,\
		"MAINTENANCE" = -1,\
		"BIOMEDICAL" = -1,\
		"ELECTRICAL" = -1,\
		"EMERGENCY" = -1,\
		"CLOTHING" = -1,\
		"ROBOTICS" = -1,\
		"FOOD" = -2,\
		"GAS" = -2,\
		"EVA" = -2,\
		"ADMINISTRATIVE" = -3,\
		"SPECIAL_SECURITY" = -3,\
		"SECURITY" = -3\
		)

/datum/trade_destination/anansi
	name = "NSS Anansi"
	description = "Medical station ran by Second Red Cross (but owned by NT) for handling emergency cases from nearby colonies."
	distance = 1.7
	viable_random_events = list(SECURITY_BREACH, CULT_CELL_REVEALED, BIOHAZARD_OUTBREAK, PIRATES, ALIEN_RAIDERS)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH, BARGAINS, GOSSIP)

	orderable_categories_supply = list(\
		"BIOMEDICAL" = 3,\
		"ROBOTICS" = 2,\
		"EMERGENCY" = -1,\
		"MAINTENANCE" = -1,\
		"REFINED_MINERALS" = -1,\
		"ELECTRICAL" = -1,\
		"EVA" = -1,\
		"FOOD" = -2,\
		"SECURITY" = -2,\
		"GAS" = -2,\
		)
	orderable_types_supply = list(/obj/machinery/portable_atmospherics/canister/sleeping_agent = -3)

/datum/trade_destination/anansi/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the NSS Anansi, Second Red Cross Society wishes to announce a major breakthough in the field of \
		[pick("mind-machine interfacing","neuroscience","nano-augmentation","genetics")]. NanoTrasen is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/icarus
	name = "NMV Icarus"
	description = "Corvette assigned to patrol NSS Exodus local space."
	distance = 0.1
	viable_random_events = list(SECURITY_BREACH, AI_LIBERATION, PIRATES)

	orderable_categories_supply = list(\
		"SECURITY" = -2,\
		"SPECIAL_SECURITY" = -2,\
		"EVA" = -2,\
		"FOOD" = -2,\
		"GAS" = -2,\
		"EMERGENCY" = -1,\
		"MAINTENANCE" = -1,\
		"ELECTRICAL" = -1\
		)

/datum/trade_destination/redolant
	name = "OAV Redolant"
	description = "Osiris Atmospherics station in orbit around the only gas giant insystem. They retain tight control over shipping rights, and Osiris warships protecting their prize are not an uncommon sight in Tau Ceti."
	distance = 0.6
	viable_random_events = list(INDUSTRIAL_ACCIDENT, PIRATES, CORPORATE_ATTACK)
	viable_mundane_events = list(RESEARCH_BREAKTHROUGH, RESEARCH_BREAKTHROUGH)

	orderable_categories_supply = list(\
		"EVA" = -2,\
		"FOOD" = -2,\
		"SECURITY" = -2,\
		"GAS" = -2,\
		"EMERGENCY" = -1,\
		"SPECIAL_SECURITY" = -1,\
		"MAINTENANCE" = -1,\
		"ELECTRICAL" = -1\
		)
	orderable_types_supply = list(/obj/machinery/portable_atmospherics/canister/toxins = 3,\
	/obj/machinery/portable_atmospherics/canister/sleeping_agent = 0)

/datum/trade_destination/redolant/get_custom_eventstring(var/event_type)
	if(event_type == RESEARCH_BREAKTHROUGH)
		return "Thanks to research conducted on the OAV Redolant, Osiris Atmospherics wishes to announce a major breakthough in the field of \
		[pick("plasma research","high energy flux capacitance","super-compressed materials","theoretical particle physics")]. NanoTrasen is expected to announce a co-exploitation deal within the fortnight."
	return null

/datum/trade_destination/beltway
	name = "Beltway mining chain"
	description = "A co-operative effort between Beltway and NanoTrasen to exploit the rich outer asteroid belt of the Tau Ceti system."
	distance = 7.5
	viable_random_events = list(PIRATES, INDUSTRIAL_ACCIDENT)
	viable_mundane_events = list(TOURISM)

	orderable_categories_supply = list(\
		"MINERALS" = 3,\
		"EMERGENCY" = -1,\
		"SECURITY" = -1,\
		"MAINTENANCE" = -1,\
		"ELECTRICAL" = -1,\
		"GAS" = -2,\
		"EVA" = -2,\
		"FOOD" = -2\
		)
	orderable_types_supply = list(/obj/item/weapon/ore/plasma = 1,\
	/obj/machinery/portable_atmospherics/canister/sleeping_agent = 0)

/datum/trade_destination/biesel
	name = "Biesel"
	description = "Large ship yards, strong economy and a stable, well-educated populace, Biesel largely owes allegiance to Sol / Vessel Contracting and begrudgingly tolerates NT. Capital is Lowell City."
	distance = 2.3
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(BARGAINS, GOSSIP, SONG_DEBUT, MOVIE_RELEASE, ELECTION, TOURISM, RESIGNATION, CELEBRITY_DEATH)

	orderable_types_supply = list(\
		"GAS" = 3,\
		"FOOD" = 2,\
		"BIOMEDICAL" = 1,\
		"ADMINISTRATIVE" = 1,\
		"EVA" = 1,\
		"EMERGENCY" = -1,\
		"SECURITY" = -1,\
		"SPECIAL_SECURITY" = -1,\
		"MAINTENANCE" = -1,\
		"ROBOTICS" = -1,\
		"ELECTRICAL" = -1,\
		"REFINED_MINERALS" = -2\
		)
	orderable_types_supply = list(/obj/machinery/portable_atmospherics/canister/toxins = 0)

/datum/trade_destination/new_gibson
	name = "New Gibson"
	description = "Heavily industrialised rocky planet containing the majority of the planet-bound resources in the system, New Gibson is torn by unrest and has very little wealth to call it's own except in the hands of the corporations who jostle with NT for control."
	distance = 6.6
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	viable_mundane_events = list(ELECTION, TOURISM, RESIGNATION)

	orderable_categories_supply = list(\
		"REFINED_MINERALS" = 3,\
		"SECURITY" = 2,\
		"SPECIAL_SECURITY" = 2,\
		"ROBOTICS" = 2,\
		"MAINTENANCE" = 2,\
		"EVA" = 2,\
		"ELECTRICAL" = 2,\
		"ADMINISTRATIVE" = 1,\
		"EMERGENCY" = -1,\
		"BIOMEDICAL" = -2,\
		"MINERALS" = -1,\
		"GAS" = -1,\
		"FOOD" = -3\
		)

/datum/trade_destination/luthien
	name = "Luthien"
	description = "A small colony established on a feral, untamed world (largely jungle). Savages and wild beasts attack the outpost regularly, although NT maintains tight military control."
	distance = 8.9
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

	orderable_categories_supply = list(
		"ANIMAL" = 3,\
		"MINERALS" = 1,\
		"FOOD" = 1,\
		"GAS" = 1,\
		"ROBOTICS" = -1,\
		"MAINTENANCE" = -1,\
		"ELECTRICAL" = -1,\
		"EMERGENCY" = -2,\
		"SECURITY" = -2,\
		"SPECIAL_SECURITY" = -2,\
		"BIOMEDICAL" = -3,\
		)

	orderable_types_supply = list(/obj/machinery/portable_atmospherics/canister/toxins = 0,\
	/obj/machinery/portable_atmospherics/canister/sleeping_agent = 0)

/datum/trade_destination/reade
	name = "Reade"
	description = "A cold, metal-deficient world, NT maintains large pastures in whatever available space in an attempt to salvage something from this profitless colony."
	distance = 7.5
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	viable_mundane_events = list(ELECTION, TOURISM, BIG_GAME_HUNTERS, RESIGNATION)

	orderable_types_supply = list(
		"FOOD" = 3,\
		"ANIMAL" = 1,\
		"GAS" = 1,\
		"BIOMEDICAL" = -1,\
		"ROBOTICS" = -1,\
		"MAINTENANCE" = -1,\
		"ELECTRICAL" = -1\
		)
	orderable_types_supply = list(/obj/machinery/portable_atmospherics/canister/toxins = 0,\
	/obj/machinery/portable_atmospherics/canister/sleeping_agent = 0)
