
/obj/machinery/computer/rust_radiation_monitor
	name = "Radiation Monitor"
	icon = 'icons/rust.dmi'
	icon_state = "scram"

	var/ambient_lightrads = 0
	var/ambient_heavyrads = 0

	var/list/tenticks_lightrads = list()
	var/list/tenticks_heavyrads = list()

	var/list/hundredticks_lightrads = list()
	var/list/hundredticks_heavyrads = list()

	var/ticks_left_hundred = 9

/obj/machinery/computer/rust_radiation_monitor/New()
	..()

	while(tenticks_lightrads.len < 10)
		tenticks_lightrads.Add(0)
	while(tenticks_heavyrads.len < 10)
		tenticks_heavyrads.Add(0)
	//
	while(hundredticks_lightrads.len < 10)
		hundredticks_lightrads.Add(0)
	while(hundredticks_heavyrads.len < 10)
		hundredticks_heavyrads.Add(0)

/obj/machinery/computer/rust_radiation_monitor/process()

	//update our ambient counters
	tenticks_lightrads.Add(round(ambient_lightrads))
	if(tenticks_lightrads.len > 10)
		tenticks_lightrads.Cut(1,2)
	ambient_lightrads = 0
	//
	tenticks_heavyrads.Add(round(ambient_heavyrads))
	if(tenticks_heavyrads.len > 10)
		tenticks_heavyrads.Cut(1,2)
	ambient_heavyrads = 0

	//every 10 ticks, update our longer term tracker by averaging the past 10 ticks
	ticks_left_hundred -= 1
	if(ticks_left_hundred <= 0)
		ticks_left_hundred = 10

		var/totalrads = 0
		for(var/amount in tenticks_lightrads)
			totalrads += amount
		hundredticks_lightrads.Add(round(totalrads / 10))
		if(hundredticks_lightrads.len > 10)
			hundredticks_lightrads.Cut(1,2)
		//
		totalrads = 0
		for(var/amount in tenticks_heavyrads)
			totalrads += amount
		hundredticks_heavyrads.Add(round(totalrads / 10))
		if(hundredticks_heavyrads.len > 10)
			hundredticks_heavyrads.Cut(1,2)

/obj/machinery/computer/rust_radiation_monitor/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/computer/rust_radiation_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/list/data = list()

	data["tenticks_lightrads"] = tenticks_lightrads
	data["tenticks_heavyrads"] = tenticks_heavyrads

	data["hundredticks_lightrads"] = hundredticks_lightrads
	data["hundredticks_heavyrads"] = hundredticks_heavyrads


	// update the ui with data if it exists, returns null if no ui is passed/found or if force_open is 1/true
	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		// the ui does not exist, so we'll create a new() one
		// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "radiation_monitor.tmpl", "RUST Radiation Monitor", 750, 300)

		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)

		// open the new ui window
		ui.open()

		// auto update every Master Controller tick
		ui.set_auto_update(1)
