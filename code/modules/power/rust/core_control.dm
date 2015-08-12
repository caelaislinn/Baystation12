
/obj/machinery/computer/rust_core_control
	name = "RUST Core Control"
	icon = 'icons/rust.dmi'
	icon_state = "core_control"
	var/list/connected_devices = list()
	var/id_tag = ""
	var/scan_range = 25

	//currently viewed
	var/obj/machinery/power/rust_core/cur_viewed_device

/obj/machinery/computer/rust_core_control/process()
	if(stat & (BROKEN|NOPOWER))
		return

/obj/machinery/computer/rust_core_control/attack_ai(mob/user)
	attack_hand(user)

/obj/machinery/computer/rust_core_control/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

//todo: replace this with nanoui
/obj/machinery/computer/rust_core_control/interact(mob/user)
	if(stat & BROKEN)
		user.unset_machine()
		user << browse(null, "window=core_control")
		return
	if (!istype(user, /mob/living/silicon) && (get_dist(src, user) > 1 ))
		user.unset_machine()
		user << browse(null, "window=core_control")
		return

	var/dat = ""
	if(stat & NOPOWER)
		dat += "<i>The console is dark and nonresponsive.</i>"
	else
		dat += "<B>Reactor Core Primary Monitor</B><BR>"
		if(cur_viewed_device && cur_viewed_device.stat & (BROKEN|NOPOWER))
			cur_viewed_device = null
		if(cur_viewed_device && !cur_viewed_device.remote_access_enabled)
			cur_viewed_device = null

		if(cur_viewed_device)
			var/obj/effect/rust_em_field/viewed_field = cur_viewed_device.owned_field
			dat += "<b>Device tag:</b> [cur_viewed_device.id_tag ? cur_viewed_device.id_tag : "UNSET"]<br>"
			dat += "<font color=blue>Device [viewed_field ? "activated" : "deactivated"].</font><br>"
			dat += "<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];toggle_active=1'>\[Bring field [viewed_field ? "offline" : "online"]\]</a><br>"
			dat += "<b>Device [cur_viewed_device.anchored ? "secured" : "unsecured"].</b><br>"
			dat += "<hr>"
			dat += "<b>Field status:</b> [viewed_field ? "Active" : "Inactive"]<br>"

			dat += "<b>Power status: </b>"
			if(cur_viewed_device.stat & NOPOWER)
				dat += "Insufficient"
			else
				dat += "Good"
			dat += "<br>"

			//todo: put in notched sliders here
			dat += "<b>Field strength:</b> [cur_viewed_device.field_strength] T<br>"
			dat += "\
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];str=-10'>\[---\]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];str=-1'>\[ - \]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];str=1'>\[ + \]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];str=10'>\[+++\]</a> \
			<br>"
			dat += "<b>Field frequency:</b> [cur_viewed_device.field_frequency] GHz<br>"
			dat += "\
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];freq=-10'>\[---\]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];freq=-1'>\[ - \]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];freq=1'>\[ + \]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];freq=10'>\[+++\]</a> \
			<br>"
			dat += "<b>Field projection:</b> [cur_viewed_device.field_projection] m<br>"
			dat += "\
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];proj=-10'>\[---\]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];proj=-1'>\[ - \]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];proj=1'>\[ + \]</a> \
			<a href='?src=\ref[cur_viewed_device];extern_update=\ref[src];proj=10'>\[+++\]</a> \
			<br>"

			if(viewed_field)

				dat += "<br>"

				dat += "<b>Vessel status: </b>"
				if(viewed_field.sufficient_core_size < 1)
					dat += "Insufficient size for field([round(100 * viewed_field.sufficient_core_size, 0.01)]%)"
				else
					dat += "Good"
				dat += "<br>"
				dat += "<b>Field volume:</b> [viewed_field.field_volume] L"

				dat += "<br>"

				dat += "<br>"

				dat += "<b>Total fuel:</b> [viewed_field.total_fuel] units<br>"
				dat += "<b>Fuel density:</b> [viewed_field.fuel_density] units/L ([round(100 * viewed_field.fuel_density / RUST_FUEL_PER_LITRE, 0.0001)]%)<br>"
				var/fuel_wastage = 0
				if(viewed_field.total_fuel > 0)
					fuel_wastage = round( 100 * viewed_field.average_fuel_wastage / viewed_field.total_fuel, 0.0001)
				dat += "<b>Fuel wastage:</b> [viewed_field.average_fuel_wastage] units/second ([fuel_wastage]%)<br>"
				dat += "<b>Excitation level:</b> [round(viewed_field.archived_excitation_level / 10, 0.01)]%<br>"

				dat += "<br>"

				var/phoron_fill = 0
				if(viewed_field.held_phoron_max > 0)
					phoron_fill = round(100 * viewed_field.held_phoron.total_moles / viewed_field.held_phoron_max, 0.0001)
				dat += "<b>Suspended phoron:</b> [round(viewed_field.held_phoron.total_moles)] / [round(viewed_field.held_phoron_max)] moles ([phoron_fill]%)<br>"
				dat += "<b>Field temperature:</b> [viewed_field.held_phoron.temperature] K"

				dat += "<br>"

				dat += "<b>Energy:</b> [viewed_field.total_energy] MeV<br>"
				dat += "<b>Energy density:</b> [viewed_field.energy_density] MeV/L ([round(100 * viewed_field.energy_density / viewed_field.energy_density_threshold, 0.0001)]%)<br>"
				//note: the actual amount of reactions may differ from the % of fuel consumption
				var/reaction_rate = 0
				if(viewed_field.total_fuel > 0)
					reaction_rate = round(100 * viewed_field.reacted_this_cycle / viewed_field.total_fuel, 0.0001)
				dat += "<b>Amount of fuel reacting:</b> [reaction_rate]%"

		else
			dat += "<a href='?src=\ref[src];scan=1'>\[Refresh device list\]</a><br><br>"
			if(connected_devices.len)
				dat += "<table width='100%' border=1>"
				dat += "<tr>"
				dat += "<td><b>Device tag</b></td>"
				dat += "<td></td>"
				dat += "</tr>"
				for(var/obj/machinery/power/rust_core/C in connected_devices)
					if(!check_core_status(C))
						connected_devices.Remove(C)
						continue

					dat += "<tr>"
					dat += "<td>[C.id_tag]</td>"
					dat += "<td><a href='?src=\ref[src];manage_individual=\ref[C]'>\[Manage\]</a></td>"
					dat += "</tr>"
					dat += "</table>"
			else
				dat += "No devices connected.<br>"

		dat += "<hr>"
		dat += "<a href='?src=\ref[src];refresh=1'>Refresh</a> "
		dat += "<a href='?src=\ref[src];close=1'>Close</a>"

	user << browse(dat, "window=core_control;size=500x600")
	onclose(user, "core_control")
	user.set_machine(src)

/obj/machinery/computer/rust_core_control/Topic(href, href_list)
	..()

	if( href_list["goto_scanlist"] )
		cur_viewed_device = null

	if( href_list["manage_individual"] )
		cur_viewed_device = locate(href_list["manage_individual"])

	if( href_list["scan"] )
		connected_devices = list()
		for(var/obj/machinery/power/rust_core/C in range(scan_range, src))
			if(check_core_status(C))
				connected_devices.Add(C)

	if( href_list["startup"] )
		if(cur_viewed_device)
			cur_viewed_device.Startup()

	if( href_list["shutdown"] )
		if(cur_viewed_device)
			cur_viewed_device.Shutdown()

	if( href_list["close"] )
		usr << browse(null, "window=core_control")
		usr.unset_machine()

	updateDialog()

/obj/machinery/computer/rust_core_control/proc/check_core_status(var/obj/machinery/power/rust_core/C)
	if(!C)
		return 0

	if(C.stat & (BROKEN|NOPOWER) || !C.remote_access_enabled || !C.id_tag)
		if(connected_devices.Find(C))
			connected_devices.Remove(C)
		return 0

	return 1
