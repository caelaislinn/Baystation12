
//gimmicky hack to collect particles and direct them into the field
/obj/effect/rust_particle_catcher
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	density = 0
	layer = 4
	var/obj/effect/rust_em_field/parent
	var/mysize = 0

	invisibility = 101

/*/obj/effect/rust_particle_catcher/New()
	for(var/obj/machinery/rust/em_field/field in range(6))
		parent = field
	if(!parent)
		qdel(src)*/

/obj/effect/rust_particle_catcher/process()
	if(!parent)
		qdel(src)

/obj/effect/rust_particle_catcher/proc/SetSize(var/newsize)
	name = "collector [newsize]"
	mysize = newsize
	UpdateSize()

/obj/effect/rust_particle_catcher/proc/TryAddParticles(var/obj/effect/accelerated_particle/particle)
	if(parent && parent.size >= mysize)
		return parent.AddParticles(particle.particle_type, particle.additional_particles + 1)

/obj/effect/rust_particle_catcher/proc/UpdateSize()
	if(parent.size >= mysize)
		//invisibility = 0
		density = 1
		name = "collector [mysize] ON"
	else
		//invisibility = 101
		density = 0
		name = "collector [mysize] OFF"

/obj/effect/rust_particle_catcher/bullet_act(var/obj/item/projectile/Proj)
	if(parent)
		//world << "catcher hit by [Proj] [Proj.type] [Proj.damage]"
		if(Proj.check_armour != "bullet")
			parent.AddEnergy(Proj.damage / 10, 0)
			parent.excitation_level += Proj.damage / 10
			update_icon()
		else
			parent.visible_message("\icon[parent] [Proj] \icon[Proj] hits an invisible wall of force!")
		return 0

//why this no work??
/*
/obj/effect/rust_particle_catcher/Bump(atom/A)
	if(istype(A, /mob))
		A << "\red A mysterious force pushes you back!"
		..()
	else if(istype(A, /obj/effect/accelerated_particle))
		if(TryAddParticles(A))
			world << "catcher hit by [A] [A.type]"
			var/obj/effect/accelerated_particle/P = A
			P.movement_range = 0
			..()
	else
		..()
*/