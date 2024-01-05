/*
 * Corporate Judo
 * An alternative method of dealing with tiders that isn't a stunbaton for security officers.
*/

#define DISCOMBOULATE_COMBO "DG"
#define EYEPOKE_COMBO "DH"
#define JUDOTHROW_COMBO "GD"
#define ARMBAR_COMBO "DDG"
#define WHEELTHROW_COMBO "GGD"

/datum/martial_art/corporate_judo
	name = "Corporate Judo"
	id = MARTIALART_CORPORATEJUDO
	help_verb = /mob/living/carbon/human/proc/corporate_judo_help
	nonlethal = TRUE
	/// Only allow use of this martial arts if in the main services areas (bar and kitchen); if for some reason, we want to give to the bartender in the future.
	var/service_only = FALSE

/datum/martial_art/corporate_judo/can_use(mob/living/carbon/human/user)
	var/area/current_area = get_area(user)
	if(service_only)
		var/list/restricted_areas = list(/area/crew_quarters/kitchen, /area/crew_quarters/bar)
		for(var/area/restricted_area in restricted_areas)
			if(istype(current_area, restricted_area))
				return ..()
		return FALSE
	return ..()

/datum/martial_art/corporate_judo/teach(mob/living/carbon/human/user, make_temporary = FALSE)
	..()
	ADD_TRAIT(user, TRAIT_NO_STUN_WEAPONS, "corporate judo")

/datum/martial_art/corporate_judo/on_remove(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_NO_STUN_WEAPONS, "corporate judo")
	return ..()

/datum/martial_art/corporate_judo/disarm_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_use(user) || !can_use(target))
		return FALSE
	add_to_streak("D", target)
	if(handle_combos(user, target))
		return TRUE
	return FALSE 

/datum/martial_art/corporate_judo/grab_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_use(user) || !can_use(target))
		return FALSE
	add_to_streak("G", target)
	if(handle_combos(user, target))
		return TRUE
	return FALSE 

/datum/martial_art/corporate_judo/harm_act(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_use(user) || !can_use(target))
		return FALSE
	add_to_streak("H", target)
	if(handle_combos(user, target))
		return TRUE
	return FALSE

/datum/martial_art/corporate_judo/proc/handle_combos(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_use(user) || !can_use(target))
		return FALSE
	if(findtext(streak, ARMBAR_COMBO))
		if(armbar(user, target)) // Can fail.
			streak = ""
			return TRUE
	if(findtext(streak, WHEELTHROW_COMBO))
		if(wheelthrow(user, target)) // Can fail.
			streak = ""
			return TRUE
	if(findtext(streak, DISCOMBOULATE_COMBO))
		streak = ""
		discomboulate(user, target) // Will always be true.
		return TRUE
	if(findtext(streak, EYEPOKE_COMBO))
		streak = ""
		eyepoke(user, target) // Will always be true.
		return TRUE
	if(findtext(streak, JUDOTHROW_COMBO))
		if(judo_throw(user, target)) // Can fail.
			streak = ""
			return TRUE

	return FALSE // Continue on with the normal act.

/// Inflicts stamina damage and confuses the target.
/datum/martial_art/corporate_judo/proc/discomboulate(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)
	target.visible_message(
		span_warning("[user] strikes [target] in the head with [user.p_their()] palm!"),
		span_userdanger("[user] strikes you with [user.p_their()] palm!")
	)
	playsound(get_turf(user), 'sound/weapons/slap.ogg', 40, TRUE, -1)
	target.apply_damage(10, STAMINA)
	target.set_confusion_if_lower(5 SECONDS)
	log_combat(user, target, "discombobulated (Corporate Judo)")
	return TRUE

/// Inflicts brute/stamina damage and tries to temporarily blind/blur the target's vision.
/datum/martial_art/corporate_judo/proc/eyepoke(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.do_attack_animation(target, ATTACK_EFFECT_PUNCH)

	var/has_head = target.get_bodypart(BODY_ZONE_PRECISE_EYES)
	if(!has_head || !user.can_inject(target, FALSE, BODY_ZONE_PRECISE_EYES))
		var/msg = has_head ? "Their eyes are too protected!" : "They do not have a head!"
		to_chat(user, span_warning(msg))
		target.visible_message(
			span_warning("[user] tries to jabs [target] in [user.p_their()] eyes, but fails!"),
			span_userdanger("[user] tries to jab you in the eyes, but fails!")
		)
		playsound(get_turf(target), 'sound/weapons/whip.ogg', 40, TRUE, -1)

		user.apply_damage(5, BRUTE, user.get_active_hand()) // Owch, your fingers.
		target.apply_damage(5, STAMINA) // A small prize for trying anyways.
		log_combat(user, target, "eyepoked fail (Corporate Judo)")
		return TRUE

	// Your fingers function like a screwdriver that can bypass normal eye protection.
	// Protection reduce the damage and other effects. Lack of eyes increase damage, but completely negates other effects.
	target.visible_message(
		span_warning("[user] jabs [target] in [user.p_their()] eyes!"),
		span_userdanger("[user] jabs you in the eyes!")
	)
	playsound(get_turf(target), 'sound/weapons/whip.ogg', 40, TRUE, -1)

	var/eyes_protected = target.is_eyes_covered()
	var/obj/item/organ/eyes/eyes = target.getorganslot(ORGAN_SLOT_EYES)
	if(!eyes)
		var/damage = eyes_protected ? 20 : 30
		target.apply_damage(damage, STAMINA) // I do not want to imagine fingers in empty eye holes.
		log_combat(user, target, "eyepoked no-eye (Corporate Judo)")
		return TRUE

	var/blindness_duration = eyes_protected ? 2 SECONDS: 4 SECONDS
	var/blurriness_duration = eyes_protected ? 10 : 20 // Intentionally not multiplied by seconds.
	var/damage = eyes_protected ? 10 : 20
	target.adjust_temp_blindness_up_to(blindness_duration, blindness_duration)
	target.adjust_blurriness(max(0, blurriness_duration - target.eye_blurry))

	target.apply_damage(damage, STAMINA)
	log_combat(user, target, "eyepoked (Corporate Judo)")
	return TRUE

/datum/martial_art/corporate_judo/proc/judo_throw(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(user.mobility_flags & MOBILITY_STAND)) // User standing.
		return FALSE
	if(!(target.mobility_flags & MOBILITY_STAND)) // Target standing.
		return FALSE
	
	user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
	target.visible_message(
		span_warning("[user] judo throws [target] to ground!"),
		span_userdanger("[user] judo throws you to the ground!")
	)
	playsound(get_turf(target), 'sound/effects/hit_kick.ogg', 40, TRUE, -1)

	target.apply_damage(25, STAMINA)
	target.Knockdown(3 SECONDS)
	log_combat(user, target, "judothrow (Corporate Judo)")
	return TRUE

/datum/martial_art/corporate_judo/proc/armbar(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(user.mobility_flags & MOBILITY_STAND)) // User standing.
		return FALSE
	if((target.mobility_flags & MOBILITY_STAND)) // Target not standing.
		return FALSE
	
	user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
	target.visible_message(
		span_warning("[user] puts [target] into an armbar!"),
		span_userdanger("[user] wrestles you into an armbar!")
	)
	playsound(get_turf(user), 'sound/weapons/slashmiss.ogg', 40, TRUE, -1)

	target.apply_damage(50, STAMINA)
	log_combat(user, target, "armbar (Corporate Judo)")
	return TRUE

/datum/martial_art/corporate_judo/proc/wheelthrow(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if((target.mobility_flags & MOBILITY_STAND)) // Target not standing.
		return FALSE
	if(target.getStaminaLoss() < 50) // Target must have taken 50 stamina damage for this finisher.
		return FALSE

	user.do_attack_animation(target, ATTACK_EFFECT_DISARM)
	target.visible_message(
		span_warning("[user] raises [target] over [user.p_their()] shoulder, and slams [target.p_them()] into the ground!"),
		span_userdanger("[user] throws you over [user.p_their()] shoulder, slamming you into the ground!")
	)
	playsound(get_turf(user), 'sound/magic/tail_swing.ogg', 40, TRUE, -1)
	target.SpinAnimation(0.5 SECONDS, 1)
	target.apply_damage(120, STAMINA)
	target.set_confusion_if_lower(10 SECONDS)
	log_combat(user, target, "wheelthrow (Corporate Judo)")
	return TRUE

/mob/living/carbon/human/proc/corporate_judo_help()
	set name = "Remember Teachings" // Soo creative, wow.
	set desc = "You try to remember the teachings of Corporate Judo."
	set category = "Corporate Judo"
	var/list/combined_msg = list()

	combined_msg += "<b><i>You try to remember the teachings of Corporate Judo.</i></b>"
	combined_msg += span_notice("<b>As long you know Corporate Judo, you cannot use any stunning weapons such as stunbatons and flashes.</b>")
	combined_msg += "[span_notice("Discomboulate")]: Disarm Grab. Deals 10 stamina damage and 5 seconds of confusion."
	combined_msg += "[span_notice("Eye Poke")]: Disarm Harm. Deals 20 stamina damage, 20 seconds of blurriness, and 4 seconds of blindness. Effects is halved if they have basic eye protection (e.g. any eyewear). Completely negated if they have lots of eye protection (e.g. hardsuit helmets)."
	combined_msg += "[span_notice("Judo Throw")]: Grab Disarm. Deals 25 stamina damage and knockdowns for 3 seconds. Only works on standing targets and if you are standing."
	combined_msg += "[span_notice("Armbar")]: Disarm Disarm Grab. Deals 50 stamina damage. Only works on downed targets and if you are standing."
	combined_msg += "[span_notice("Wheel Throw")]: Grab Grab Disarm. Deals 120 stamina damage and confuses for 10 seconds. Only works on downed targets that have 50 stamina damage or more."
	to_chat(usr, examine_block(combined_msg.Join("\n")))

// Apparently, all belts are storage belts. Wrestling belt is the closest we're gonna get.
/obj/item/storage/belt/corporate_judo
	name = "\improper Corporate Judo Belt"
	desc = "Teaches the wearer NT Corporate Judo."
	icon = 'icons/obj/clothing/belts.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/belt_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/belt_righthand.dmi'
	icon_state = "judobelt"
	item_state = "judo"
	w_class = WEIGHT_CLASS_BULKY
	var/datum/martial_art/corporate_judo/style = new

/obj/item/storage/belt/corporate_judo/Initialize(mapload)
	. = ..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	STR.max_items = 1
	STR.set_holdable(list(/obj/item/book/manual/wiki/security_space_law))

/obj/item/storage/belt/corporate_judo/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == ITEM_SLOT_BELT)
		var/mob/living/carbon/human/human_user = user
		style.teach(human_user, 1)

/obj/item/storage/belt/corporate_judo/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/human_user = user
	if(human_user.get_item_by_slot(ITEM_SLOT_BELT) == src)
		style.remove(human_user)
