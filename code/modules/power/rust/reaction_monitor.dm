
/obj/machinery/computer/rust_reaction_monitor
	name = "RUST Reaction Monitor"
	icon = 'icons/rust.dmi'
	icon_state = "core_control"
	var/list/connected_devices = list()
	var/id_tag = ""
	var/scan_range = 25

	//currently viewed
	var/obj/machinery/power/rust_core/cur_viewed_device

/obj/machinery/computer/rust_reaction_monitor/attack_hand(mob/user as mob)
	if(!cur_viewed_device)
		cur_viewed_device = locate() in range(50)
	ui_interact(user)

/obj/machinery/computer/rust_reaction_monitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(cur_viewed_device && cur_viewed_device.owned_field)
		var/list/data = list()

		data["reactionChartValues"] = cur_viewed_device.owned_field.reaction_tensec
		data["excitationChartValues"] = cur_viewed_device.owned_field.excitation_tensec

		// update the ui with data if it exists, returns null if no ui is passed/found or if force_open is 1/true
		ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

		if (!ui)
			// the ui does not exist, so we'll create a new() one
			// for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
			ui = new(user, src, ui_key, "reaction_monitor.tmpl", "RUST Reaction Monitor", 520, 410)

			// when the ui is first opened this is the data it will use
			ui.set_initial_data(data)

			// open the new ui window
			ui.open()

			// auto update every Master Controller tick
			ui.set_auto_update(1)
