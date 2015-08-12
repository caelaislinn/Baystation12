
/*
The magnetic core field draws phoron out of the air and holds it in suspension.
Greater field size (volume) increases the phoron capacity and suspension rate, as well as determining the fuel and energy density.

If there is too much phoron in the atmosphere to suspend it all or there are other gases in the atmosphere (only phoron can be suspended within the field)
a certain amount of energy bleeds out into the local air as heat.

Reaction fuel is inserted into the core field via special particle accelerators called fuel injectors.
Injection rate and fuel composition are customisable, and there are multiple different fuel reactions available depending on personal preference.
For convenience of refuelling, fuel injectors can have assembly ports built onto adjacent walls allowing refuelling without even being in the same room.

Reaction rate is determined by the fuel and energy density. Emitters (or any directed energy weapon)
can stimulate a small amount of reactions to happen to get the cycle started. With low field energy, a high fuel density is needed before reaction occurs and vice versa.

Once energy density reaches a certain point, it begins "phasing" phoron. Phased phoron leaves the field with a packet of energy,
passing through ordinary matter but not interacting with anything until it randomly phases back into realspace nearby
(leaving a pretty lightshow and random toxin molecules in the air vents).

Higher frequency increases the energy phasing threshold, while lower phoron density in the field increases the energy loss per phase.
Higher field strength decreases the amount of phoron required for each unit of phasing energy,
but matching field strength and frequency reduces the energy loss from insufficient phoron density while phasing by 90%.

Phase inducers within range of the field will attract freefloating phased phoron safely, dephasing it back into normal phoron and generating energy from it.
Inducers have a set limit though, and engineers should ensure they are always operating below capacity for safety reasons.

Too much energy but not enough phoron phasing means additional energy will be lost as radiation.
If fuel density in the field gets too high, it will start getting "lost" as heavy radiation which has a shorter range (line of sight) but is much more deadly.

Secondary power can be generated through TEGs via heating of the core vessel and dephased phoron.

*/

#define RUST_ENERGY_HEAT_MULTIPLIER 1000
#define RUST_FUEL_PER_LITRE 0.1
#define RUST_ENERGY_PER_LITRE 100
#define MAX_RUST_STR 10
#define MIN_RUST_STR 1
#define MAX_RUST_FREQ 20
#define MIN_RUST_FREQ 1
#define MAX_RUST_PROJ 7
#define MIN_RUST_PROJ 1
#define RUST_PHORON_PER_PHASE 0.01
#define RUST_PHASE_RANGE 14
#define RUST_INDUCER_POWER_RATE 10
#define RUST_REACTION_PRODUCTION_RATE 20
#define RUST_RAD_FALLOFF 10
#define RUST_ENERGY_RAD_CONVERSION 0.001
