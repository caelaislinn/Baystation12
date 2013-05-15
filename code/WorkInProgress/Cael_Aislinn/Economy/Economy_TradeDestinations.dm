
//the whole costs and pricing mechanism employs delayed calculation in order to minimise processing
//this makes the system somewhat more complex, but hopefully the tradeoff is worth it

/datum/trade_destination
	var/name = ""
	var/description = ""
	var/distance = 0
	var/total_order_cost = 0
	var/supply_pickup = 0

	var/list/orderables = list()
	var/list/orderables_by_type = list()

	var/list/orderable_types_supply = list()
	var/list/orderable_categories_supply = list()

	var/list/orderables_needing_price_updates = list()

	var/list/orderables_readyforpurchase = list()
	var/list/orderables_withpickup = list()

	var/list/viable_random_events = list()
	var/list/viable_mundane_events = list()

/datum/trade_destination/New()
	//initialise trade orders
	set background = 1

	orderables.len = MAX_ORDERABLE
	for(var/orderable_type in typesof(/datum/dest_orderable) - /datum/dest_orderable)
		var/datum/dest_orderable/O = new orderable_type()
		//require a spawn type to order this
		if(O.spawn_type)
			var/cat_text = economy_controller.goods_strings(O.category)

			//prioritise unique types over categories
			var/willing_to_trade = 0
			var/supply_dir = 0
			if( orderable_types_supply.Find(O.spawn_type) )
				supply_dir = orderable_types_supply[O.spawn_type]
				willing_to_trade = 1

			else if( orderable_categories_supply.Find(cat_text) )
				supply_dir = orderable_categories_supply[O.spawn_type]
				willing_to_trade = 1

			if(supply_dir > 0)
				//produce this resource, driving down prices
				O.industry_price_mod = economy_controller.global_industrysupply_pricemod / abs(supply_dir)
				O.local_stored_prod = abs(O.local_stored_prod) + 5

			else if(supply_dir < 0)
				//consume this resource, driving up prices
				O.industry_price_mod = economy_controller.global_industrydemand_pricemod * supply_dir
				O.local_stored_prod = -(abs(O.local_stored_prod) + 5)

			//if this dest wants to trade that item, then proceed with the rest of the initialisation
			if(willing_to_trade)
				if(!orderables.Find(cat_text))
					orderables[cat_text] = list()
				var/list/L = orderables[cat_text]
				L.Add(O)
				orderables_by_type[O.spawn_type] = O	//todo: why isn't this working?
			else
				del(O)

		else
			del(O)

/datum/trade_destination/proc/get_custom_eventstring(var/event_type)
	return null

/datum/trade_destination/proc/ModifyOrderQuantity(var/datum/dest_orderable/O, var/quantity_diff)
	O.quantity_ordered = min(max(O.quantity_ordered + quantity_diff, 0), O.local_stored)

	//if the price doesn't need recalculating, we can use it to work out the cost of this goods order
	//otherwise, just leave the cost update until when the price gets updated as well
	if(!orderables_needing_price_updates.Find(O))
		total_order_cost -= O.archived_total_cost
		O.archived_total_cost = O.last_calculated_price * O.quantity_ordered
		total_order_cost += O.archived_total_cost

	if(O.quantity_ordered > 0)
		if(!orderables_readyforpurchase.Find(O))
			orderables_readyforpurchase.Add(O)
	else if(orderables_readyforpurchase.Find(O))
		orderables_readyforpurchase.Remove(O)

/datum/trade_destination/proc/RequestUpdatedPrice(var/datum/dest_orderable/O)
	if(orderables_needing_price_updates.Find(O))
		return ForcePriceUpdate(O)

	return O.last_calculated_price

/datum/trade_destination/proc/ForcePriceUpdate(var/datum/dest_orderable/O)
	//we need to update the destination order cost here
	//this is to to prevent desyncs between
	//	destination order cost
	//	individual goods total cost
	//	individual goods price

	total_order_cost -= O.archived_total_cost

	O.last_calculated_price = round(O.base_price * O.industry_price_mod * O.event_price_mod * O.supply_price_mod, 0.01)
	O.archived_total_cost = O.last_calculated_price * O.quantity_ordered

	total_order_cost += O.archived_total_cost

	while(orderables_needing_price_updates.Remove(O))

	return O.last_calculated_price

/datum/trade_destination/proc/CompleteOrder()
	for(var/datum/dest_orderable/O in orderables_readyforpurchase)
		if(orderables_needing_price_updates.Find(O))
			ForcePriceUpdate(O)

		orderables_readyforpurchase.Remove(O)
		if(!orderables_withpickup.Find(O))
			orderables_withpickup.Add(O)
		orderables_needing_price_updates.Add(O)

		O.ProcessOrder()

/datum/trade_destination/proc/DelayedUpdate()
	for(var/index in orderables)
		var/list/L = orderables[index]
		if(L && L.len)
			for(var/datum/dest_orderable/O in L)
				//DelayedUpdate() returns true if it needs a price update
				if(O.DelayedUpdate() && !orderables_needing_price_updates.Find(O))
					orderables_needing_price_updates.Add(O)

/datum/trade_destination/proc/RequestOrderCost()
	//this is to cutdown on unnecessary recalcs
	for(var/datum/dest_orderable/O in orderables_needing_price_updates)
		ForcePriceUpdate(O)

	//sanity checking, this seems necessary
	if(total_order_cost < 0)
		FullPriceCostUpdate()

	return total_order_cost

//fully recalculate all prices and costs
//this is here in case the caching system breaks, and has to be manually triggered by players
/datum/trade_destination/proc/FullPriceCostUpdate()
	total_order_cost = 0
	orderables_readyforpurchase = list()
	orderables_withpickup = list()
	for(var/cur_type in orderables_by_type)
		for(var/datum/dest_orderable/O in orderables_by_type[cur_type])
			O.supply_price_mod = 0.25 + 0.75 * (1.01 - (O.local_stored + O.local_stored * 0.01) / O.local_stored_max)
			O.last_calculated_price = round(O.base_price * O.industry_price_mod * O.event_price_mod * O.supply_price_mod, 0.01)

			if(O.quantity_ordered > 0)
				O.archived_total_cost = O.last_calculated_price * O.quantity_ordered
				total_order_cost += O.archived_total_cost
				orderables_readyforpurchase.Add(O)

			if(O.quantity_waiting_pickup > 0)
				orderables_withpickup.Add(O)

	orderables_needing_price_updates = list()
