
/obj/machinery/computer/emitter_controller
	name = "Emitter Remote Controller"
	icon = 'icons/rust.dmi'
	icon_state = "engine"
	var/updating = 1

/obj/machinery/computer/emitter_controller/New()
	..()

/obj/machinery/computer/emitter_controller/process()
	..()
	if(updating)
		src.updateDialog()

/obj/machinery/computer/attack_hand(mob/user)
	add_fingerprint(user)

	if(stat & (BROKEN|NOPOWER))
		return
	interact(user)

/obj/machinery/computer/emitter_controller/Topic(href, href_list)
	..()
	if( href_list["close"] )
		usr << browse(null, "window=emitter_controller")
		usr.machine = null
		return

	if( href_list["toggle_all"] )
		for(var/obj/machinery/power/emitter/emitter in world)
			if(emitter.anchored && emitter.state == 2)
				emitter.Topic(href, href_list)
		return

/obj/machinery/computer/emitter_controller/interact(mob/user)
	if ( (get_dist(src, user) > 1 ) || (stat & (BROKEN|NOPOWER)) )
		if (!istype(user, /mob/living/silicon))
			user.machine = null
			user << browse(null, "window=emitter_controller")
			return
	var/t = "<B>Emitter Remote Control Console</B><BR>"
	t += "<hr>"
	for(var/obj/machinery/power/emitter/emitter in world)
		if(emitter.anchored && emitter.state == 2)
			t += "<b>Emitter</b> [emitter.id] "
			t += "<font color=green>operational</font><br>"
			t += "Operational mode: <font color=blue>"
			if(emitter.active)
				t += "Emitting</font> "
			else
				t += "Not emitting</font> "
			t += "<a href='?src=\ref[emitter];user=\ref[user];toggle_activate=1'>\[Toggle\]</a> "
			t += "<a href='?src=\ref[src];user=\ref[user];toggle_activate=1;toggle_all=[emitter.id]'>\[All\]</a>"
			t += "<br>"
			t += "Burst delay: [(emitter.min_burst_delay + emitter.max_burst_delay) / 2] <a href='?src=\ref[emitter];user=\ref[user];modifyburst=1'>\[Modify\]</a><br>"
			t += "Burst shots: [emitter.burst_shots] <a href='?src=\ref[emitter];user=\ref[user];modifyshots=1'>\[Modify\]</a><br>"
			t += "<hr>"
	t += "<A href='?src=\ref[src];close=1'>Close</A><BR>"
	user << browse(t, "window=emitter_controller;size=500x400")
	user.machine = src
