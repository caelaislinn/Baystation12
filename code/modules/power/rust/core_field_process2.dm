

/obj/effect/rust_em_field/proc/process_phoron_capture()
	if(environment)
		//bump up the temperature
		if(held_phoron.total_moles > 0)
			var/newtemp = T20C + RUST_ENERGY_HEAT_MULTIPLIER * total_energy / held_phoron.heat_capacity()
			if(newtemp > held_phoron.temperature)
				held_phoron.temperature = newtemp

		//temporarily remove some gas from the environment
		var/moles_covered = environment.return_pressure() * field_volume / (environment.temperature * R_IDEAL_GAS_EQUATION)
		var/datum/gas_mixture/gas_covered = environment.remove(moles_covered)

		//"leak" some energy from the core field
		//this raises the ambient temperature according to how much gas we didn't or couldn't capture
		//only phoron can be captured, so if there's non-phoron in the atmosphere there will always be some energy leakage
		//to do this, we'll temporarily merge the suspended phoron and the gas we didn't capture
		//this will let the existing atmospheric systems handle the processing

		if(gas_covered)
			gas_covered.merge(held_phoron)
			held_phoron = new/datum/gas_mixture()

			//"capture" some phoron to suspend in the field
			var/num_moles_captured = min(held_phoron_max - held_phoron.total_moles, gas_covered.gas["phoron"])
			gas_covered.adjust_gas("phoron", -num_moles_captured)
			held_phoron.adjust_gas_temp("phoron", num_moles_captured, gas_covered.temperature)

			//restore the environment
			environment.merge(gas_covered)


/obj/effect/rust_em_field/proc/process_fuelwastage()
	var/percent_fuel_wasted = 0
	if(fuel_density > RUST_FUEL_PER_LITRE)
		percent_fuel_wasted = fuel_density / RUST_FUEL_PER_LITRE - 1

	if(percent_fuel_wasted > 0)
		//lose some excess fuel
		var/amount_wasted = 0
		for(var/reactant in dormant_reactant_quantities)
			if(dormant_reactant_quantities[reactant] <= 0)
				dormant_reactant_quantities -= reactant
				continue
			amount_wasted += max( round(percent_fuel_wasted * dormant_reactant_quantities[reactant]), 1 )
			dormant_reactant_quantities[reactant] -= amount_wasted
			if(dormant_reactant_quantities[reactant] <= 0)
				dormant_reactant_quantities -= reactant
		fuel_wasted.Add(amount_wasted)
		radiator.heavy_radiation += amount_wasted
	else
		//no fuel wastage this cycle
		fuel_wasted.Add(0)

	while(fuel_wasted.len > 10)
		fuel_wasted.Cut(1,2)

	average_fuel_wastage = 0
	for(var/i=1, i<= fuel_wasted.len, i++)
		average_fuel_wastage += fuel_wasted[i]

	if(fuel_wasted.len > 0)
		average_fuel_wastage /= fuel_wasted.len

	/*var/average_fuel_wastage = 0
	var/list/fuel_wasted = list()*/


/obj/effect/rust_em_field/proc/process_excess_energy()
	//start phasing energy at 10% of capacity
	if(energy_density > energy_density_threshold * 0.1)

		//work out how much energy we're going to phase
		var/total_energy_to_phase = (energy_density - energy_density_threshold * 0.1) * field_volume

		//energy_loss_rate is the % of excess energy we lose as deadly radiation
		//there is constant energy loss if the field has insufficient phoron density
		var/energy_loss_rate = 1 - held_phoron.total_moles / held_phoron_max
		var/energy_to_radiate = 0

		//if density is greater than 100% then phase and radiate extra energy
		if(energy_density > energy_density_threshold)
			//scale extra rads so that when energy levels are at 1000% of capacity there is a 100% loss rate as radiation
			//this extra loss occurs regardless of field phoron levels
			var/extra_loss = max(1 - total_energy / (energy_density_threshold * field_volume * 10), 1)
			energy_to_radiate += extra_loss * (energy_density - energy_density_threshold) * field_volume

			//phase additional energy depending on how high the field frequency is
			var/extra_phase = (energy_density - energy_density_threshold) * (field_frequency / MAX_RUST_FREQ)

			//if we're radiating too much energy, we won't be able to phase as much
			extra_phase = min(extra_phase, 1 - extra_loss)
			total_energy_to_phase += extra_phase * field_volume

		//phasing works by phoron carrying energy out of the field and into the inducers, which convert the energy and send it into the grid as power
		//the base phoron:energy phase rate is determined by field_strength (higher strength means less phoron is required)
		var/total_phoron_to_phase = total_energy_to_phase * phoron_phase_rate

		//if we have insufficient phoron in the field, we're going to lose even more as radiation
		if(held_phoron.total_moles < total_phoron_to_phase)
			total_phoron_to_phase = held_phoron.total_moles
		if(total_phoron_to_phase < MINIMUM_MOLES_TO_PUMP)
			total_phoron_to_phase = 0

		total_energy_to_phase = total_phoron_to_phase / phoron_phase_rate

		//now that we've finalised how much energy is phasing, we know the minimum that will radiate
		energy_to_radiate += total_energy_to_phase * energy_loss_rate
		total_energy_to_phase -= total_energy_to_phase * energy_loss_rate
		total_energy -= total_energy_to_phase + energy_to_radiate

		//begin phasing energy
		var/energy_to_phase = total_energy_to_phase
		var/phoron_to_phase = total_phoron_to_phase
		if(phoron_to_phase > 0)
			for(var/obj/machinery/portable_atmospherics/rust_phaseinducer/I in owned_core.phase_inducers)
				var/induced_phoron = I.TryInduce(phoron_to_phase, energy_to_phase, held_phoron.temperature)

				phoron_to_phase -= induced_phoron
				energy_to_phase -= induced_phoron / phoron_phase_rate
				held_phoron.adjust_gas("phoron", -induced_phoron)

				//successfully phased everything! let's finish up here
				if(phoron_to_phase <= 0)
					phoron_to_phase = 0
					break

		//if there is any phoron left over, then the inducers are operating at capacity
		phase_tensec.Add(total_energy_to_phase - energy_to_phase)
		if(phase_tensec.len > 10)
			phase_tensec.Cut(1,2)

		//if the inducers are operating at capacity, then some phoron is going to "phase in" to nearby corridors and rooms
		if(phoron_to_phase > 0)
			lost_phasing_phoron += phoron_to_phase

		//lose any leftover energy as radiation
		energy_to_radiate += energy_to_phase
		radiator.light_radiation += energy_to_radiate * RUST_ENERGY_RAD_CONVERSION

		//info for nanoui graphs
		phaseloss_tensec.Add(energy_to_radiate)
		if(phaseloss_tensec.len > 10)
			phaseloss_tensec.Cut(1,2)
		phaselossrate_tensec.Add(energy_loss_rate)
		if(phaselossrate_tensec.len > 10)
			phaselossrate_tensec.Cut(1,2)
		var/energy_leaving_core = 0
		if(energy_density * field_volume > 0)
			energy_leaving_core = (total_energy_to_phase + energy_to_radiate) / (energy_density * field_volume)
		var/inducer_rate = 0
		if(total_energy_to_phase > 0)
			inducer_rate = (total_energy_to_phase - energy_to_phase) / total_energy_to_phase
		//world << "	[total_energy_to_phase - energy_to_phase] / [energy_density * field_volume] MeV phasing with [100 * energy_leaving_core]% energy leaving the core"
		//world << "	[total_energy_to_phase] phoron phasing loaded with [total_phoron_to_phase]MeV and radiatiating [energy_to_radiate]MeV with loss rate of [100 * energy_loss_rate]% and an inducer rate of [100 * inducer_rate]%"

	if(lost_phasing_phoron > 0)
		var/phoron_per_dephase = max( MOLES_PHORON_VISIBLE, 4 * lost_phasing_phoron / (phase_range * phase_range) )
		var/iterations = 0
		var/max_iterations = lost_phasing_phoron / phoron_per_dephase
		var/total_dephased = 0
		while(lost_phasing_phoron > 0 && iterations < max_iterations)
			iterations += 1

			//grab a random tile and drop some phoron there
			var/xpos = rand(src.x - phase_range, src.x + phase_range)
			var/ypos = rand(src.y - phase_range, src.y + phase_range)
			var/turf/dephase_turf = locate(xpos, ypos, src.z)
			var/phoron_dephased = min(phoron_per_dephase, lost_phasing_phoron)

			//only pick floor or space turfs
			//issue with this code somewhere - a divide by zero error
			if (istype(dephase_turf, /turf/simulated/floor) )
				//if it's a floor turf, deposit some phoron there
				//world << "phoron_per_dephase:[phoron_per_dephase] lost_phasing_phoron:[lost_phasing_phoron]"

				dephase_turf.assume_gas("phoron", phoron_dephased)

			else if( !istype(dephase_turf, /turf/space) )
				continue

			phoron_per_dephase -= phoron_dephased
			lost_phasing_phoron -= phoron_dephased
			total_dephased += phoron_dephased

			//flicker some pretty lights on that turf
			var/obj/effect/overlay/phase_overlay = PoolOrNew(/obj/effect/overlay, dephase_turf)
			phase_overlay.icon = 'icons/rust.dmi'
			phase_overlay.icon_state = "onturf-purple"
			phase_overlay.name = "dephasing energy"
			phase_overlay.anchored = 1
			phase_overlay.layer = TURF_LAYER + 1	//no fucks given
			spawn(6)
				qdel(phase_overlay)
		//world << "spent [iterations] iterations dephasing [total_dephased] phoron in [phoron_per_dephase] increments with [lost_phasing_phoron] left over"

