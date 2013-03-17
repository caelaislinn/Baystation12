var/datum/controller/global_market/economy_controller = new()

/*
var/setup_economy = 0
/proc/setup_economy()
	if(setup_economy)
		return
	var/datum/feed_channel/newChannel = new /datum/feed_channel
	newChannel.channel_name = "Tau Ceti Daily"
	newChannel.author = "CentComm Minister of Information"
	newChannel.locked = 1
	newChannel.is_admin_channel = 1
	news_network.network_channels += newChannel

	newChannel = new /datum/feed_channel
	newChannel.channel_name = "The Gibson Gazette"
	newChannel.author = "Editor Mike Hammers"
	newChannel.locked = 1
	newChannel.is_admin_channel = 1
	news_network.network_channels += newChannel

	for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
		var/datum/trade_destination/D = new loc_type
		weighted_randomevent_locations[D] = D.viable_random_events.len
		weighted_mundaneevent_locations[D] = D.viable_mundane_events.len

	setup_economy = 1*/

var/global/current_date_string
var/global/datum/feed_channel/tau_ceti_newsfeed = new /datum/feed_channel
var/global/datum/feed_channel/gibson_gazette_newsfeed = new /datum/feed_channel

datum/controller/global_market
	//controller
	var/processing = 0
	var/processing_interval = 600	//60 second interval, because we don't need frequent updates
	var/process_cost = 0
	var/iteration = 0

	//accounts
	var/num_financial_terminals = 1
	var/next_account_number = 0
	var/list/accounts = list()
	var/list/department_accounts = list()
	var/datum/money_account/station_account
	var/next_receipt_num = 1
	var/next_sales_num = 1

	//trade destinations
	var/list/trade_destinations = list()

	//events
	var/list/weighted_randomevent_locations = list()
	var/list/weighted_mundaneevent_locations = list()

	var/global_industrysupply_pricemod = 0.1
	var/global_industrydemand_pricemod = 10

datum/controller/global_market/proc/goods_strings(var/ind)
	switch(ind)
		if(SPECIAL)
			return "SPECIAL"
		if(ADMINISTRATIVE)
			return "ADMINISTRATIVE"
		if(CLOTHING)
			return "CLOTHING"
		if(SECURITY)
			return "SECURITY"
		if(SPECIAL_SECURITY)
			return "SPECIAL_SECURITY"
		if(FOOD)
			return "FOOD"
		if(ANIMALS)
			return "ANIMALS"
		if(MINERALS)
			return "MINERALS"
		/*if(REFINED_MINERALS)
			return "REFINED_MINERALS"*/	//todo, it'll take 5 seconds promise
		if(EMERGENCY)
			return "EMERGENCY"
		if(GAS)
			return "GAS"
		if(MAINTENANCE)
			return "MAINTENANCE"
		if(ELECTRICAL)
			return "ELECTRICAL"
		if(ROBOTICS)
			return "ROBOTICS"
		if(BIOMEDICAL)
			return "BIOMEDICAL"
		if(EVA)
			return "EVA"
datum/controller/global_market/proc/strings_goods(var/ind)
	switch(ind)
		if("SPECIAL")
			return SPECIAL
		if("ADMINISTRATIVE")
			return ADMINISTRATIVE
		if("CLOTHING")
			return CLOTHING
		if("SECURITY")
			return SECURITY
		if("SPECIAL_SECURITY")
			return SPECIAL_SECURITY
		if("FOOD")
			return FOOD
		if("ANIMALS")
			return ANIMALS
		if("MINERALS")
			return MINERALS
		/*if("REFINED_MINERALS")
			return REFINED_MINERALS*/	//todo, it'll take 5 seconds promise
		if("EMERGENCY")
			return EMERGENCY
		if("GAS")
			return GAS
		if("MAINTENANCE")
			return MAINTENANCE
		if("ELECTRICAL")
			return ELECTRICAL
		if("ROBOTICS")
			return ROBOTICS
		if("BIOMEDICAL")
			return BIOMEDICAL
		if("EVA")
			return EVA

//gracefully take over an existing controller, if it exists
datum/controller/global_market/New()
	if(economy_controller != src)
		if(istype(economy_controller,/datum/controller/global_market))
			Recover()
			del(economy_controller)
		economy_controller = src

datum/controller/global_market/proc/Initialize()
	processing = 0
	spawn(-1)
		set background = 1


		//---- setup the financial accounts

		create_station_account()
		for(var/department in station_departments)
			create_department_account(department)


		//---- setup the newsfeeds

		if(!tau_ceti_newsfeed || tau_ceti_newsfeed.type != /datum/feed_channel)
			tau_ceti_newsfeed = new /datum/feed_channel
		tau_ceti_newsfeed.channel_name = "Tau Ceti Daily"
		tau_ceti_newsfeed.author = "CentComm Minister of Information"
		tau_ceti_newsfeed.locked = 1
		tau_ceti_newsfeed.is_admin_channel = 1
		news_network.network_channels += tau_ceti_newsfeed

		if(!gibson_gazette_newsfeed || gibson_gazette_newsfeed.type != /datum/feed_channel)
			gibson_gazette_newsfeed = new /datum/feed_channel
		gibson_gazette_newsfeed = new /datum/feed_channel
		gibson_gazette_newsfeed.channel_name = "The Gibson Gazette"
		gibson_gazette_newsfeed.author = "Editor Mike Hammers"
		gibson_gazette_newsfeed.locked = 1
		gibson_gazette_newsfeed.is_admin_channel = 1
		news_network.network_channels += gibson_gazette_newsfeed


		//---- setup the trading and random events system

		for(var/loc_type in typesof(/datum/trade_destination) - /datum/trade_destination)
			var/datum/trade_destination/D = new loc_type
			trade_destinations.Add(D)
			weighted_randomevent_locations[D] = D.viable_random_events.len
			weighted_mundaneevent_locations[D] = D.viable_mundane_events.len


		//---- Misc

		current_date_string = "[num2text(rand(1,31))] [pick("January","February","March","April","May","June","July","August","September","October","November","December")], 2557"
		next_sales_num = rand(1,500)

//todo: is this needed?
datum/controller/global_market/proc/Recover()
	//

datum/controller/global_market/proc/process()
	processing = 1
	spawn(0)
		set background = 1
		while(1)
			if(processing)
				iteration++
				var/started = world.timeofday

				//sleep(-1)
				for(var/datum/trade_destination/D in trade_destinations)
					sleep(-1)
					D.DelayedUpdate()

				process_cost = (world.timeofday - started)
			sleep(processing_interval)

datum/controller/global_market/proc/GetNextAccountNum()
	var/out = next_account_number
	next_account_number += rand(1,25)
	return out

datum/controller/global_market/proc/GetNextReceiptNum()
	var/out = next_receipt_num
	next_receipt_num += 1
	return out

datum/controller/global_market/proc/GetNextSalesNum()
	var/out = next_sales_num
	next_sales_num += rand(1,50)
	return out
