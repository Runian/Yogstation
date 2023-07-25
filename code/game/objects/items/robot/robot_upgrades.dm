// robot_upgrades.dm
// Contains various borg upgrades.

/// The amount of times that the expander upgrade can be used.
#define EXPANDER_MAXIMUM_STACK 2

/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	/// Prevents the upgrade from being used.
	var/locked = FALSE
	/// Does this upgrade require the cyborg to select a module first?
	var/require_module = 0
	/// Is this upgrade only for a specific module? If so, they need to be using this module to gain the upgrade.
	var/module_type = null
	/// Should this upgrade be consumed/deleted on use?
	var/one_use = FALSE
	///	Bitflags listing module compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/module_flags = NONE

/// Called when upgrade is used on the cyborg.
/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R, user = usr)
	if(R.stat == DEAD)
		to_chat(user, span_notice("[src] will not function on a deceased cyborg."))
		return FALSE
	if(module_type && !istype(R.module, module_type))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(user, "There's no mounting point for the module!")
		return FALSE
	return TRUE

/// Called when upgrade is removed from the cyborg.
/obj/item/borg/upgrade/proc/deactivate(mob/living/silicon/robot/R, user = usr)
	if (!(src in R.upgrades))
		return FALSE
	return TRUE

/obj/item/borg/upgrade/rename
	name = "cyborg reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	var/heldname = ""
	one_use = TRUE

/// Prompts the user to enter what new name they want to give.
/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = stripped_input(user, "Enter new robot name", "Cyborg Reclassification", heldname, MAX_NAME_LEN)
	log_game("[key_name(user)] have set \"[heldname]\" as a name in a cyborg reclassification board at [loc_name(user)]")

/// Changes the cyborg's name to something else.
/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(!length(heldname))
			to_chat(user, span_notice("This board doesn't have a name set!"))
			return FALSE

		var/oldname = R.real_name
		var/oldkeyname = key_name(R)
		R.custom_name = heldname
		R.updatename()
		if(oldname != R.real_name) // Only notify/log if it was changed.
			R.notify_ai(RENAME, oldname, R.real_name)
			log_game("[key_name(user)] have used a cyborg reclassification board to rename [oldkeyname] to [key_name(R)] at [loc_name(user)]")

/obj/item/borg/upgrade/restart
	name = "cyborg emergency reboot module"
	desc = "Used to force a reboot of a disabled-but-repaired cyborg, bringing it back online."
	icon_state = "cyborg_upgrade1"
	one_use = TRUE

/// Revives the cyborg if they're dead and are sufficiently repaired.
/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/R, user = usr)
	if(R.health < 0)
		to_chat(user, span_warning("You have to repair the cyborg before using this module!"))
		return FALSE
	if((R.stat != DEAD))
		to_chat(user, span_warning("This module only works on dead cyborgs!"))
		return FALSE
	if(R.mind)
		R.mind.grab_ghost()
		playsound(loc, 'sound/voice/liveagain.ogg', 75, TRUE)
	else
		playsound(loc, 'sound/machines/ping.ogg', 75, TRUE)
	R.revive()
	R.logevent("WARN -- System recovered from unexpected shutdown.")
	R.logevent("System brought online.")
	return TRUE

/obj/item/borg/upgrade/panel_access_remover
	name = "cyborg firmware hack"
	desc = "Used to override the default firmware of a cyborg and disable panel access restrictions."
	icon_state = "cyborg_upgrade2"
	one_use = TRUE

/// Removes all access requirements to a cyborg's cover.
/obj/item/borg/upgrade/panel_access_remover/action(mob/living/silicon/robot/R, user = usr)
	R.req_access = list()
	return TRUE

/obj/item/borg/upgrade/panel_access_remover/freeminer
	name = "free miner cyborg firmware hack"
	desc = "Used to override the default firmware of a cyborg with the freeminer version."
	icon_state = "cyborg_upgrade2"

/// Changes the access requirements to a cyborg's cover to need freeminer engineer access.
/obj/item/borg/upgrade/panel_access_remover/freeminer/action(mob/living/silicon/robot/R, user = usr)
	R.req_access = list(ACCESS_FREEMINER_ENGINEER)
	new /obj/item/borg/upgrade/panel_access_remover/freeminer(R.drop_location()) // Makes this upgrade re-usable by creating a new one while using all the functionality of 'one_use'.
	return TRUE

/obj/item/borg/upgrade/vtec
	name = "cyborg VTEC module"
	desc = "Used to kick in a cyborg's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_module = TRUE

/// Doubles the cyborg's movespeed as long they are not flying/floating.
/obj/item/borg/upgrade/vtec/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.has_movespeed_modifier("VTEC"))
			to_chat(R, span_notice("A VTEC unit is already installed!"))
			to_chat(user, span_notice("There's no room for another VTEC unit!"))
			return FALSE

		R.add_movespeed_modifier("VTEC", update=TRUE, priority=100, multiplicative_slowdown=-1, blacklisted_movetypes=(FLYING|FLOATING))

/obj/item/borg/upgrade/vtec/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.remove_movespeed_modifier("VTEC")

/obj/item/borg/upgrade/disablercooler
	name = "cyborg rapid disabler cooling module"
	desc = "Used to cool a mounted disabler, greatly increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/security
	module_flags = BORG_MODULE_SECURITY

/// Lowers the charge_delay of the cyborg disabler. Consequently, it recharges faster.
/obj/item/borg/upgrade/disablercooler/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.module.modules
		if(!T)
			to_chat(user, span_notice("This cyborg does not have a disabler to upgrade!"))
			return FALSE

		if(T.charge_delay != initial(T.charge_delay))
			to_chat(R, span_notice("A cooling unit is already installed!"))
			to_chat(user, span_notice("There's no room for another cooling unit!"))
			return FALSE

		// CURRENTLY: This allows for disabler spam as the amount recharged will be almost on-par with the amount used.
		T.charge_delay = max(2, T.charge_delay - 4)

/obj/item/borg/upgrade/disablercooler/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.module.modules
		if(!T)
			return FALSE
		T.charge_delay = initial(T.charge_delay)

/obj/item/borg/upgrade/thrusters
	name = "ion thruster upgrade"
	desc = "An energy-operated thruster system for cyborgs."
	icon_state = "cyborg_upgrade3"

/// Gives the cyborg the ability to fly in no gravity.
/obj/item/borg/upgrade/thrusters/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.ionpulse)
			to_chat(user, span_notice("This unit already has ion thrusters installed!"))
			return FALSE

		R.ionpulse = TRUE

/obj/item/borg/upgrade/thrusters/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.ionpulse = FALSE

/// Contains common languages.
/obj/item/borg/upgrade/language
	name = "translation matrix upgrade"
	desc = "Increases the translation matrix to include all xeno languages."
	icon_state = "cyborg_upgrade2"
	var/list/languages = list(
		/datum/language/bonespeak,
		/datum/language/draconic,
		/datum/language/english,
		/datum/language/etherean,
		/datum/language/felinid,
		/datum/language/mothian,
		/datum/language/polysmorph,
		/datum/language/sylvan
	)

/// Contains both common and rarer languages.
/obj/item/borg/upgrade/language/expanded
	name = "advanced translation matrix upgrade"
	desc = "Increases the translation matrix to include an even wider variety in langauges."
	languages = list(
		/datum/language/bonespeak,
		/datum/language/draconic,
		/datum/language/english,
		/datum/language/etherean,
		/datum/language/felinid,
		/datum/language/mothian,
		/datum/language/polysmorph,
		/datum/language/sylvan,
		/datum/language/aphasia,
		/datum/language/beachbum,
		/datum/language/egg,
		/datum/language/monkey,
		/datum/language/mouse,
		/datum/language/mushroom,
		/datum/language/slime
	)

/// Contains every language.
/obj/item/borg/upgrade/language/omni
	name = "universal translation matrix upgrade"
	desc = "Allow the translation matrix to handle any language"
	languages = list()

/obj/item/borg/upgrade/language/omni/Initialize(mapload)
	. = ..()
	languages = subtypesof(/datum/language)

/// Gives the cyborg the ability to speak and understand the listed languages.
/obj/item/borg/upgrade/language/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/datum/language/lang as anything in languages)
			R.grant_language(lang, TRUE, TRUE, LANGUAGE_SOFTWARE)

/obj/item/borg/upgrade/language/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.remove_all_languages(LANGUAGE_SOFTWARE)

/obj/item/borg/upgrade/ddrill
	name = "mining cyborg diamond drill"
	desc = "A diamond drill replacement for the mining module's standard drill."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/miner
	module_flags = BORG_MODULE_MINER

/// Replaces the cyborg's mining drill and shovel with a diamond mining drill.
/obj/item/borg/upgrade/ddrill/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/pickaxe/drill/cyborg/D in R.module)
			R.module.remove_module(D, TRUE)
		for(var/obj/item/shovel/S in R.module)
			R.module.remove_module(S, TRUE)

		var/obj/item/pickaxe/drill/cyborg/diamond/DD = new /obj/item/pickaxe/drill/cyborg/diamond(R.module)
		R.module.basic_modules += DD
		R.module.add_module(DD, FALSE, TRUE)

/obj/item/borg/upgrade/ddrill/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/pickaxe/drill/cyborg/diamond/DD in R.module)
			R.module.remove_module(DD, TRUE)

		var/obj/item/pickaxe/drill/cyborg/D = new (R.module)
		R.module.basic_modules += D
		R.module.add_module(D, FALSE, TRUE)
		var/obj/item/shovel/S = new (R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/soh
	name = "mining cyborg satchel of holding"
	desc = "A satchel of holding replacement for mining cyborg's ore satchel module."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/miner
	module_flags = BORG_MODULE_MINER

/// Replaces the cyborg's ore satchel with a bluespace ore satchel.
/obj/item/borg/upgrade/soh/action(mob/living/silicon/robot/R , user = usr)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/ore/cyborg/S in R.module)
			R.module.remove_module(S, TRUE)

		var/obj/item/storage/bag/ore/holding/H = locate() in R.module.modules
		if(H)
			to_chat(user, span_warning("This unit is already equipped with a satchel of holding."))
			return FALSE

		H = new /obj/item/storage/bag/ore/holding(R.module)
		R.module.basic_modules += H
		R.module.add_module(H, FALSE, TRUE)

/obj/item/borg/upgrade/soh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/storage/bag/ore/holding/H in R.module)
			R.module.remove_module(H, TRUE)

		var/obj/item/storage/bag/ore/cyborg/S = new (R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/tboh
	name = "janitor cyborg trash bag of holding"
	desc = "A trash bag of holding replacement for the janiborg's standard trash bag."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/janitor
	module_flags = BORG_MODULE_JANITOR

/// Replaces the cyborg's trash bag with a bluespace trash bag.
/obj/item/borg/upgrade/tboh/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/cyborg/TB in R.module.modules)
			R.module.remove_module(TB, TRUE)

		var/obj/item/storage/bag/trash/bluespace/cyborg/B = locate() in R.module.modules
		if(B)
			to_chat(user, span_warning("This unit is already equipped with a trash bag of holding."))
			return FALSE

		B = new /obj/item/storage/bag/trash/bluespace/cyborg(R.module)
		R.module.basic_modules += B
		R.module.add_module(B, FALSE, TRUE)

/obj/item/borg/upgrade/tboh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/bluespace/cyborg/B in R.module.modules)
			R.module.remove_module(B, TRUE)

		var/obj/item/storage/bag/trash/cyborg/TB = new (R.module)
		R.module.basic_modules += TB
		R.module.add_module(TB, FALSE, TRUE)

/obj/item/borg/upgrade/amop
	name = "janitor cyborg advanced mop"
	desc = "An advanced mop replacement for the janiborg's standard mop."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = /obj/item/robot_module/janitor
	module_flags = BORG_MODULE_JANITOR

/// Replaces the cyborg's mop with an advanced mop.
/obj/item/borg/upgrade/amop/action(mob/living/silicon/robot/R, user = usr)//yogs single line
	. = ..()
	if(.)
		for(var/obj/item/mop/cyborg/M in R.module.modules)
			R.module.remove_module(M, TRUE)

		var/obj/item/mop/advanced/cyborg/A = new /obj/item/mop/advanced/cyborg(R.module)
		R.module.basic_modules += A
		R.module.add_module(A, FALSE, TRUE)

/obj/item/borg/upgrade/amop/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/mop/advanced/cyborg/A in R.module.modules)
			R.module.remove_module(A, TRUE)

		var/obj/item/mop/cyborg/M = new (R.module)
		R.module.basic_modules += M
		R.module.add_module(M, FALSE, TRUE)

/obj/item/borg/upgrade/syndicate
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a cyborg."
	icon_state = "cyborg_upgrade3"
	require_module = 1

/// Gives all the benefits and drawbacks that being emagged would get without the subversive lawset that an emag would give.
/obj/item/borg/upgrade/syndicate/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.emagged)
			return FALSE

		R.SetEmagged(1)
		R.logevent("WARN: hardware installed with missing security certificate!") //A bit of fluff to hint it was an illegal tech item
		R.logevent("WARN: root privleges granted to PID [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error

		return TRUE

/obj/item/borg/upgrade/syndicate/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.SetEmagged(FALSE)

/obj/item/borg/upgrade/lavaproof
	name = "mining cyborg lavaproof tracks"
	desc = "An upgrade kit to apply specialized coolant systems and insulation layers to mining cyborg tracks, enabling them to withstand exposure to molten rock."
	icon_state = "ash_plating"
	resistance_flags = LAVA_PROOF | FIRE_PROOF
	require_module = 1
	module_type = /obj/item/robot_module/miner
	module_flags = BORG_MODULE_MINER

/// Gives the cyborg the ability to move across lava unharmed.
/obj/item/borg/upgrade/lavaproof/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.weather_immunities += WEATHER_LAVA

/obj/item/borg/upgrade/lavaproof/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.weather_immunities -= WEATHER_LAVA

/obj/item/borg/upgrade/selfrepair
	name = "self-repair module"
	desc = "This module will repair the cyborg over time."
	icon_state = "cyborg_upgrade5"
	require_module = 1
	COOLDOWN_DECLARE(next_repair)
	/// How many deciseconds until they are repaired again?
	var/repair_cooldown = 4 SECONDS
	COOLDOWN_DECLARE(next_message)
	/// How many deciseconds until they are reminded of the upgrade's active repair mode?
	var/message_cooldown = 200 SECONDS
	/// Is this on or off?
	var/on = FALSE
	/// How much power does it cost to repair? 0.5x if idle (no repair) and 3x if boosted (critical repair).
	var/powercost = 10
	/// How much damage (for brute and burn each) does heal on repair? 2.5x if boosted (critical repair).
	var/repair_amount = -1
	var/datum/action/toggle_action

// Gives the cyborg the ability to repair themselves over time.
/obj/item/borg/upgrade/selfrepair/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/upgrade/selfrepair/U = locate() in R
		if(U)
			to_chat(user, span_warning("This unit is already equipped with a self-repair module."))
			return FALSE

		icon_state = "selfrepair_off"
		toggle_action = new /datum/action/item_action/toggle(src)
		toggle_action.Grant(R)

/obj/item/borg/upgrade/selfrepair/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		toggle_action.Remove(R)
		QDEL_NULL(toggle_action)
		deactivate_sr()

/obj/item/borg/upgrade/selfrepair/ui_action_click()
	if(on)
		to_chat(toggle_action.owner, span_notice("You activate the self-repair module."))
		activate_sr()
	else
		to_chat(toggle_action.owner, span_notice("You deactivate the self-repair module."))
		deactivate_sr()

/obj/item/borg/upgrade/selfrepair/update_icon_state()
	if(toggle_action)
		icon_state = "selfrepair_[on ? "on" : "off"]"
	else
		icon_state = "cyborg_upgrade5"
	return ..()

/obj/item/borg/upgrade/selfrepair/proc/activate_sr()
	START_PROCESSING(SSobj, src)
	on = TRUE
	update_appearance(UPDATE_ICON)

/obj/item/borg/upgrade/selfrepair/proc/deactivate_sr()
	STOP_PROCESSING(SSobj, src)
	on = FALSE
	update_appearance(UPDATE_ICON)

/obj/item/borg/upgrade/selfrepair/process()
	if(!COOLDOWN_FINISHED(src, next_repair))
		return
	var/mob/living/silicon/robot/cyborg = toggle_action.owner
	if(!istype(cyborg) || cyborg.stat == DEAD || !on)
		deactivate_sr()
		return
	if(!cyborg.cell)
		to_chat(cyborg, span_warning("Self-repair module deactivated. Please, insert the power cell."))
		deactivate_sr()
		return
	if(cyborg.cell.charge < powercost * 2)
		to_chat(cyborg, span_warning("Self-repair module deactivated. Please recharge."))
		deactivate_sr()
		return

	COOLDOWN_START(src, next_repair, repair_cooldown)
	var/cost = powercost
	if(cyborg.health < cyborg.maxHealth)
		var/to_repair = repair_amount
		if(cyborg.health < 0) // Critical damage.
			to_repair *= 2.5
			cost *= 3

		cyborg.adjustBruteLoss(to_repair)
		cyborg.adjustFireLoss(to_repair)
		cyborg.updatehealth()
		cyborg.cell.use(powercost)
	else
		cost *= 0.5
		cyborg.cell.use(cost) // Idling.

	if(!COOLDOWN_FINISHED(src, next_message))
		return
	
	COOLDOWN_START(src, next_message, message_cooldown)
	var/msgmode = "standby"
	if(cyborg.health < 0)
		msgmode = "critical"
	else if(cyborg.health < cyborg.maxHealth)
		msgmode = "normal"
	to_chat(cyborg, span_notice("Self-repair is active in [span_boldnotice("[msgmode]")] mode."))

/obj/item/borg/upgrade/hypospray
	name = "medical cyborg hypospray advanced synthesiser"
	desc = "An upgrade to the Medical module cyborg's hypospray, allowing it \
		to produce more advanced and complex medical reagents."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/medical
	module_flags = BORG_MODULE_MEDICAL

/// Upgrades all of the cyborg's medical hyposprays to give additional chemicals if they can.
/obj/item/borg/upgrade/hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/has_hypo = FALSE
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.module.modules)
			has_hypo = TRUE
			if(H.upgraded)
				to_chat(user, span_notice("This cyborg's medical hypospray is already upgraded!"))
				return FALSE
			H.upgrade_hypo()

		if(!has_hypo)
			to_chat(user, span_notice("This cyborg does not have a medical hypospray!"))
			return FALSE

		// For the hacked medical hypospray if they haven't got it yet:
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.module.emag_modules)
			if(!H.upgraded)
				H.upgrade_hypo()

/obj/item/borg/upgrade/hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.module.modules)
			if(H.upgraded)
				H.remove_hypo_upgrade()

		// For the hacked medical hypospray if they haven't got it yet:
		for(var/obj/item/reagent_containers/borghypo/medical/hackedH in R.module.emag_modules)
			if(hackedH.upgraded)
				hackedH.remove_hypo_upgrade()

/obj/item/borg/upgrade/hypospray/expanded
	name = "medical cyborg expanded hypospray"
	desc = "An upgrade to the Medical module's hypospray, allowing it \
		to treat a wider range of conditions and problems."

/obj/item/borg/upgrade/piercing_hypospray
	name = "cyborg piercing hypospray"
	desc = "An upgrade to a cyborg's hypospray, allowing it to \
		pierce armor and thick material."
	icon_state = "cyborg_upgrade3"

/// Gives all of the cyborg's hyposprays the ability to pierce armor and thick materials.
/obj/item/borg/upgrade/piercing_hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/has_hypo = FALSE
		for(var/obj/item/reagent_containers/borghypo/H in R.module.modules)
			if(H.bypass_protection)
				to_chat(user, span_warning("This cyborg's hypospray is already equipped with a piercing hypospray module."))
				return FALSE
			H.bypass_protection = TRUE
			has_hypo = TRUE

		if(!has_hypo)
			to_chat(user, span_notice("This cyborg does not have a hypospray!"))
			return FALSE

		for(var/obj/item/reagent_containers/borghypo/H in R.module.emag_modules)
			if(!H.bypass_protection)
				H.bypass_protection = TRUE

/obj/item/borg/upgrade/piercing_hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/reagent_containers/borghypo/H in R.module.modules)
			H.bypass_protection = initial(H.bypass_protection)

		for(var/obj/item/reagent_containers/borghypo/H in R.module.emag_modules)
			H.bypass_protection = initial(H.bypass_protection)

/obj/item/borg/upgrade/defib
	name = "medical cyborg defibrillator"
	desc = "An upgrade to the Medical module, installing a built-in \
		defibrillator, for on the scene revival."
	icon_state = "cyborg_upgrade3"
	require_module = 1
	module_type = /obj/item/robot_module/medical
	module_flags = BORG_MODULE_MEDICAL

/// Gives the cyborg a defibrillator to use.
/obj/item/borg/upgrade/defib/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/shockpaddles/cyborg/S = locate() in R.module.modules
		if(S)
			to_chat(user, span_warning("This unit is already equipped with a defibrillator module."))
			return FALSE

		S = new(R.module)
		R.module.basic_modules += S
		R.module.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/defib/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/shockpaddles/cyborg/S in R.module.modules)
			R.module.remove_module(S, TRUE)

/obj/item/borg/upgrade/adv_analyzer
	name = "medical cyborg advanced health analyzer"
	desc = "An upgrade to the Medical module, loading a more advanced \
		health analyzer into the holder's module, \
		replacing the old one."
	icon_state = "cyborg_upgrade5"
	require_module = TRUE
	module_type = /obj/item/robot_module/medical
	module_flags = BORG_MODULE_MEDICAL

/// Replaces the cyborg's health analyzer with an advanced health analyzer.
/obj/item/borg/upgrade/adv_analyzer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes old analyzer.
		for(var/obj/item/healthanalyzer/healthanalyzer in R.module.modules)
			R.module.remove_module(healthanalyzer, TRUE)

		var/obj/item/healthanalyzer/advanced/advancedanal = locate() in R.module.modules
		if(advancedanal)
			to_chat(user, span_warning("This unit is already equipped with an advanced health analyzer."))
			return FALSE

		/// Puts in new advanced analyzer.
		advancedanal = new(R.module)
		R.module.basic_modules += advancedanal
		R.module.add_module(advancedanal, FALSE, TRUE)

/obj/item/borg/upgrade/adv_analyzer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes the new advanced analyzer.
		for(var/obj/item/healthanalyzer/advanced/advancedanal in R.module.modules)
			R.module.remove_module(advancedanal, TRUE)

		/// Puts in old analyzer.
		var/obj/item/healthanalyzer/healthanalyzer = locate() in R.module.modules
		healthanalyzer = new(R.module)
		R.module.basic_modules += healthanalyzer
		R.module.add_module(healthanalyzer, FALSE, TRUE)

/obj/item/borg/upgrade/surgerykit
	name = "medical cyborg advanced surgical kit"
	desc = "An upgrade to the Medical module, loading a more advanced \
		array of surgical tools into the holder's module, \
		replacing the old ones."
	icon_state = "cyborg_upgrade5"
	require_module = TRUE
	module_type = /obj/item/robot_module/medical
	module_flags = BORG_MODULE_MEDICAL

// Replaces the cyborg's surgery tools with the advanced verison of those tools.
/obj/item/borg/upgrade/surgerykit/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes old surgery tools.
		for(var/obj/item/retractor/RT in R.module.modules)
			R.module.remove_module(RT, TRUE)

		for(var/obj/item/hemostat/HS in R.module.modules)
			R.module.remove_module(HS, TRUE)

		for(var/obj/item/cautery/CT in R.module.modules)
			R.module.remove_module(CT, TRUE)

		for(var/obj/item/surgicaldrill/SD in R.module.modules)
			R.module.remove_module(SD, TRUE)

		for(var/obj/item/scalpel/SL in R.module.modules)
			R.module.remove_module(SL, TRUE)

		for(var/obj/item/circular_saw/CS in R.module.modules)
			R.module.remove_module(CS, TRUE)

		var/obj/item/scalpel/advanced/LS = locate() in R.module.modules
		var/obj/item/retractor/advanced/MP = locate() in R.module.modules
		var/obj/item/cautery/advanced/ST = locate() in R.module.modules
		if(LS || MP || ST)
			to_chat(user, span_warning("This unit is already equipped with an advanced surgical kit."))
			return FALSE

		/// Puts in new surgery tools.
		LS = new(R.module)
		R.module.basic_modules += LS
		R.module.add_module(LS, FALSE, TRUE)

		MP = new(R.module)
		R.module.basic_modules += MP
		R.module.add_module(MP, FALSE, TRUE)

		ST = new(R.module)
		R.module.basic_modules += ST
		R.module.add_module(ST, FALSE, TRUE)

/obj/item/borg/upgrade/surgerykit/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes new surgery tools.
		for(var/obj/item/scalpel/advanced/SE in R.module.modules)
			R.module.remove_module(SE, TRUE)

		for(var/obj/item/retractor/advanced/RE in R.module.modules)
			R.module.remove_module(RE, TRUE)

		for(var/obj/item/cautery/advanced/CE in R.module.modules)
			R.module.remove_module(CE, TRUE)

		/// Puts in old surgery tools.
		var/obj/item/retractor/RT = locate() in R.module.modules
		RT = new(R.module)
		R.module.basic_modules += RT
		R.module.add_module(RT, FALSE, TRUE)

		var/obj/item/hemostat/HS = locate() in R.module.modules
		HS = new(R.module)
		R.module.basic_modules += HS
		R.module.add_module(HS, FALSE, TRUE)

		var/obj/item/cautery/CT = locate() in R.module.modules
		CT = new(R.module)
		R.module.basic_modules += CT
		R.module.add_module(CT, FALSE, TRUE)

		var/obj/item/surgicaldrill/SD = locate() in R.module.modules
		SD = new(R.module)
		R.module.basic_modules += SD
		R.module.add_module(SD, FALSE, TRUE)

		var/obj/item/scalpel/SL = locate() in R.module.modules
		SL = new(R.module)
		R.module.basic_modules += SL
		R.module.add_module(SL, FALSE, TRUE)

		var/obj/item/circular_saw/CS = locate() in R.module.modules
		CS = new(R.module)
		R.module.basic_modules += CS
		R.module.add_module(CS, FALSE, TRUE)

/obj/item/borg/upgrade/ai
	name = "B.O.R.I.S. module"
	desc = "Bluespace Optimized Remote Intelligence Synchronization. An uplink device which takes the place of an MMI in cyborg endoskeletons, creating a robotic shell controlled by an AI."
	icon_state = "boris"

// Creates a shell for an AI to connect to.
/obj/item/borg/upgrade/ai/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.shell)
			to_chat(user, span_warning("This unit is already an AI shell!"))
			return FALSE
		if(R.key) // You cannot replace a player unless the key is completely removed.
			to_chat(user, span_warning("Intelligence patterns detected in this [R.braintype]. Aborting."))
			return FALSE

		R.make_shell(src)

/obj/item/borg/upgrade/ai/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		if(R.shell)
			R.undeploy()
			R.notify_ai(AI_SHELL)

/obj/item/borg/upgrade/expand
	name = "borg expander"
	desc = "A cyborg resizer, it makes a cyborg huge."
	icon_state = "cyborg_upgrade3"

/// Enlarges the cyborg by 2x of their current size.
/obj/item/borg/upgrade/expand/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.expansion_count >= EXPANDER_MAXIMUM_STACK)
			to_chat(usr, span_notice("This unit has already expanded as much as it can!"))
			return FALSE

		R.notransform = TRUE
		var/prev_lockcharge = R.lockcharge
		R.SetLockdown(1)
		R.anchored = TRUE
		R.expansion_count++
		var/datum/effect_system/fluid_spread/smoke/smoke = new
		smoke.set_up(1, location = R.loc)
		smoke.start()
		sleep(0.2 SECONDS)
		for(var/i in 1 to 4)
			playsound(R, pick('sound/items/drill_use.ogg', 'sound/items/jaws_cut.ogg', 'sound/items/jaws_pry.ogg', 'sound/items/welder.ogg', 'sound/items/ratchet.ogg'), 80, 1, -1)
			sleep(1.2 SECONDS)
		if(!prev_lockcharge)
			R.SetLockdown(0)
		R.anchored = FALSE
		R.notransform = FALSE
		R.resize = 2
		R.update_transform()

/obj/item/borg/upgrade/expand/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		while(R.expansion_count)
			R.resize = 0.5
			R.expansion_count--
			R.update_transform()

/obj/item/borg/upgrade/rped
	name = "engineering cyborg RPED"
	desc = "A rapid part exchange device for the engineering cyborg."
	icon = 'icons/obj/storage.dmi'
	icon_state = "borgrped"
	require_module = TRUE
	module_type = /obj/item/robot_module/engineering
	module_flags = BORG_MODULE_ENGINEERING

/// Gives the cyborg a rapid part exchange device (RPED).
/obj/item/borg/upgrade/rped/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/storage/part_replacer/cyborg/RPED = locate() in R.module.modules
		if(RPED)
			to_chat(user, span_warning("This unit is already equipped with a RPED module."))
			return FALSE

		RPED = new(R.module)
		R.module.basic_modules += RPED
		R.module.add_module(RPED, FALSE, TRUE)

/obj/item/borg/upgrade/rped/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/storage/part_replacer/cyborg/RPED in R.module.modules)
			R.module.remove_module(RPED, TRUE)

/obj/item/borg/upgrade/plasmacutter
	name = "mining cyborg plasma cutter"
	desc = "A plasma cutter module for the mining cyborg."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "adv_plasmacutter"
	require_module = TRUE
	module_type = /obj/item/robot_module/miner
	module_flags = BORG_MODULE_MINER

/// Gives the cyborg an advanced plasma cutter.
/obj/item/borg/upgrade/plasmacutter/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/plasmacutter/adv/cyborg/PC = locate() in R.module.modules
		if(PC)
			to_chat(user, span_warning("This unit is already equipped with a plasma cutter module."))
			return FALSE

		PC = new(R.module)
		R.module.basic_modules += PC
		R.module.add_module(PC, FALSE, TRUE)

/obj/item/borg/upgrade/plasmacutter/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/gun/energy/plasmacutter/adv/cyborg/PC in R.module.modules)
			R.module.remove_module(PC, TRUE)

/obj/item/borg/upgrade/transform
	name = "borg module picker (Standard)"
	desc = "Allows you to turn a cyborg into a standard cyborg."
	icon_state = "cyborg_upgrade3"
	var/obj/item/robot_module/new_module = /obj/item/robot_module/standard

/// Forces the cyborg into the designated module.
/obj/item/borg/upgrade/transform/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.module.transform_to(new_module)

/obj/item/borg/upgrade/transform/clown
	name = "borg module picker (Clown)"
	desc = "Allows you to turn a cyborg into a clown, honk."
	icon_state = "cyborg_upgrade3"
	new_module = /obj/item/robot_module/clown

/obj/item/borg/upgrade/transform/security
	name = "borg module picker (Security)"
	desc = "Allows you to turn a cyborg into a hunter, HALT!"
	icon_state = "cyborg_upgrade3"
	new_module = /obj/item/robot_module/security

/// Forces the cyborg into becoming a security module unless it is disabled or jobbanned from security.
/obj/item/borg/upgrade/transform/security/action(mob/living/silicon/robot/R, user = usr)
	if(CONFIG_GET(flag/disable_secborg))
		to_chat(user, span_warning("Nanotrasen policy disallows the use of weapons of mass destruction."))
		return FALSE
	if(is_banned_from(R.ckey, "Security Officer"))
		to_chat(user, span_warning("Nanotrasen has disallowed this unit from becoming this type of module."))
		return FALSE
	return ..()

/obj/item/borg/upgrade/broomer
	name = "experimental push broom"
	desc = "An experimental push broom used for efficiently pushing refuse."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE
	module_type = /obj/item/robot_module/janitor
	module_flags = BORG_MODULE_JANITOR

/// Gives the cyborg a push broom.
/obj/item/borg/upgrade/broomer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/broom/cyborg/BR = locate() in R.module.modules
		if(BR)
			to_chat(user, span_warning("This janiborg is already equipped with an experimental broom!"))
			return FALSE
		BR = new(R.module)
		R.module.basic_modules += BR
		R.module.add_module(BR, FALSE, TRUE)

/obj/item/borg/upgrade/broomer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/broom/cyborg/BR = locate() in R.module.modules
		if (BR)
			R.module.remove_module(BR, TRUE)

/obj/item/borg/upgrade/snack_dispenser
	name = "Cyborg Upgrade (Snack Dispenser)"
	desc = "Gives the ability to dispense speciality snacks to medical, peacekeeper, service, and clown cyborgs."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE

/obj/item/borg/upgrade/snack_dispenser/action(mob/living/silicon/robot/R, user)
	. = ..()
	if(.)
		// TODO: Move this to 'module_type' once it is changed to be a list.
		if(!istype(R.module, /obj/item/robot_module/medical) && !istype(R.module, /obj/item/robot_module/peacekeeper) && !istype(R.module, /obj/item/robot_module/service) && !istype(R.module, /obj/item/robot_module/clown))
			to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
			to_chat(user, "There's no mounting point for the module!")
			return FALSE

		var/obj/item/borg_snack_dispenser/snack_dispenser = new(R.module)
		R.module.basic_modules += snack_dispenser
		R.module.add_module(snack_dispenser, FALSE, TRUE)

		for(var/obj/item/borg_snack_dispenser/peacekeeper/cookiesynth in R.module.modules)
			R.module.remove_module(cookiesynth, TRUE)

		for(var/obj/item/borg_snack_dispenser/medical/lollipopshooter in R.module.modules)
			R.module.remove_module(lollipopshooter, TRUE)

/obj/item/borg/upgrade/snack_dispenser/deactivate(mob/living/silicon/robot/R, user)
	. = ..()
	if(.)
		for(var/obj/item/borg_snack_dispenser/snack_dispenser in R.module.modules)
			R.module.remove_module(snack_dispenser, TRUE)

		if(istype(R.module, /obj/item/robot_module/peacekeeper))
			var/obj/item/borg_snack_dispenser/peacekeeper/cookiesynth = new(R.module)
			R.module.basic_modules += cookiesynth
			R.module.add_module(cookiesynth, FALSE, TRUE)
		else // Medical, Service, or Clown.
			var/obj/item/borg_snack_dispenser/medical/lollipopshooter = new(R.module)
			R.module.basic_modules += lollipopshooter
			R.module.add_module(lollipopshooter, FALSE, TRUE)
