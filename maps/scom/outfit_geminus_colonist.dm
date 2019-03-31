
/decl/hierarchy/outfit/geminus_colonist
	name = "Geminus Colonist"
	l_ear = /obj/item/device/radio/headset
	flags = OUTFIT_HAS_BACKPACK

/decl/hierarchy/outfit/geminus_colonist/pre_equip(mob/living/carbon/human/H)

	uniform = pick(\
		/obj/item/clothing/under/color/aqua,\
		/obj/item/clothing/under/color/black,\
		/obj/item/clothing/under/color/blue,\
		/obj/item/clothing/under/color/brown,\
		/obj/item/clothing/under/color/darkblue,\
		/obj/item/clothing/under/color/darkred,\
		/obj/item/clothing/under/color/green,\
		/obj/item/clothing/under/color/grey,\
		/obj/item/clothing/under/color/lightblue,\
		/obj/item/clothing/under/color/lightbrown,\
		/obj/item/clothing/under/color/lightgreen,\
		/obj/item/clothing/under/color/lightpurple,\
		/obj/item/clothing/under/color/lightred,\
		/obj/item/clothing/under/color/orange,\
		/obj/item/clothing/under/color/pink,\
		/obj/item/clothing/under/color/red,\
		/obj/item/clothing/under/color/white,\
		/obj/item/clothing/under/color/yellow,\
		/obj/item/clothing/under/color/yellowgreen\
		)
	shoes = pick(\
		/obj/item/clothing/shoes/black,\
		/obj/item/clothing/shoes/brown,\
		/obj/item/clothing/shoes/white,\
		/obj/item/clothing/shoes/red,\
		/obj/item/clothing/shoes/orange,\
		/obj/item/clothing/shoes/yellow,\
		/obj/item/clothing/shoes/purple,\
		/obj/item/clothing/shoes/green,\
		/obj/item/clothing/shoes/blue\
		)
	head = pick(\
		/obj/item/clothing/head/bandana,\
		/obj/item/clothing/head/beret,\
		/obj/item/clothing/head/beret/purple,\
		/obj/item/clothing/head/beret/plaincolor,\
		/obj/item/clothing/head/cowboy_hat,\
		/obj/item/clothing/head/det,\
		/obj/item/clothing/head/det/grey,\
		/obj/item/clothing/head/flatcap,\
		/obj/item/clothing/head/ushanka,\
		/obj/item/clothing/head/utility,\
		/obj/item/clothing/head/soft,\
		/obj/item/clothing/head/soft/black,\
		/obj/item/clothing/head/soft/blue,\
		/obj/item/clothing/head/soft/green,\
		/obj/item/clothing/head/soft/grey,\
		/obj/item/clothing/head/soft/mbill,\
		/obj/item/clothing/head/soft/mime,\
		/obj/item/clothing/head/soft/orange,\
		/obj/item/clothing/head/soft/purple,\
		/obj/item/clothing/head/soft/red,\
		/obj/item/clothing/head/soft/yellow\
		)
	gloves = pick(\
		/obj/item/clothing/gloves/duty,\
		/obj/item/clothing/gloves/thick\
	)
	suit = pick(\
		/obj/item/clothing/suit/leathercoat,\
		/obj/item/clothing/suit/wizrobe/gentlecoat,\
		/obj/item/clothing/suit/chaplain_hoodie,\
		/obj/item/clothing/suit/apron,\
		/obj/item/clothing/suit/apron/overalls\
	)
