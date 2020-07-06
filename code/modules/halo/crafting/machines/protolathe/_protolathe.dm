
/obj/machinery/research/protolathe
	name = "\improper protolathe"
	icon_state = "protolathe"
	flags = OPENCONTAINER

	var/max_storage = 100000

	var/list/design_queue = list()

	var/list/all_designs = list()
	var/list/designs_by_name = list()

	var/output_dir = 0

	var/datum/research_design/currently_selected

	var/mat_efficiency = 1
	var/speed = 1
	var/craft_parallel = 1
	var/instant_ready = TRUE

/obj/machinery/research/protolathe/New()
	. = ..()

	//internal components
	//todo: make this buildable (override the protolathe circuitboard)
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/protolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)

	//update the stats
	RefreshParts()

	//initialize the ui
	ui_SelectDesign()

/obj/machinery/research/protolathe/Initialize()
	..()

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/research/protolathe/LateInitialize()

	/*
	//for testing
	all_designs = GLOB.all_designs.Copy()
	designs_by_name = GLOB.designs_by_name.Copy()
	*/

	//setup the UI
	for(var/datum/research_design/D in all_designs)
		ui_AddDesign(D)

/obj/machinery/research/protolathe/RefreshParts()

	//work out chemical storage
	var/reagent_volume = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		reagent_volume += G.reagents.maximum_volume
	create_reagents(reagent_volume)

	//work out material storage
	max_storage = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		max_storage += M.rating * 30

	//work out the speed and efficiency
	var/manipulation = 0
	craft_parallel = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		manipulation += M.rating
		craft_parallel += M.rating / 2
	mat_efficiency = 1 - (manipulation - 2) / 8
	speed = manipulation / 2

/obj/machinery/research/protolathe/examine(var/mob/user)
	. = ..()
	if(output_dir)
		to_chat(user,"<span class='info'>It is set to output to the [dir2text(output_dir)]</span>")
	else
		to_chat(user,"<span class='info'>It is set to output to it's own tile.</span>")