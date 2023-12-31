/obj/item/clothing/suit/armor
	allowed = null
	body_parts_covered = CHEST
	cold_protection = CHEST|GROIN
	min_cold_protection_temperature = ARMOR_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN
	max_heat_protection_temperature = ARMOR_MAX_TEMP_PROTECT
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 250
	resistance_flags = NONE
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 15)
	cryo_preserve = TRUE

/obj/item/clothing/suit/armor/Initialize(mapload)
	. = ..()
	if(!allowed)
		allowed = GLOB.security_vest_allowed

/obj/item/clothing/suit/armor/vest
	name = "armor vest"
	desc = "A slim Type I armored vest that provides decent protection against most types of damage."
	icon_state = "armoralt"
	item_state = "armoralt"
	blood_overlay_type = "armor"
	dog_fashion = /datum/dog_fashion/back

/obj/item/clothing/suit/armor/vest/alt
	desc = "A Type I armored vest that provides decent protection against most types of damage."
	icon_state = "armor"
	item_state = "armor"

/obj/item/clothing/suit/armor/vest/old
	name = "degrading armor vest"
	desc = "Older generation Type 1 armored vest. Due to degradation over time the vest is far less maneuverable to move in."
	icon_state = "armor"
	item_state = "armor"
	slowdown = 1

/obj/item/clothing/suit/armor/vest/blueshirt
	name = "large armor vest"
	desc = "A large, yet comfortable piece of armor, protecting you from some threats."
	icon_state = "blueshift"
	item_state = "blueshift"
	custom_premium_price = 600

/obj/item/clothing/suit/armor/hos
	name = "armored greatcoat"
	desc = "A greatcoat enhanced with a special alloy for some extra protection and style for those with a commanding presence."
	icon_state = "hos"
	item_state = "greatcoat"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 70, ACID = 90, WOUND = 20)
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	strip_delay = 80
	clothing_flags = THICKMATERIAL
	mutantrace_variation = MUTANTRACE_VARIATION
	pocket_storage_component_path = /datum/component/storage/concrete/pockets/hosarmor

/obj/item/clothing/suit/armor/hos/trenchcoat
	name = "armored trenchcoat"
	desc = "A trenchcoat enhanced with a special lightweight kevlar. The epitome of tactical plainclothes."
	icon_state = "hostrench"
	item_state = "hostrench"
	flags_inv = 0
	strip_delay = 80

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "A navy-blue armored jacket with blue shoulder designations and '/Warden/' stitched into one of the chest pockets."
	icon_state = "warden_alt"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS|HANDS
	heat_protection = CHEST|GROIN|ARMS|HANDS
	strip_delay = 70
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/warden/alt
	name = "warden's armored jacket"
	desc = "A red jacket with silver rank pips and body armor strapped on top."
	icon_state = "warden_jacket"
	mutantrace_variation = MUTANTRACE_VARIATION

/obj/item/clothing/suit/armor/vest/leather
	name = "security overcoat"
	desc = "Lightly armored leather overcoat meant as casual wear for high-ranking officers. Bears the crest of Nanotrasen Security."
	icon_state = "leathercoat-sec"
	item_state = "hostrench"
	body_parts_covered = CHEST|GROIN|ARMS|LEGS
	cold_protection = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	mutantrace_variation = MUTANTRACE_VARIATION
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/capcarapace
	name = "captain's carapace"
	desc = "A fireproof armored chestpiece reinforced with ceramic plates and plasteel pauldrons to provide additional protection whilst still offering maximum mobility and flexibility. Issued only to the station's finest, although it does chafe your nipples."
	icon_state = "capcarapace"
	item_state = "armor"
	body_parts_covered = CHEST|GROIN
	armor = list(MELEE = 50, BULLET = 40, LASER = 50, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 100, ACID = 90, WOUND = 10)
	dog_fashion = null
	resistance_flags = FIRE_PROOF

/obj/item/clothing/suit/armor/vest/capcarapace/syndicate
	name = "syndicate captain's vest"
	desc = "A sinister looking vest of advanced armor worn over a black and red fireproof jacket. The gold collar and shoulders denote that this belongs to a high ranking syndicate officer."
	icon_state = "syndievest"

/obj/item/clothing/suit/armor/vest/capcarapace/alt
	name = "captain's parade jacket"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "capformal"
	item_state = "capspacesuit"

/obj/item/clothing/suit/armor/vest/hop_formal
	name = "head of personnel's parade jacket"
	desc = "For when an armoured vest isn't fashionable enough."
	icon_state = "hopformal"
	item_state = "hopformal"

/obj/item/clothing/suit/armor/vest/capcarapace/centcom
	name = "\improper CentCom carapace"
	desc = "A CentCom green alteration of the captain's carapace. Issued only to Nanotrasen's finest, although it does chafe your pecks."
	icon_state = "centcarapace"
	item_state = "centcarapace"

/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of semi-flexible polycarbonate body armor with heavy padding to protect against melee attacks. Helps the wearer resist shoving in close quarters."
	icon_state = "riot"
	item_state = "riot"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80, WOUND = 30)
	blocks_shove_knockdown = TRUE
	strip_delay = 80
	equip_delay_other = 60
	slowdown = 0.33
	mutantrace_variation = MUTANTRACE_VARIATION

/obj/item/clothing/suit/armor/bone
	name = "bone armor"
	desc = "A mass of bones wrapped together into a protective shell. Not as effective as modern protection, but it still offers notable protection."
	allowed = list (/obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/tank/internals/ipc_coolant, /obj/item/melee/spear, /obj/item/melee/spear/bonespear, /obj/item/claymore/bone, /obj/item/gun/ballistic/bow, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat)
	icon_state = "bonearmor"
	item_state = "bonearmor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 45, BULLET = 15, LASER = 15, ENERGY = 5, BOMB = 35, BIO = 0, RAD = 0, FIRE = 10, ACID = 10, WOUND = 15)
	slowdown = 0.2
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS

/obj/item/clothing/suit/armor/bone/heavy
	name = "heavy bone armor"
	desc = "A hefty set of bones that covers most of the body. Slowing, but able to repel considerable blows."
	icon_state = "hbonearmor"
	item_state = "hbonearmor"
	armor = list(MELEE = 55, BULLET = 20, LASER = 20, ENERGY = 10, BOMB = 65, BIO = 0, RAD = 0, FIRE = 20, ACID = 20, WOUND = 20)
	slowdown = 0.4

/obj/item/clothing/suit/armor/tribalcoat
	name = "tribal coat"
	desc = "A light, yet tough leather coat, reinforced with bone pauldrons. Often worn by tribal leaders."
	allowed = list (/obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/tank/internals/ipc_coolant, /obj/item/melee/spear, /obj/item/melee/spear/bonespear, /obj/item/claymore/bone, /obj/item/gun/ballistic/bow, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat)
	icon_state = "tribalcoat"
	item_state = "tribalcoat"
	blood_overlay_type = "armor"
	armor = list(MELEE = 35, BULLET = 10, LASER = 5, ENERGY = 5, BOMB = 50, BIO = 0, RAD = 0, FIRE = 30, ACID = 30, WOUND = 10) //Better against bomb than goliath, but worse in other ways
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	resistance_flags = FLAMMABLE

/obj/item/clothing/suit/armor/pathfinder
	name = "pathfinder cloak"
	desc = "A thick cloak woven from sinew and hides, designed to protect its wearer from hazardous weather."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/pickaxe, /obj/item/melee/spear, /obj/item/melee/spear/bonespear, /obj/item/claymore/bone, /obj/item/gun/ballistic/bow, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat)
	icon_state = "pathcloak"
	item_state = "pathcloak"
	armor = list(MELEE = 30, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 50, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 15)
	resistance_flags = FIRE_PROOF
	body_parts_covered = CHEST|GROIN|LEGS|ARMS
	heat_protection = CHEST|GROIN|LEGS|ARMS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	cold_protection = CHEST|GROIN|LEGS|ARMS
	min_cold_protection_temperature = FIRE_SUIT_MIN_TEMP_PROTECT
	mutantrace_variation = MUTANTRACE_VARIATION

/obj/item/clothing/suit/armor/pathfinder/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/armor_plate, null, null, list(MELEE = 10, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 5)) //maximum armor 60/15/15/15/65

/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof armor"
	desc = "A Type III heavy bulletproof vest that excels in protecting the wearer against traditional projectile weaponry and explosives to a minor extent."
	icon_state = "bulletproof"
	item_state = "armor"
	blood_overlay_type = "armor"
	armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 20)
	strip_delay = 70
	equip_delay_other = 50

/obj/item/clothing/suit/armor/laserproof
	name = "reflective jacket"
	desc = "A jacket that excels in protecting the wearer against energy projectiles, as well as occasionally reflecting them."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	blood_overlay_type = "armor"
	body_parts_covered = CHEST|GROIN|ARMS
	cold_protection = CHEST|GROIN|ARMS
	heat_protection = CHEST|GROIN|ARMS
	armor = list(MELEE = 10, BULLET = 10, LASER = 60, ENERGY = 50, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/hit_reflect_chance = 50

/obj/item/clothing/suit/armor/laserproof/IsReflect(def_zone)
	if(!(def_zone in list(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))) //If not shot where ablative is covering you, you don't get the reflection bonus!
		return FALSE
	if (prob(hit_reflect_chance))
		return TRUE

/obj/item/clothing/suit/armor/vest/det_suit
	name = "detective's armor vest"
	desc = "An armored vest with a detective's badge on it."
	icon_state = "detective-armor"
	resistance_flags = FLAMMABLE
	dog_fashion = null

/obj/item/clothing/suit/armor/vest/det_suit/Initialize(mapload)
	. = ..()
	allowed = GLOB.detective_vest_allowed

//All of the armor below is mostly unused

/obj/item/clothing/suit/armor/centcom
	name = "\improper CentCom armor"
	desc = "A suit that protects against some damage."
	icon_state = "centcom"
	item_state = "centcom"
	w_class = WEIGHT_CLASS_BULKY
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/gun/energy, /obj/item/melee/baton, /obj/item/restraints/handcuffs, /obj/item/tank/internals/emergency_oxygen, /obj/item/tank/internals/plasmaman, /obj/item/tank/internals/ipc_coolant)
	clothing_flags = THICKMATERIAL
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	cold_protection = CHEST | GROIN | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = SPACE_SUIT_MAX_TEMP_PROTECT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/heavy
	name = "heavy armor"
	desc = "A heavily armored suit that protects against moderate damage."
	icon_state = "heavy"
	item_state = "swat_suit"
	w_class = WEIGHT_CLASS_BULKY
	gas_transfer_coefficient = 0.9
	clothing_flags = THICKMATERIAL
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	slowdown = 3
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/tdome
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	clothing_flags = THICKMATERIAL
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	armor = list(MELEE = 80, BULLET = 80, LASER = 50, ENERGY = 50, BOMB = 100, BIO = 100, RAD = 100, FIRE = 90, ACID = 90)

/obj/item/clothing/suit/armor/tdome/red
	name = "thunderdome suit"
	desc = "Reddish armor."
	icon_state = "tdred"
	item_state = "tdred"

/obj/item/clothing/suit/armor/tdome/green
	name = "thunderdome suit"
	desc = "Pukish armor."	//classy.
	icon_state = "tdgreen"
	item_state = "tdgreen"


/obj/item/clothing/suit/armor/riot/knight
	name = "plate armour"
	desc = "A classic suit of plate armour, highly effective at stopping melee attacks."
	icon_state = "knight_green"
	item_state = "knight_green"
	mutantrace_variation = NO_MUTANTRACE_VARIATION

/obj/item/clothing/suit/armor/riot/knight/yellow
	icon_state = "knight_yellow"
	item_state = "knight_yellow"

/obj/item/clothing/suit/armor/riot/knight/blue
	icon_state = "knight_blue"
	item_state = "knight_blue"

/obj/item/clothing/suit/armor/riot/knight/red
	icon_state = "knight_red"
	item_state = "knight_red"

/obj/item/clothing/suit/armor/vest/durathread
	name = "durathread vest"
	desc = "A vest made of durathread with strips of leather acting as trauma plates."
	icon_state = "durathread"
	item_state = "durathread"
	strip_delay = 60
	equip_delay_other = 40
	max_integrity = 200
	resistance_flags = FLAMMABLE
	armor = list(MELEE = 20, BULLET = 10, LASER = 30, ENERGY = 5, BOMB = 15, BIO = 0, RAD = 0, FIRE = 40, ACID = 50)

/obj/item/clothing/suit/armor/vest/russian
	name = "russian vest"
	desc = "A bulletproof vest with forest camo. Good thing there's plenty of forests to hide in around here, right?"
	icon_state = "rus_armor"
	item_state = "rus_armor"
	armor = list(MELEE = 25, BULLET = 30, LASER = 0, ENERGY = 15, BOMB = 10, BIO = 0, RAD = 20, FIRE = 20, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/vest/russian_coat
	name = "russian battle coat"
	desc = "Used in extremly cold fronts, made out of real bears."
	icon_state = "rus_coat"
	item_state = "rus_coat"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_TEMP_PROTECT
	armor = list(MELEE = 25, BULLET = 20, LASER = 20, ENERGY = 10, BOMB = 20, BIO = 50, RAD = 20, FIRE = -10, ACID = 50, WOUND = 10)

/obj/item/clothing/suit/armor/stormtrooper
	name = "Storm Trooper Armor"
	desc = "Battle Armor from a long lost empire"
	icon_state = "stormtrooper"
	item_state = "stormtrooper"
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	armor = list(MELEE = 30, BULLET = 30, LASER = 50, ENERGY = 15, BOMB = 30, BIO = 20, RAD = 10, FIRE = 80, ACID = 80, WOUND = 10)
	slowdown = 0.9

/obj/item/clothing/suit/hooded/cloak/goliath
	name = "goliath cloak"
	icon_state = "goliath_cloak"
	desc = "A staunch, practical cape made out of numerous monster materials. It is coveted amongst exiles and hermits."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/pickaxe, /obj/item/melee/spear, /obj/item/melee/spear/bonespear, /obj/item/claymore/bone, /obj/item/gun/ballistic/bow, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 10, BOMB = 35, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10) //a fair alternative to bone armor, requiring alternative materials and gaining a suit slot
	resistance_flags = FIRE_PROOF
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath
	body_parts_covered = CHEST|GROIN|ARMS

/obj/item/clothing/head/hooded/cloakhood/goliath
	name = "goliath cloak hood"
	icon_state = "golhood"
	desc = "A protective and concealing hood."
	armor = list(MELEE = 35, BULLET = 25, LASER = 25, ENERGY = 10, BOMB = 35, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 10)
	resistance_flags = FIRE_PROOF
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	transparent_protection = HIDEMASK

/obj/item/clothing/suit/hooded/cloak/goliath/desert
	name = "brown leather cape"
	desc = "An ash-coated cloak."
	icon_state = "desertcloak"
	armor = list()
	resistance_flags = 0
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/goliath/desert

/obj/item/clothing/head/hooded/cloakhood/goliath/desert
	name = "goliath cloak hood"
	icon_state = "desertcloak"
	desc = "The hood of an ashy cloak."
	armor = list()
	resistance_flags = 0
	flags_inv = HIDEEARS|HIDEEYES|HIDEHAIR|HIDEFACIALHAIR
	transparent_protection = HIDEMASK

/obj/item/clothing/suit/hooded/cloak/drake
	name = "drake armour"
	icon_state = "dragon"
	desc = "A suit of armour fashioned from the remains of an ash drake."
	allowed = list(/obj/item/flashlight, /obj/item/tank/internals, /obj/item/resonator, /obj/item/mining_scanner, /obj/item/t_scanner/adv_mining_scanner, /obj/item/gun/energy/kinetic_accelerator, /obj/item/pickaxe, /obj/item/melee/spear, /obj/item/melee/spear/bonespear, /obj/item/claymore/bone, /obj/item/gun/ballistic/bow, /obj/item/organ/regenerative_core/legion, /obj/item/kitchen/knife/combat)
	armor = list(MELEE = 70, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 60, BIO = 60, RAD = 50, FIRE = 100, ACID = 100)
	hoodtype = /obj/item/clothing/head/hooded/cloakhood/drake
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	body_parts_covered = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF
	transparent_protection = HIDEGLOVES|HIDESUITSTORAGE|HIDEJUMPSUIT|HIDESHOES

/obj/item/clothing/head/hooded/cloakhood/drake
	name = "drake helm"
	icon_state = "dragon"
	desc = "The skull of a dragon."
	armor = list(MELEE = 70, BULLET = 5, LASER = 5, ENERGY = 5, BOMB = 60, BIO = 60, RAD = 50, FIRE = 100, ACID = 100)
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	resistance_flags = FIRE_PROOF | ACID_PROOF

/obj/item/clothing/suit/armor/elder_atmosian
	name = "\improper Elder Atmosian Armor"
	desc = "A superb armor made with the toughest and rarest materials available to man."
	icon_state = "h2armor"
	item_state = "h2armor"
	armor = list(MELEE = 35, BULLET = 30, LASER = 25, ENERGY = 25, BOMB = 85, BIO = 20, RAD = 50, FIRE = 75, ACID = 40, WOUND = 15)
	body_parts_covered = CHEST|GROIN|LEGS|ARMS|HANDS
	cold_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	heat_protection = CHEST|GROIN|LEGS|FEET|ARMS|HANDS
	resistance_flags = FIRE_PROOF | ACID_PROOF
	clothing_flags = THICKMATERIAL
	mutantrace_variation = MUTANTRACE_VARIATION

//////////////// PLATED ARMOR ////////////////
// Helmet type in code/modules/clothing/head/helmet.dm
/obj/item/clothing/suit/armor/plated
	name = "empty plated armor vest"
	desc = "A lightweight general-purpose over-armor suit that is designed to hold various types of armor plating. Won't do much without them."
	icon_state = "plate-armor"
	item_state = "plate-armor"
	blood_overlay_type = "armor"
	w_class = WEIGHT_CLASS_SMALL // It's just some fabric, after all
	armor = list(MELEE = 5, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 10, ACID = 0, WOUND = 0)
	slowdown = 0

	var/obj/item/kevlar_plating/plating

/obj/item/clothing/suit/armor/plated/attack_self(mob/user)
	if(!plating)
		to_chat(user, span_warning("[src] doesn't have any plating to remove!"))
		return

	user.visible_message("[user] removes [plating] from [src]!", span_notice("You remove [plating]."))

	user.put_in_hands(plating)

	name = initial(name)
	armor = armor.setRating(5,0,0,0,0,0,0,10,0,0,0)	//because initial(armor) apparently doesn't work
	slowdown = initial(slowdown)
	w_class = initial(w_class)
	body_parts_partial_covered = initial(body_parts_partial_covered)
	plating = null

/obj/item/clothing/suit/armor/plated/examine(mob/user)
	.=..()
	if(plating)
		. += span_info("It has [plating] slotted.")

/obj/item/clothing/suit/armor/plated/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(!istype(I, /obj/item/kevlar_plating))
		return
	if(plating)
		to_chat(user, span_warning("[src] already has [plating] slotted!"))
		return
	if(!user.transferItemToLoc(I, src))
		return

	user.visible_message("[user] inserts [plating] into [src]!", span_notice("You insert [plating] into [src]."))

	var/obj/item/kevlar_plating/K = I

	name = "[K.name_set] plated armor vest"
	slowdown = K.slowdown_set

	if (islist(armor) || isnull(armor))		//For an explanation see code/modules/clothing/under/accessories.dm#L39 - accessory detach proc
		armor = getArmor(arglist(armor))
	if (islist(K.armor) || isnull(K.armor))
		K.armor = getArmor(arglist(K.armor))

	armor = armor.attachArmor(K.armor)
	w_class = WEIGHT_CLASS_BULKY
	body_parts_partial_covered = K.partial_coverage
	plating = K

//////////////// ARMOR PLATES ////////////////////////////////////////////////
// These armors are supposed to be a mid-game direct upgrade for security that enables
// them to dynamically respond depending on their skillset and/or the situation at hand
//
// balancing reference:
// default armor, slowdown 0
// armor = list(MELEE = 30, BULLET = 30, LASER = 30, ENERGY = 10, BOMB = 25, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 15)
// bulletproof armor, slowdown 0
// armor = list(MELEE = 15, BULLET = 60, LASER = 10, ENERGY = 10, BOMB = 40, BIO = 0, RAD = 0, FIRE = 50, ACID = 50, WOUND = 20)
// hos hardsuit, slowdown 1
// armor = list(MELEE = 45, BULLET = 30, LASER = 30, ENERGY = 10, BOMB = 25, BIO = 100, RAD = 50, FIRE = 95, ACID = 95, WOUND = 25)
// riot armor, slowdown 0.33
// armor = list(MELEE = 50, BULLET = 10, LASER = 10, ENERGY = 10, BOMB = 0, BIO = 0, RAD = 0, FIRE = 80, ACID = 80, WOUND = 30)
//////////////////////////////////////////////////////////////////////////////
/obj/item/kevlar_plating
	name = "debug plating"
	desc = "You shouldn't see this!"
	icon = 'icons/obj/kevlar.dmi'
	icon_state = "mki"
	force = 2
	var/name_set = "debug"
	var/slowdown_set = 0 // Slowdown value to set on the vest, for reference a hardsuit has "1" slowdown
	armor = list(MELEE = 100, BULLET = 100, LASER = 100, ENERGY = 100, BOMB = 100, BIO = 100, RAD = 100, FIRE = 100, ACID = 100, WOUND = 100) // Armor value to set on the vest
	var/partial_coverage = LEGS|FEET|ARMS|HANDS // Areas that the vest will cover besides the chest, NEVER INCLUDE CHEST OR GROIN

/obj/item/kevlar_plating/mki
	name = "MK.I bluespace plating"
	desc = "Incredibly light bluespace-infused armor plating that offers great movement while also providing some protection."
	name_set = "MK.I bluespace"
	slowdown_set = -0.1 // Speeds you up a bit in exchange for giving up some armor
	armor = list(MELEE = 15, BULLET = 20, LASER = 25, ENERGY = 5, BOMB = 5, BIO = 0, RAD = 0, FIRE = 30, ACID = 40, WOUND = 10) // Slightly worse than default armor
	partial_coverage = 0

/obj/item/kevlar_plating/mkii
	name = "MK.II ceramic plating"
	desc = "Light armor plating that can be carried easily while providing robust protection."
	icon_state = "mkii"
	force = 4
	name_set = "MK.II ceramic"
	slowdown_set = 0
	armor = list(MELEE = 30, BULLET = 35, LASER = 35, ENERGY = 15, BOMB = 25, BIO = 0, RAD = 0, FIRE = 40, ACID = 50, WOUND = 20) 	// Slightly better than default armor
	partial_coverage = 0

/obj/item/kevlar_plating/mkiii
	name = "MK.III plasteel plating"
	desc = "Weighted armor plating that impedes movement but greatly improves the durability of the wearer. Covers your limbs partially."
	icon_state = "mkiii"
	force = 6
	name_set = "MK.III plasteel"
	slowdown_set = 0.15 // Slow
	armor = list(MELEE = 40, BULLET = 45, LASER = 45, ENERGY = 25, BOMB = 30, BIO = 0, RAD = 0, FIRE = 50, ACID = 60, WOUND = 35)	//Robust
	partial_coverage = LEGS|ARMS

/obj/item/kevlar_plating/mkiv
	name = "MK.IV titanium plating"
	desc = "Incredibly heavy armor plating that makes shooting the covered areas almost pointless. Covers your limbs partially."
	icon_state = "mkiv"
	force = 8
	name_set = "MK.IV titanium"
	w_class = WEIGHT_CLASS_BULKY
	slowdown_set = 0.4 // Very slow
	armor = list(MELEE = 55, BULLET = 60, LASER = 60, ENERGY = 40, BOMB = 40, BIO = 0, RAD = 0, FIRE = 65, ACID = 75, WOUND = 50)	//Walking tank
	partial_coverage = LEGS|ARMS

/// An chest armor that grants a battery-rechargable shield with a focus on anti-range at the cost of armor.
/obj/item/clothing/suit/armor/batteryshield
	name = "battery shield armor"
	desc = "An experimental battery-changed energy shield that blocks most projectiles and thrown objects with great ease, but provides no resistance against melee attacks."
	icon_state = "reactiveoff"
	icon = 'icons/obj/clothing/suits.dmi'
	w_class = WEIGHT_CLASS_BULKY
	armor = list(MELEE = -20, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 100)
	/// What power cell is the shield drawing from?
	var/obj/item/stock_parts/cell/power_cell = /obj/item/stock_parts/cell/high
	/// Who is wearing this?
	var/mob/living/carbon/human/wearer
	/// Is it on and working?
	var/toggled = FALSE
	/// Is the maintenance panel open?
	var/maintenance = FALSE
	/// Does this block projectiles? E.g. bullets & lasers.
	var/blocks_projs = TRUE
	/// Does this block items that are thrown/collide with the armor? E.g. thrown toolboxes, potted plants.
	var/blocks_throws = TRUE
	/// Does this block melee attacks?
	var/blocks_melees = FALSE
	/// Does this prevent the user from shooting any guns?
	var/prevent_gun_usage = FALSE // Personally would of wanted the projectiles to deflect right into their own face, but this is okay.
	
/obj/item/clothing/suit/armor/batteryshield/Initialize(mapload)
	. = ..()
	power_cell = new power_cell(null)

/obj/item/clothing/suit/armor/batteryshield/examine(mob/user)
	. = ..()
	if(power_cell)
		. += "The charge meter reads [round(power_cell.percent() )]%."

/obj/item/clothing/suit/armor/batteryshield/attack_self(mob/user)
	. = ..()
	if(maintenance)
		if(!power_cell)
			to_chat(user, span_notice("There's no power cell installed in \the [src]!"))
			return
		to_chat(user, span_notice("You remove \the [power_cell] from [src]."))
		power_cell.forceMove(drop_location())
		power_cell = null
		return
	// No toggling without a battery.
	if(!power_cell)
		to_chat(user, span_notice("There's no power cell installed in \the [src]!"))
		return
	if(toggled)
		toggle_off(user)
		return
	if(power_cell.charge <= 0)
		to_chat(user, span_warning("\The [src] fails to activate!"))
		return
	// Going to trigger the explosion just for the fun of it.
	if(power_cell.rigged)
		power_cell.use(1)
		// For if it actually blew up.
		if(QDELETED(power_cell))
			power_cell = null
			return
	toggle_on(user)

/obj/item/clothing/suit/armor/batteryshield/attackby(obj/item/W, mob/user, params)
	if(!istype(W, /obj/item/stock_parts/cell))
		return ..()
	if(maintenance)
		// Already one inside.
		if(power_cell)
			to_chat(user, span_notice("You have already inserted \a cell!"))
			return
		// Can't transfer.
		if(!user.transferItemToLoc(W, src))
			return
		// Cell inserted.
		power_cell = W
		to_chat(user, span_notice("You insert \the [power_cell]."))
		return
	. = ..()

/obj/item/clothing/suit/armor/batteryshield/screwdriver_act(mob/living/user, obj/item/I)
	. = ..()
	if(.)
		return TRUE
	if(toggled)
		to_chat(user, span_warning("\The [src] is on! Turn it off first!"))
		return TRUE

	I.play_tool_sound(src)

	maintenance = !maintenance
	if(maintenance)
		to_chat(user, span_notice("You open \the [src]'s maintenance panel."))
		return TRUE
	to_chat(user, span_notice("You close \the [src]'s maintenance panel."))
	return TRUE

/obj/item/clothing/suit/armor/batteryshield/hit_reaction(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0, attack_type = MELEE_ATTACK)
	if(!toggled)
		return FALSE

	var/blocked = FALSE
	var/display_deflect_msg = TRUE

	// Blocking projectiles.
	if(blocks_projs && isprojectile(hitby))
		var/obj/projectile/proj = hitby
		var/cost = !proj.nodamage ? (proj.damage * 200) : 0 // Each point of damage takes 0.2 kw.
		power_cell.use(cost)
		blocked = TRUE
	// Blocking thrown objects.
	else if(blocks_throws && hitby.throwing)
		if(isobj(hitby))
			var/obj/obj = hitby
			var/cost = obj.throwforce * 200 // Each point of damage takes 0.2 kw.
			power_cell.use(cost)
			blocked = TRUE
	// All else is assumed to be melee.
	else if(blocks_melees && !hitby.throwing)
		// Each point of damage takes 1.0 kw; the goal is to be anti-range, not anti-melee.
		// If something falls through the crack, just make it very costly on shields.
		var/cost = 8000
		if(isitem(hitby))
			var/obj/item/item = hitby
			cost = 1000 * item.force
		if(ishuman(hitby)) // Trying to touch with their hands.
			var/mob/living/carbon/human/human = hitby
			cost = 1000 * rand(human.get_punchdamagelow(), human.get_punchdamagehigh())
			display_deflect_msg = FALSE // A different message is already shown.
		if(isanimal(hitby))
			var/mob/living/simple_animal/animal = hitby
			cost = 1000 * rand(animal.melee_damage_lower, animal.melee_damage_upper)
		power_cell.use(cost)
		blocked = TRUE

	if(!blocked)
		return FALSE
	
	var/datum/effect_system/spark_spread/s = new
	s.set_up(2, 1, src)
	s.start()
	if(display_deflect_msg)
		owner.visible_message(span_danger("[owner]'s shields deflect [attack_text] in a shower of sparks!"))

	if(power_cell.charge <= 0)
		owner.visible_message(span_warning("[owner]'s [src] overloads!"), span_boldwarning("Your [src] overloads!"))
		toggle_off(owner)
		wearer.update_inv_wear_suit()
	return TRUE

/obj/item/clothing/suit/armor/batteryshield/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(power_cell)
		power_cell.emp_act(severity)
	if(toggled)
		toggle_off()
		src.visible_message(span_warning("\The [src] overloads!"))
		wearer.update_inv_wear_suit()

/obj/item/clothing/suit/armor/batteryshield/equipped(mob/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_OCLOTHING))
		return
	if(!ishuman(user))
		return
	
	wearer = user
	if(prevent_gun_usage)
		ADD_TRAIT(wearer, TRAIT_NOGUNS, "battery shield")

/obj/item/clothing/suit/armor/batteryshield/dropped(mob/M)
	if(wearer)
		if(prevent_gun_usage)
			REMOVE_TRAIT(wearer, TRAIT_NOGUNS, "battery shield")
		wearer = null
	return ..()

/obj/item/clothing/suit/armor/batteryshield/worn_overlays(isinhands)
	. = list()
	if(!isinhands)
		. += mutable_appearance('icons/effects/effects.dmi', toggled ? "shield-old" : "broken", MOB_LAYER + 0.01)

/obj/item/clothing/suit/armor/batteryshield/proc/toggle_on(mob/user)
	toggled = TRUE
	if(user)
		to_chat(user, span_notice("\The [src] is now active."))
	icon_state = "reactive"
	item_state = "reactive"

/obj/item/clothing/suit/armor/batteryshield/proc/toggle_off(mob/user)
	toggled = FALSE
	if(user)
		to_chat(user, span_notice("\The [src] is now inactive."))
	icon_state = "reactiveoff"
	item_state = "reactiveoff"

/obj/item/clothing/suit/armor/batteryshield/admin
	name = "omega battery shield armor"
	desc = "A suit of armor that blocks all projectiles and thrown objects with an infinite recharging battery."
	power_cell = /obj/item/stock_parts/cell/infinite

/obj/item/clothing/suit/armor/batteryshield/admin/screwdriver_act(mob/living/user, obj/item/I)
	// Do not let them enter maintenance mode and remove the battery.
	return TRUE
