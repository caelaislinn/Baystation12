
//the !!fun!! part
/obj/effect/rust_em_field/proc/React()
	//loop through the reactants in random order
	var/list/reactants_reacting_pool = dormant_reactant_quantities.Copy()
	/*
	for(var/reagent in dormant_reactant_quantities)
		world << "	before: [reagent]: [dormant_reactant_quantities[reagent]]"
		*/

	//cant have any reactions if there aren't any reactants present
	if(reactants_reacting_pool.len)
		reacted_this_cycle = 0
		for(var/reactant in reactants_reacting_pool)
			if(reactants_reacting_pool[reactant] <= 0)
				continue
			//use a % of all reactants this cycle, removing them from the available pool
			reactants_reacting_pool[reactant] = round( min(catalyst_rate * reactants_reacting_pool[reactant], reactants_reacting_pool[reactant]) )

			//not enough fuel, so have a reduced chance to react instead
			if(reactants_reacting_pool[reactant] < 1)
				if(dormant_reactant_quantities[reactant] > 0)
					reactants_reacting_pool[reactant] = 1
				else
					reactants_reacting_pool[reactant] = 0
			dormant_reactant_quantities[reactant] -= reactants_reacting_pool[reactant]
			if(reactants_reacting_pool[reactant] == 0)
				reactants_reacting_pool -= reactant
			//world << "[reactants_reacting_pool[reactant]] [reactant] available to react"

		//loop through all the reacting reagents, picking out random reactions for them
		var/list/produced_reactants = new/list
		var/list/primary_reactant_pool = reactants_reacting_pool.Copy()
		var/num_reaction_iterations = 0
		var/avg_secondary_checks = 0
		while(primary_reactant_pool.len)
			num_reaction_iterations += 1
			//pick one of the unprocessed reacting reagents randomly
			var/cur_primary_reactant = pick(primary_reactant_pool)
			primary_reactant_pool.Remove(cur_primary_reactant)

			//grab all the possible reactants to have a reaction with
			var/list/possible_secondary_reactants = reactants_reacting_pool.Copy()
			//if there is only one of a particular reactant, then it can not react with itself so remove it
			possible_secondary_reactants[cur_primary_reactant] -= 1
			if(possible_secondary_reactants[cur_primary_reactant] < 1)
				possible_secondary_reactants.Remove(cur_primary_reactant)

			//loop through and work out all the possible reactions
			var/list/possible_reactions = new/list
			for(var/cur_secondary_reactant in possible_secondary_reactants)
				if(possible_secondary_reactants[cur_secondary_reactant] < 1)
					continue
				var/datum/fusion_reaction/cur_reaction = get_fusion_reaction(cur_primary_reactant, cur_secondary_reactant)
				if(cur_reaction)
					possible_reactions.Add(cur_reaction)

			//if there are no possible reactions here, abandon this primary reactant and move on
			if(!possible_reactions.len)
				continue

			//split up the reacting atoms between the possible reactions
			while(possible_reactions.len)
				avg_secondary_checks += 1

				//pick a random substance to react with
				var/datum/fusion_reaction/cur_reaction = pick(possible_reactions)
				possible_reactions.Remove(cur_reaction)
				//world << "	checking [cur_reaction.primary_reactant]/[cur_reaction.secondary_reactant] reaction..."

				//set the randmax to be the lower of the two involved reactants
				var/max_num_reactants = 0
				if(reactants_reacting_pool[cur_reaction.primary_reactant] > reactants_reacting_pool[cur_reaction.secondary_reactant])
					max_num_reactants = reactants_reacting_pool[cur_reaction.secondary_reactant]
				else
					max_num_reactants = reactants_reacting_pool[cur_reaction.primary_reactant]

				if(max_num_reactants < 1)
					continue

				//make sure we have enough energy
				if(total_energy < max_num_reactants * cur_reaction.energy_consumption)
					max_num_reactants = round(total_energy / cur_reaction.energy_consumption)
					if(max_num_reactants < 1)
						//world << "not enough energy for [cur_reaction.primary_reactant]/[cur_reaction.secondary_reactant]"
						continue

				//randomly determined amount to ne consumed for this reaction type
				var/amount_reacting = rand(1, max_num_reactants)
				if(possible_reactions.len == 1)
					amount_reacting = max_num_reactants
					//world << "finishing last of [cur_reaction.primary_reactant]/[cur_reaction.secondary_reactant]"

				//removing the reacting substances from the list of substances that are primed to react this cycle
				//if there aren't enough of that substance (there should be) then modify the reactant amounts accordingly
				if( reactants_reacting_pool[cur_reaction.primary_reactant] - amount_reacting >= 0 )
					reactants_reacting_pool[cur_reaction.primary_reactant] -= amount_reacting
				else
					amount_reacting = reactants_reacting_pool[cur_reaction.primary_reactant]
					reactants_reacting_pool[cur_reaction.primary_reactant] = 0
				//same again for secondary reactant
				if( reactants_reacting_pool[cur_reaction.secondary_reactant] - amount_reacting >= 0 )
					reactants_reacting_pool[cur_reaction.secondary_reactant] -= amount_reacting
				else
					reactants_reacting_pool[cur_reaction.primary_reactant] += amount_reacting - reactants_reacting_pool[cur_reaction.primary_reactant]
					amount_reacting = reactants_reacting_pool[cur_reaction.secondary_reactant]
					reactants_reacting_pool[cur_reaction.secondary_reactant] = 0

				//remove the consumed energy
				total_energy -= max_num_reactants * cur_reaction.energy_consumption

				//add any produced radiation
				radiator.light_radiation += max_num_reactants * cur_reaction.radiation
				//world << "[max_num_reactants * cur_reaction.radiation] radiation produced"

				//add the produced energy
				AddEnergy(cur_reaction.energy_production * amount_reacting * RUST_REACTION_PRODUCTION_RATE)

				//for control panel viewers
				reacted_this_cycle += amount_reacting

				//create the reaction products
				for(var/reactant in cur_reaction.products)
					var/success = 0
					for(var/check_reactant in produced_reactants)
						if(check_reactant == reactant)
							produced_reactants[reactant] += cur_reaction.products[reactant] * amount_reacting
							success = 1
							break
					if(!success)
						produced_reactants[reactant] = cur_reaction.products[reactant] * amount_reacting

				//this reaction is done, and can't be repeated this sub-cycle
				possible_reactions.Remove(cur_reaction.secondary_reactant)

			avg_secondary_checks /= num_reaction_iterations
			//world << "[num_reaction_iterations] reactant iterations, with avg [avg_secondary_checks] checks for secondary reactions"

		//loop through the newly produced reactants and add them to the pool
		for(var/reactant in produced_reactants)
			AddParticles(reactant, produced_reactants[reactant])
			//world << "[produced_reactants[reactant]] [reactant] produced"

		//check whether there are reactants left, and add them back to the pool
		for(var/reactant in reactants_reacting_pool)
			AddParticles(reactant, reactants_reacting_pool[reactant])
			//world << "[reactants_reacting_pool[reactant]] [reactant] did not successfully react"
			reacted_this_cycle -= reactants_reacting_pool[reactant]

		if(reacted_this_cycle < 0)
			reacted_this_cycle = 0
