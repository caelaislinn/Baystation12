
/obj/machinery/computer/marketcomp
	name = "Market Trades console"
	icon = 'icons/obj/computer.dmi'
	icon_state = "supply"
	req_access = list(access_cargo)
	circuit = "/obj/item/weapon/circuitboard/marketcomp"
	//var/temp = null
	//var/reqtime = 0
	//var/hacked = 0
	var/can_order_contraband = 0
	var/last_viewed_group = "categories"
	var/temp = null
	var/datum/trade_destination/cur_dest
	var/cur_category
	var/charge_to_department = "Cargo"
	var/machine_id

/obj/machinery/computer/marketcomp/New()
	..()
	if(!machine_id)
		machine_id = "[station_name()] TradeNet Console #[economy_controller.num_financial_terminals++]"

/obj/machinery/computer/marketcomp/attack_hand(var/mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/computer/marketcomp/interact(var/mob/user)
	if(stat & (BROKEN|NOPOWER))
		user.unset_machine()
		user << browse(null, "window=market_comp")
		return
	if (!istype(user, /mob/living/silicon) && (get_dist(src, user) > 1 ))
		user.unset_machine()
		user << browse(null, "window=market_comp")
		return

	var/dat = "<h1>Tau Ceti TradeNet Console</h1>"
	if(!cur_dest)
		//first, choose a destination
		dat += "Currently charging all purchases to: [charge_to_department]<br>"
		dat += "Select a registered trading partner to begin.<hr>"
		for(var/datum/trade_destination/D in economy_controller.trade_destinations)
			dat += "<a href='?src=\ref[src];tradetarget=\ref[D]'>[D.name]</a> <b>[D.distance] AU</b><br>"
			dat += "[D.description]<br>"
			var/temp = ""
			if(D.orderables_withpickup.len)
				temp += "\[goods awaiting pickup\] "
			if(D.orderables_readyforpurchase.len)
				temp += "\[orders awaiting finalising\]"
			if(temp)
				temp += "<br>"
			dat += temp
			dat += "<br>"
	else
		//have these options always available for the viewed trade destination
		dat += "<b>[cur_dest.name]</b> [cur_category]<br>"
		var/total_cost = cur_dest.RequestOrderCost()
		dat += "Total order cost: $[total_cost]<br>"
		dat += "<a href='?src=\ref[src];reset_values=1'>Reset all values</a>"
		if(total_cost)
			dat += " <a href='?src=\ref[src];complete_order=1'>Complete purchase order</a>"
		dat += "<br>"
		if(cur_dest.orderables_withpickup.len)
			dat += "Goods are awaiting pickup."
		else
			dat += "No goods are awaiting pickup."
		dat += "<br>"

		if(!cur_category)
			//next, choose a goods category
			dat += "<b>Select a goods category:</b><br>"
			for(var/text_cat in cur_dest.orderables)
				var/list/L = cur_dest.orderables[text_cat]
				if(L)
					dat += "<a href='?src=\ref[src];viewcat=[text_cat]'>[text_cat]</a><br>"
			dat += "<br>"
		else
			//now handle goods in that category
			dat += "<b>Available goods</b><br>"
			var/list/L = cur_dest.orderables[cur_category]

			dat += "<table width='100%'  border=1>"
			dat += "<tr>"
			dat += "<td><b>Item</b></td>"
			dat += "<td><b>Price</b></td>"
			dat += "<td><b>Stored</b></td>"
			dat += "<td><b>Order Quantity</b></td>"
			dat += "<td><b>Pickup</b></td>"
			dat += "</tr>"
			for(var/datum/dest_orderable/O in L)
				dat += "<tr>"
				dat += "<td>[O.index_name]</td>"
				dat += "<td>$[cur_dest.RequestUpdatedPrice(O)]/unit</td>"
				dat += "<td>[O.local_stored] units</td>"
				dat += "<td>"
				dat += "<a href='?src=\ref[src];quantity_mod=-100;orderable=\ref[O]'>---</a> "
				dat += "<a href='?src=\ref[src];quantity_mod=-10;orderable=\ref[O]'>--</a> "
				dat += "<a href='?src=\ref[src];quantity_mod=-1;orderable=\ref[O]'>-</a> "
				dat += "[O.quantity_ordered] units "
				dat += "<a href='?src=\ref[src];quantity_mod=1;orderable=\ref[O]'>+</a> "
				dat += "<a href='?src=\ref[src];quantity_mod=10;orderable=\ref[O]'>++</a> "
				dat += "<a href='?src=\ref[src];quantity_mod=100;orderable=\ref[O]'>+++</a>"
				dat += "</td>"
				dat += "<td>[O.quantity_waiting_pickup > 0 ? "[O.quantity_waiting_pickup] units" : ""]</td>"
				dat += "</tr>"
			dat += "</table>"
			dat += "<br>"
			dat += "<a href='?src=\ref[src];clearcat=1'>Back to categories</a> "
		dat += "<a href='?src=\ref[src];tradetarget=0'>Back to Main Menu</a><br>"

	dat += "<hr>"
	dat += "<a href='?src=\ref[src]'>Refresh</a> <a href='?src=\ref[src];close=1'>Close</a>"

	user << browse(dat, "window=market_comp;size=500x450")
	onclose(user, "market_comp")
	user.set_machine(src)

/obj/machinery/computer/marketcomp/Topic(var/href, var/href_list)
	usr.set_machine(src)

	if(href_list["tradetarget"])
		cur_dest = locate(href_list["tradetarget"])
		cur_category = null

	else if(href_list["cleartarget"])
		cur_dest = null
		cur_category = null

	else if(href_list["reset_values"])
		//manually triggered by players
		//fixes if the caching system breaks, also resets non-finalised orders
		if(cur_category)
			var/list/L = cur_dest.orderables[cur_category]
			if(L && L.len)
				for(var/datum/dest_orderable/O in L)
					O.quantity_ordered = 0
		else
			for(var/datum/dest_orderable/O in cur_dest.orderables_by_type)
				O.quantity_ordered = 0

		if(cur_dest)
			cur_dest.FullPriceCostUpdate()

	else if(href_list["viewcat"])
		cur_category = href_list["viewcat"]

	else if(href_list["clearcat"])
		cur_category = null

	else if(href_list["complete_order"])
		if(cur_dest)
			//check if there is enough money in the account
			//RequestOrderCost() will update all relevant cached values
			var/total_cost = cur_dest.RequestOrderCost()
			var/datum/money_account/M = economy_controller.department_accounts[charge_to_department]
			if(M.money >= total_cost)
				M.money -= total_cost
				var/receipt_num = economy_controller.GetNextReceiptNum()

				//we can safely access cached values here, because they were updated just above
				var/obj/item/weapon/paper/R = new(src.loc)
				R.name = "TradeNet purchase receipt #[receipt_num]"
				R.info = "<b>TradeNet purchase receipt #[receipt_num]</b><br>"
				R.info += "Total Purchase cost: $[total_cost]<br>"
				for(var/datum/dest_orderable/O in cur_dest.orderables_readyforpurchase)
					R.info += "<i>Item:</i> [O.index_name] x [O.quantity_ordered] @ $[O.last_calculated_price]ea, total: $[O.archived_total_cost]<br>"
				R.info += "<br>"
				R.info += "<i>Charged to</i>: [M.owner_name]<br>"
				R.info += "<i>Final balance:</i> $[M.money]<br>"
				R.info += "<i>Date and time:</i> [worldtime2text()], [current_date_string]<br><br>"
				R.info += "<i>Creation terminal ID:</i> [machine_id]<br>"
				//R.info += "<i>Authorised NT officer overseeing creation:</i> None<br>"

				var/datum/transaction/T = new()
				T.target_name = "[cur_dest.name] Commerce Control"
				T.purpose = "TradeNet purchase #[receipt_num]"
				T.amount = "([total_cost])"
				T.date = current_date_string
				T.time = worldtime2text()
				T.source_terminal = machine_id
				M.transaction_log.Add(T)

				cur_dest.CompleteOrder()
			else
				usr << "\red Unable to process transaction, not enough funds in account to proceed."

	else if(href_list["quantity_mod"])
		var/datum/dest_orderable/O = locate(href_list["orderable"])
		var/num = text2num(href_list["quantity_mod"])
		if(O && cur_dest)
			cur_dest.ModifyOrderQuantity(O, num)

	else if( href_list["close"] )
		usr << browse(null, "window=market_comp")
		usr.unset_machine()

	updateDialog()

/*
		var/datum/dest_orderable/O = new orderable_type()
		if(!orderables.Find(O.category))
			orderables[O.category] = list()
		var/list/L = orderables[O.category]
		L.Add(O)

	var/quantity_ordered = 0
	var/order_locked = 0
		*/
