
/obj/effect/rust_em_field/proc/recalculate_phase_difference()
	var/freq_setting = field_frequency / MAX_RUST_FREQ
	var/str_setting = field_strength / MAX_RUST_STR

	var/str_difference = str_setting
	if(str_difference > freq_setting)
		str_difference = freq_setting - (str_difference - freq_setting)

	field_phase_difference = 1 - (str_difference / freq_setting)


/obj/effect/rust_em_field/proc/recalculate_energy_density()
	if(field_volume > 0)
		energy_density = total_energy / field_volume
	else
		energy_density = 0


/obj/effect/rust_em_field/proc/recalculate_volume()
	//let's just pretend the field is in the shape of a box instead of a torus
	//one tile = 2.5m*2.5m*2.5m
	//7 tiles = the maximum field diameter (at max [MAX_FIELD_STR] field strength and min [MIN_FIELD_FREQ] frequency)
	//high frequency = smaller, more concentrated field
	//low frequency = larger, more diffuse field
	//first work out the phoron capacity

	//volume here is the coverage in litres, from 2500.01225 [min] to 122500 [max]
	field_volume = 2500 + (sufficient_core_size * (7 * field_projection / MAX_RUST_PROJ) * (7 * field_projection / MAX_RUST_PROJ) - 1) * 2500

	//have phoron capacity be determined by field pressure

	if(environment)
		var/field_temp = environment.temperature
		if(held_phoron.heat_capacity())
			field_temp = held_phoron.temperature
		held_phoron_max = (HAZARD_HIGH_PRESSURE * 2 * field_volume) / (field_temp * R_IDEAL_GAS_EQUATION)

	//min phoron capacity
	//550 * 4 * 2500.01225 / 293.151 * 8.31
	//= 550 0026.95 / 2436.08
	//= 2257.73

	//max phoron capacity
	//550 * 4 * 122500 / 293.151 * 8.31
	//= 269 500 000 / 2436.08
	//= 110628.55

//--- some working

//#define MOLES_CELLSTANDARD (ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION)) // Moles in a 2.5 m^3 cell at 101.325 kPa and 20 C.
// = (101.325 * 2500) / (293.15 * 8.31)
// = 253312.5 / 2436.0765
//~= 103.98

//max number of cells (tiles) covered is 49, 2500 litres per cell
//:. total volume = 2500 * 49 = 122500
//moles total = HAZARD_HIGH_PRESSURE * 4 * 122500 / T20C * R_IDEAL_GAS_EQUATION
// = 2200 * 122500 / 293.15 * 8.31
// = 269500000 / 2436.0765
//~= 110628.71 or just under 60 portable canisters worth of gas
//heat capacity is 22 125 742J

/*
//large tank
volume = 10000 //in liters, 1 meters by 1 meters by 2 meters ~tweaked it a little to simulate a pressure tank without needing to recode them yet
var/start_pressure = 25*ONE_ATMOSPHERE
:. number of moles = 25 * 101.325 * 10000 / (T20C * R_IDEAL_GAS_EQUATION)
 = 25331250 / 2436.0765
~= 10398.38

//portable canister
start_pressure = 45 * ONE_ATMOSPHERE
volume = 1000
:. number of moles = 45 * 101.325 * 1000 / (T20C * R_IDEAL_GAS_EQUATION)
 = 4559625 / 2436.0765
~= 1871
*/


/obj/effect/rust_em_field/proc/recalculate_fuel()
	//recalculate total fuel

	//each fuel rod holds 1000 units of fuel, each assembly holds up to 300 rods, each assembly therefore can hold up to 300,000 units of fuel
	//each unit is equivalent to 100 picometre^3
	//one fuel rod assembly therefore holds 30,000,000 pm^3 of fuel

	//max fuel density is determined by RUST_FUEL_PER_LITRE

	total_fuel = 0
	for(var/reactant in dormant_reactant_quantities)
		var/amount = dormant_reactant_quantities[reactant]
		if(amount < 1)
			dormant_reactant_quantities.Remove(reactant)
		else
			total_fuel += amount

	if(field_volume > 0)
		fuel_density = total_fuel / field_volume
	else
		fuel_density = 0


/obj/effect/rust_em_field/proc/recalculate_size()
	var/size_ratio = field_projection / MAX_RUST_PROJ
	//size_ratio *= (MIN_RUST_FREQ / field_frequency)
	var/newsize = 1
	if(size_ratio <= 0.25)
		newsize = 1
	else if(size_ratio <= 0.5)
		newsize = 3
	else if(size_ratio <= 0.75)
		newsize = 5
	else
		newsize = 7
	//
	var/changed = (size != newsize ? 1 : 0)
	switch(newsize)
		if(1)
			size = 1
			icon = 'icons/rust.dmi'
			icon_state = "emfield_s1"
			pixel_x = 0
			pixel_y = 0
		if(3)
			size = 3
			icon = 'icons/effects/96x96.dmi'
			icon_state = "emfield_s3"
			pixel_x = -32
			pixel_y = -32
		if(5)
			size = 5
			icon = 'icons/effects/160x160.dmi'
			icon_state = "emfield_s5"
			pixel_x = -64
			pixel_y = -64
		if(7)
			size = 7
			icon = 'icons/effects/224x224.dmi'
			icon_state = "emfield_s7"
			pixel_x = -96
			pixel_y = -96

	for(var/obj/effect/rust_particle_catcher/catcher in particle_catchers)
		catcher.UpdateSize()
	return changed


/obj/effect/rust_em_field/proc/recalculate_catalysis()
	//note: this process doesn't really model what catalysis is, but the term is close enough
	//catalysis here means the amount of fuel that is "available" to react, before checking whether the right fuel types are present
	//fusion reactions occur within a preset series of recipes in fuel_reactions.dm
	catalyst_rate = 0

	//fuel density increases reaction rate
	var/fuel_multiplier = fuel_density / RUST_FUEL_PER_LITRE

	//field energy increases reaction rate
	var/energy_multiplier = energy_density / RUST_ENERGY_PER_LITRE

	catalyst_rate = fuel_multiplier * energy_multiplier

	//shooting lasers into the core forces a small amount of reactions to occur
	//this is only effective to get the reaction cycle started though
	if(catalyst_rate < excitation_level / 1000)
		catalyst_rate = excitation_level / 1000

	//set values for nanoui graph
	reaction_tensec.Add(round(catalyst_rate * 100))
	if(reaction_tensec.len > 10)
		reaction_tensec.Cut(1,2)

	archived_excitation_level = excitation_level
	excitation_level = 0

	excitation_tensec.Add(round(archived_excitation_level / 10))
	if(excitation_tensec.len > 10)
		excitation_tensec.Cut(1,2)

