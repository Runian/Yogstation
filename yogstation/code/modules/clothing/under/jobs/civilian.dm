/obj/item/clothing/under/yogs/tourist
	name = "Hawaiian shirt"
	desc = "I explored the galaxy and all I got was this lousy T-shirt!"
	icon_state = "tourist"
	item_state = "gy_suit"
	can_adjust = FALSE
	mutantrace_variation = MUTANTRACE_VARIATION
/obj/item/clothing/under/yogs/rank/clerk
	desc = "Oh, look it comes with its own vest."
	name = "clerk's uniform"
	icon_state = "clerk"
	item_state = "clerk"
	can_adjust = FALSE
	mutantrace_variation = MUTANTRACE_VARIATION

/obj/item/clothing/under/yogs/rank/clerk/skirt
	desc = "Oh, look it comes with its own vest."
	name = "clerk's skirt"
	icon_state = "clerk_skirt"
	item_state = "clerk_skirt"
	body_parts_covered = CHEST|GROIN|ARMS
	fitted = FEMALE_UNIFORM_TOP
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/under/yogs/rank/miner/medic
	desc = "A verstile blue and white uniform honored to hard working recovery medics in hazardous environments. It has minor protection against biohazards."
	name = "recovery medic's jumpsuit"
	icon_state = "recovery"
	item_state = "recovery"
	can_adjust = FALSE
	sensor_mode = 3
	random_sensor = FALSE
	armor = list(MELEE = 0, BULLET = 0, LASER = 0,ENERGY = 0, BOMB = 0, BIO = 15, RAD = 0, FIRE = 80, ACID = 0, WOUND = 10)
	mutantrace_variation = MUTANTRACE_VARIATION
