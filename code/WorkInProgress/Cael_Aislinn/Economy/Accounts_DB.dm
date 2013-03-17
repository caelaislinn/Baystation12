
/obj/machinery/account_database
	name = "Accounts database"
	desc = "Holds transaction logs, account data and all kinds of other financial records."
	icon = 'virology.dmi'
	icon_state = "analyser"
	density = 1
	//var/list/accounts = list()
	req_one_access = list(access_hop, access_captain)
	var/receipt_num
	var/machine_id = ""
	var/obj/item/weapon/card/id/held_card
	var/access_level = 0
	var/datum/money_account/detailed_account_view
	var/creating_new_account = 0
	var/activated = 1

/obj/machinery/account_database/New()
	..()

	machine_id = "[station_name()] Acc. DB #[economy_controller.num_financial_terminals++]"

/obj/machinery/account_database/attack_hand(mob/user as mob)
	if(get_dist(src,user) <= 1)
		var/dat = "<b>Accounts Database</b><br>"
		dat += "<i>[machine_id]</i><br>"
		dat += "Confirm identity: <a href='?src=\ref[src];choice=insert_card'>[held_card ? held_card : "-----"]</a><br>"

		if(access_level > 0)
			dat += "<a href='?src=\ref[src];toggle_activated=1'>[activated ? "Disable" : "Enable"] remote access</a><br>"
			dat += "You may not edit accounts at this terminal, only create and view them.<br>"
			if(creating_new_account)
				dat += "<br>"
				dat += "<a href='?src=\ref[src];choice=view_accounts_list;'>Return to accounts list</a>"
				dat += "<form name='create_account' action='?src=\ref[src]' method='get'>"
				dat += "<input type='hidden' name='src' value='\ref[src]'>"
				dat += "<input type='hidden' name='choice' value='finalise_create_account'>"
				dat += "<b>Holder name:</b> <input type='text' id='holder_name' name='holder_name' style='width:250px; background-color:white;'><br>"
				dat += "<b>Initial funds:</b> <input type='text' id='starting_funds' name='starting_funds' style='width:250px; background-color:white;'> (subtracted from station account)<br>"
				dat += "<i>New accounts are automatically assigned a secret number and pin, which are printed separately in a sealed package.</i><br>"
				dat += "<input type='submit' value='Create'><br>"
				dat += "</form>"
			else
				if(detailed_account_view)
					dat += "<br>"
					dat += "<a href='?src=\ref[src];choice=view_accounts_list;'>Return to accounts list</a><hr>"
					dat += "<b>Account number:</b> #[detailed_account_view.account_number]<br>"
					dat += "<b>Account holder:</b> [detailed_account_view.owner_name]<br>"
					dat += "<b>Account balance:</b> $[detailed_account_view.money]<br>"
					dat += "<table border=1 style='width:100%'>"
					dat += "<tr>"
					dat += "<td><b>Date</b></td>"
					dat += "<td><b>Time</b></td>"
					dat += "<td><b>Target</b></td>"
					dat += "<td><b>Purpose</b></td>"
					dat += "<td><b>Value</b></td>"
					dat += "<td><b>Source terminal ID</b></td>"
					dat += "</tr>"
					for(var/datum/transaction/T in detailed_account_view.transaction_log)
						dat += "<tr>"
						dat += "<td>[T.date]</td>"
						dat += "<td>[T.time]</td>"
						dat += "<td>[T.target_name]</td>"
						dat += "<td>[T.purpose]</td>"
						dat += "<td>$[T.amount]</td>"
						dat += "<td>[T.source_terminal]</td>"
						dat += "</tr>"
					dat += "</table>"
				else
					dat += "<a href='?src=\ref[src];choice=create_account;'>Create new account</a><br>"
					dat += "<br>"
					dat += "<table border=1 style='width:100%'>"
					for(var/i=1, i<=economy_controller.accounts.len, i++)
						var/datum/money_account/D = economy_controller.accounts[i]
						dat += "<tr>"
						dat += "<td>#[D.account_number]</td>"
						dat += "<td>[D.owner_name]</td>"
						dat += "<td><a href='?src=\ref[src];choice=view_account_detail;account_index=[i]'>View in detail</a></td>"
						dat += "</tr>"
					dat += "</table>"

		user << browse(dat,"window=account_db;size=700x650")
	else
		user << browse(null,"window=account_db")

/obj/machinery/account_database/attackby(O as obj, user as mob)//TODO:SANITY
	if(istype(O, /obj/item/weapon/card))
		var/obj/item/weapon/card/id/idcard = O
		if(!held_card)
			usr.drop_item()
			idcard.loc = src
			held_card = idcard

			if(access_cent_captain in idcard.access)
				access_level = 2
			else if(access_hop in idcard.access || access_captain in idcard.access)
				access_level = 1
	else
		..()

/obj/machinery/account_database/Topic(var/href, var/href_list)

	if(href_list["toggle_activated"])
		activated = !activated

	if(href_list["choice"])
		switch(href_list["choice"])
			if("create_account")
				creating_new_account = 1
			if("finalise_create_account")
				var/account_name = href_list["holder_name"]
				var/starting_funds = max(text2num(href_list["starting_funds"]), 0)
				var/datum/money_account/M = economy_controller.add_account(account_name, starting_funds, machine_id)

				//create a sealed package containing the account details
				var/obj/item/smallDelivery/P = new(src.loc)

				var/obj/item/weapon/paper/R = new(P)
				P.wrapped = R
				R.name = "Account information: [M.owner_name]"
				R.info = "<b>Account details (confidential)</b><br><hr><br>"
				R.info += "<i>Account holder:</i> [M.owner_name]<br>"
				R.info += "<i>Account number:</i> [M.account_number]<br>"
				R.info += "<i>Account pin:</i> [M.remote_access_pin]<br>"
				R.info += "<i>Starting balance:</i> $[M.money]<br>"
				R.info += "<i>Date and time:</i> [worldtime2text()], [current_date_string]<br><br>"
				R.info += "<i>Creation terminal ID:</i> [machine_id]<br>"
				R.info += "<i>Authorised NT officer overseeing creation:</i> [held_card.registered_name]<br>"

				//stamp the paper
				var/image/stampoverlay = image('icons/obj/bureaucracy.dmi')
				stampoverlay.icon_state = "paper_stamp-cent"
				if(!R.stamped)
					R.stamped = new
				R.stamped += /obj/item/weapon/stamp
				R.overlays += stampoverlay
				R.stamps += "<HR><i>This paper has been stamped by the Accounts Database.</i>"

				if(starting_funds > 0)
					//subtract the money
					economy_controller.station_account.money -= starting_funds

					//create a transaction log entry
					var/datum/transaction/T = new()
					T.target_name = account_name
					T.purpose = "New account funds initialisation"
					T.amount = "([starting_funds])"
					T.date = current_date_string
					T.time = worldtime2text()
					T.source_terminal = machine_id
					economy_controller.station_account.transaction_log.Add(T)

				creating_new_account = 0
			if("insert_card")
				if(held_card)
					held_card.loc = src.loc

					if(ishuman(usr) && !usr.get_active_hand())
						usr.put_in_hands(held_card)
					held_card = null
					access_level = 0

				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						var/obj/item/weapon/card/id/C = I
						usr.drop_item()
						C.loc = src
						held_card = C

						if(access_cent_captain in C.access)
							access_level = 2
						else if(access_hop in C.access || access_captain in C.access)
							access_level = 1
			if("view_account_detail")
				var/index = text2num(href_list["account_index"])
				if(index && index <= economy_controller.accounts.len)
					detailed_account_view = economy_controller.accounts[index]
			if("view_accounts_list")
				detailed_account_view = null
				creating_new_account = 0

	src.attack_hand(usr)
