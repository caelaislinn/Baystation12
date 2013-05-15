
//base industry supply price modifier: 0.5
//base industry demand price modifier: 2

//industry supply and demand also have 'tiers' which multiply the supply/demand modifiers
//ex, basic demand = tier 1 = 2 * 1 price modifier
//moderate demand = tier 2 = 2 * 2 price modifier

//stored quantity price modifier: 0.25 to 0.75, as quantity stored ranges from 0% to 100%
//global base price: 100

datum/controller/global_market
	var/list/template_orderables = list()

/datum/dest_orderable
	var/index_name = "unknown/default"
	var/container_type = /obj/structure/closet/crate
	//values initialized to -1 are set to the default in New()

	var/category = DEFAULT
	var/stackable = 0
	var/max_stack = 10
	var/spawn_type
	var/local_stored_prod = 1	//regular consumption or production
								//if this value starts at >0, set it to a random negative value
								//to have these goods be produced regularly, set it as a supply industry the owning trade_destination

	//don't change any vars below this one manually, because they have delayed calculation based on cached values

	var/local_stored = -1
	var/local_stored_max = -1
	var/last_calculated_price = 100
	var/archived_total_cost = 0		//cached value of last_calculated_price * quantity_ordered

	var/base_price = 100
	var/industry_price_mod = 1
	var/event_price_mod = 1
	var/supply_price_mod = 1
	var/quantity_ordered = 0

	var/quantity_waiting_pickup = 0
	var/sold_quantity = 0

/datum/dest_orderable/New()
	if(local_stored_max < 0)
		local_stored_max = 100
		if(stackable)
			local_stored_max *= 2

	if(local_stored_prod > 0)
		local_stored_prod = rand(-1,-5)

	if(local_stored < 0)
		SetStoredLocally(round(rand() * local_stored_max))
	else
		//update the supply price modifier
		var/new_amount = local_stored
		local_stored = 0
		SetStoredLocally(new_amount)

//instead of a normal process() call every tick, this one is subject to a delay set in the controller datum
//return 1 if we need a price update by the end of the proc
/datum/dest_orderable/proc/DelayedUpdate()
	set background = 1

	/*var/temp = cached_extra_supply
	cached_extra_supply = 0
	return SetStoredLocally(local_stored + local_stored_prod + temp)*/

//return 1 if we changed the amount stored
/datum/dest_orderable/proc/SetStoredLocally(var/amount)
	if(amount != local_stored)
		local_stored = min(max(amount, 0), local_stored_max)
		supply_price_mod = 0.25 + 0.75 * (1.01 - (local_stored + local_stored * 0.01) / local_stored_max)
		return 1

/datum/dest_orderable/proc/ProcessOrder()
	quantity_waiting_pickup = quantity_ordered
	SetStoredLocally(local_stored - quantity_ordered)
	quantity_ordered = 0


//---------- FOOD

/datum/dest_orderable/chips
	index_name = "chips"
	container_type = /obj/structure/closet/crate/freezer
	base_price = 4
	category = FOOD
	stackable = 1
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/chips

/datum/dest_orderable/candy
	index_name = "candy"
	container_type = /obj/structure/closet/crate/freezer
	base_price = 6
	category = FOOD
	stackable = 1
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/candy

/datum/dest_orderable/soymilk
	index_name = "soymilk"
	container_type = /obj/structure/closet/crate/freezer
	base_price = 7
	category = FOOD
	stackable = 1
	spawn_type = /obj/item/weapon/reagent_containers/food/drinks/soymilk

/datum/dest_orderable/coffee
	index_name = "coffee"
	container_type = /obj/structure/closet/crate/freezer
	base_price = 3
	category = FOOD
	stackable = 1
	spawn_type = /obj/item/weapon/reagent_containers/food/drinks/coffee


//---------- ADMINISTRATIVE

/datum/dest_orderable/pen
	index_name = "pen"
	base_price = 1
	category = ADMINISTRATIVE
	stackable = 1
	spawn_type = /obj/item/weapon/pen

/datum/dest_orderable/clipboard
	index_name = "clipboard"
	base_price = 5
	category = ADMINISTRATIVE
	stackable = 1
	spawn_type = /obj/item/weapon/clipboard


//---------- GAS

/datum/dest_orderable/gasplasma
	index_name = "plasma gas canister"
	category = GAS
	spawn_type = /obj/machinery/portable_atmospherics/canister/toxins
	container_type = null
	base_price = 1500

/datum/dest_orderable/gasoxy
	index_name = "oxygen gas canister"
	category = GAS
	spawn_type = /obj/machinery/portable_atmospherics/canister/oxygen
	container_type = null
	base_price = 250

/datum/dest_orderable/gasnitro
	index_name = "nitrogen gas canister"
	category = GAS
	spawn_type = /obj/machinery/portable_atmospherics/canister/nitrogen
	container_type = null
	base_price = 250

/datum/dest_orderable/gasco2
	index_name = "carbon dioxide gas canister"
	category = GAS
	spawn_type = /obj/machinery/portable_atmospherics/canister/carbon_dioxide
	container_type = null
	base_price = 250

/datum/dest_orderable/gassleeping
	index_name = "sleeping gas canister"
	category = GAS
	spawn_type = /obj/machinery/portable_atmospherics/canister/sleeping_agent
	container_type = null
	base_price = 300


//---------- MINERALS

/datum/dest_orderable/oreiron
	index_name = "iron ore"
	category = MINERALS
	spawn_type = /obj/item/weapon/ore/iron
	container_type = /obj/structure/ore_box
	base_price = 50

/datum/dest_orderable/oreuranium
	index_name = "uranium ore"
	category = MINERALS
	spawn_type = /obj/item/weapon/ore/uranium
	container_type = /obj/structure/ore_box
	base_price = 50

/datum/dest_orderable/oreplasma
	index_name = "plasma ore"
	category = MINERALS
	spawn_type = /obj/item/weapon/ore/plasma
	container_type = /obj/structure/ore_box
	base_price = 500
