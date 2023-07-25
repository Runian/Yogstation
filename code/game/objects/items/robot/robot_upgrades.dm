// robot_upgrades.dm
// Contains various borg upgrades.
#define EXPANDER_MAXIMUM_STACK 2


/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	var/locked = FALSE
	var/installed = 0
	var/require_model = 0
	var/model_type = null
	// if true, is not stored in the robot to be ejected
	// if model is reset
	var/one_use = FALSE
	///	Bitflags listing model compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/model_flags = NONE

/obj/item/borg/upgrade/proc/action(mob/living/silicon/robot/R, user = usr)
	if(R.stat == DEAD)
		to_chat(user, span_notice("[src] will not function on a deceased cyborg."))
		return FALSE
	if(model_type && !istype(R.model, model_type))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(user, "There's no mounting point for the module!")
		return FALSE
	return TRUE

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

/obj/item/borg/upgrade/rename/attack_self(mob/user)
	heldname = stripped_input(user, "Enter new robot name", "Cyborg Reclassification", heldname, MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		log_game("[key_name(user)] renamed [key_name(R)] to [heldname]")
		var/oldname = R.real_name
		R.custom_name = heldname
		R.updatename()
		if(oldname != R.real_name)
			R.notify_ai(RENAME, oldname, R.real_name)

/obj/item/borg/upgrade/restart
	name = "cyborg emergency reboot module"
	desc = "Used to force a reboot of a disabled-but-repaired cyborg, bringing it back online."
	icon_state = "cyborg_upgrade1"
	one_use = TRUE

/obj/item/borg/upgrade/restart/action(mob/living/silicon/robot/R, user = usr)
	if(R.health < 0)
		to_chat(user, span_warning("You have to repair the cyborg before using this module!"))
		return FALSE

	if(R.mind)
		R.mind.grab_ghost()
		playsound(loc, 'sound/voice/liveagain.ogg', 75, 1)

	R.revive()
	R.logevent("WARN -- System recovered from unexpected shutdown.")
	R.logevent("System brought online.")

/obj/item/borg/upgrade/panel_access_remover
	name = "cyborg firmware hack"
	desc = "Used to override the default firmware of a cyborg and disable panel access restrictions."
	icon_state = "cyborg_upgrade2"
	one_use = TRUE

/obj/item/borg/upgrade/panel_access_remover/action(mob/living/silicon/robot/R, user = usr)
	R.req_access = list()
	return TRUE //Makes sure we delete the upgrade since it's one_use

/obj/item/borg/upgrade/panel_access_remover/freeminer
	name = "free miner cyborg firmware hack"
	desc = "Used to override the default firmware of a cyborg with the freeminer version."
	icon_state = "cyborg_upgrade2"

/obj/item/borg/upgrade/panel_access_remover/freeminer/action(mob/living/silicon/robot/R, user = usr)
	R.req_access = list(ACCESS_FREEMINER_ENGINEER)
	new /obj/item/borg/upgrade/panel_access_remover/freeminer(R.drop_location())
	//This deletes the upgrade which is why we create a new one. This prevents the message "Upgrade Error" without a adding a once-used variable to every board
	return TRUE

/obj/item/borg/upgrade/vtec
	name = "cyborg VTEC module"
	desc = "Used to kick in a cyborg's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	require_model = 1
	var/vtecequip = 0

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
//	desc = "Used to cool a mounted disabler, increasing the potential current in it and thus its recharge rate."
	desc = "It used to give unspeakable power to security modules. Now it rests; broken, abandoned."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/security
	model_flags = BORG_MODEL_SECURITY

/obj/item/borg/upgrade/disablercooler/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.model.modules
		if(!T)
			to_chat(user, span_notice("There's no disabler in this unit!"))
			return FALSE
		if(T.charge_delay <= 2)
			to_chat(R, span_notice("A cooling unit is already installed!"))
			to_chat(user, span_notice("There's no room for another cooling unit!"))
			return FALSE

		T.charge_delay = max(2 , T.charge_delay - 4)

/obj/item/borg/upgrade/disablercooler/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		var/obj/item/gun/energy/disabler/cyborg/T = locate() in R.model.modules
		if(!T)
			return FALSE
		T.charge_delay = initial(T.charge_delay)

/obj/item/borg/upgrade/thrusters
	name = "ion thruster upgrade"
	desc = "An energy-operated thruster system for cyborgs."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/thrusters/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.ionpulse)
			to_chat(user, span_notice("This unit already has ion thrusters installed!"))
			return FALSE

		R.ionpulse = TRUE

/obj/item/borg/upgrade/thrusters/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.ionpulse = FALSE

/obj/item/borg/upgrade/language
	name = "translation matrix upgrade"
	desc = "Increases the translation matrix to include all xeno languages"
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

/obj/item/borg/upgrade/language/expanded
	name = "advanced translation matrix upgrade"
	desc = "Increases the translation matrix to include an even wider variety in langauges"
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

/obj/item/borg/upgrade/language/omni
	name = "universal translation matrix upgrade"
	desc = "Allow the translation matrix to handle any language"
	languages = list()

/obj/item/borg/upgrade/language/omni/Initialize(mapload)
	. = ..()
	languages = subtypesof(/datum/language)

/obj/item/borg/upgrade/language/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/datum/language/lang as anything in languages)
			R.grant_language(lang, TRUE, TRUE, LANGUAGE_SOFTWARE)

/obj/item/borg/upgrade/language/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.remove_all_languages(LANGUAGE_SOFTWARE)

/obj/item/borg/upgrade/ddrill
	name = "mining cyborg diamond drill"
	desc = "A diamond drill replacement for the mining module's standard drill."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/miner
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/ddrill/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/pickaxe/drill/cyborg/D in R.model)
			R.model.remove_module(D, TRUE)
		for(var/obj/item/shovel/S in R.model)
			R.model.remove_module(S, TRUE)

		var/obj/item/pickaxe/drill/cyborg/diamond/DD = new /obj/item/pickaxe/drill/cyborg/diamond(R.model)
		R.model.basic_modules += DD
		R.model.add_module(DD, FALSE, TRUE)

/obj/item/borg/upgrade/ddrill/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/pickaxe/drill/cyborg/diamond/DD in R.model)
			R.model.remove_module(DD, TRUE)

		var/obj/item/pickaxe/drill/cyborg/D = new (R.model)
		R.model.basic_modules += D
		R.model.add_module(D, FALSE, TRUE)
		var/obj/item/shovel/S = new (R.model)
		R.model.basic_modules += S
		R.model.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/soh
	name = "mining cyborg satchel of holding"
	desc = "A satchel of holding replacement for mining cyborg's ore satchel module."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/miner
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/soh/action(mob/living/silicon/robot/R , user = usr) //yogs single line
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/ore/cyborg/S in R.model)
			R.model.remove_module(S, TRUE)

		var/obj/item/storage/bag/ore/holding/H = locate() in R.model.modules  //yogs start
		if(H)
			to_chat(user, span_warning("This unit is already equipped with a satchel of holding."))
			return FALSE

		H = new /obj/item/storage/bag/ore/holding(R.model)  //yogs end
		R.model.basic_modules += H
		R.model.add_module(H, FALSE, TRUE)

/obj/item/borg/upgrade/soh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/storage/bag/ore/holding/H in R.model)
			R.model.remove_module(H, TRUE)

		var/obj/item/storage/bag/ore/cyborg/S = new (R.model)
		R.model.basic_modules += S
		R.model.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/tboh
	name = "janitor cyborg trash bag of holding"
	desc = "A trash bag of holding replacement for the janiborg's standard trash bag."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/janitor
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/tboh/action(mob/living/silicon/robot/R, user = usr)//yogs single line
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/cyborg/TB in R.model.modules)
			R.model.remove_module(TB, TRUE)

		var/obj/item/storage/bag/trash/bluespace/cyborg/B = locate() in R.model.modules //yogs start
		if(B)
			to_chat(user, span_warning("This unit is already equipped with a trash bag of holding."))
			return FALSE

		B = new /obj/item/storage/bag/trash/bluespace/cyborg(R.model) //yogs end
		R.model.basic_modules += B
		R.model.add_module(B, FALSE, TRUE)

/obj/item/borg/upgrade/tboh/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/storage/bag/trash/bluespace/cyborg/B in R.model.modules)
			R.model.remove_module(B, TRUE)

		var/obj/item/storage/bag/trash/cyborg/TB = new (R.model)
		R.model.basic_modules += TB
		R.model.add_module(TB, FALSE, TRUE)

/obj/item/borg/upgrade/amop
	name = "janitor cyborg advanced mop"
	desc = "An advanced mop replacement for the janiborg's standard mop."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/janitor
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/amop/action(mob/living/silicon/robot/R, user = usr)//yogs single line
	. = ..()
	if(.)
		for(var/obj/item/mop/cyborg/M in R.model.modules)
			R.model.remove_module(M, TRUE)

		var/obj/item/mop/advanced/cyborg/A = locate() in R.model.modules  //yogs start
		if(A)
			to_chat(user, span_warning("This unit is already equipped with a advanced mop module."))
			return FALSE

		A = new /obj/item/mop/advanced/cyborg(R.model)  //yogs end
		R.model.basic_modules += A
		R.model.add_module(A, FALSE, TRUE)

/obj/item/borg/upgrade/amop/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/mop/advanced/cyborg/A in R.model.modules)
			R.model.remove_module(A, TRUE)

		var/obj/item/mop/cyborg/M = new (R.model)
		R.model.basic_modules += M
		R.model.add_module(M, FALSE, TRUE)

/obj/item/borg/upgrade/syndicate
	name = "illegal equipment module"
	desc = "Unlocks the hidden, deadlier functions of a cyborg."
	icon_state = "cyborg_upgrade3"
	require_model = 1

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
	require_model = 1
	model_type = /obj/item/robot_model/miner
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/lavaproof/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		R.weather_immunities += WEATHER_LAVA

/obj/item/borg/upgrade/lavaproof/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		R.weather_immunities -= WEATHER_LAVA

/obj/item/borg/upgrade/selfrepair
	name = "self-repair module"
	desc = "This module will repair the cyborg over time."
	icon_state = "cyborg_upgrade5"
	require_model = 1
	var/repair_amount = -1
	/// world.time of next repair
	var/next_repair = 0
	/// Minimum time between repairs in seconds
	var/repair_cooldown = 4
	var/msg_cooldown = 0
	var/on = FALSE
	var/powercost = 10
	var/mob/living/silicon/robot/cyborg
	var/datum/action/toggle_action

/obj/item/borg/upgrade/selfrepair/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/borg/upgrade/selfrepair/U = locate() in R
		if(U)
			to_chat(user, span_warning("This unit is already equipped with a self-repair module."))
			return FALSE

		cyborg = R
		icon_state = "selfrepair_off"
		toggle_action = new /datum/action/item_action/toggle(src)
		toggle_action.Grant(R)

/obj/item/borg/upgrade/selfrepair/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		toggle_action.Remove(cyborg)
		QDEL_NULL(toggle_action)
		cyborg = null
		deactivate_sr()

/obj/item/borg/upgrade/selfrepair/dropped()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(check_dropped)), 1)

/obj/item/borg/upgrade/selfrepair/proc/check_dropped()
	if(loc != cyborg)
		toggle_action.Remove(cyborg)
		QDEL_NULL(toggle_action)
		cyborg = null
		deactivate_sr()

/obj/item/borg/upgrade/selfrepair/ui_action_click()
	on = !on
	if(on)
		to_chat(cyborg, span_notice("You activate the self-repair module."))
		START_PROCESSING(SSobj, src)
	else
		to_chat(cyborg, span_notice("You deactivate the self-repair module."))
		STOP_PROCESSING(SSobj, src)
	update_appearance(UPDATE_ICON)

/obj/item/borg/upgrade/selfrepair/update_icon_state()
	. = ..()
	if(cyborg)
		icon_state = "selfrepair_[on ? "on" : "off"]"
		for(var/datum/action/A as anything in actions)
			A.build_all_button_icons()
	else
		icon_state = "cyborg_upgrade5"

/obj/item/borg/upgrade/selfrepair/proc/deactivate_sr()
	STOP_PROCESSING(SSobj, src)
	on = FALSE
	update_appearance(UPDATE_ICON)

/obj/item/borg/upgrade/selfrepair/process()
	if(world.time < next_repair)
		return

	if(cyborg && (cyborg.stat != DEAD) && on)
		if(!cyborg.cell)
			to_chat(cyborg, span_warning("Self-repair module deactivated. Please, insert the power cell."))
			deactivate_sr()
			return

		if(cyborg.cell.charge < powercost * 2)
			to_chat(cyborg, span_warning("Self-repair module deactivated. Please recharge."))
			deactivate_sr()
			return

		if(cyborg.health < cyborg.maxHealth)
			if(cyborg.health < 0)
				repair_amount = -2.5
				powercost = 30
			else
				repair_amount = -1
				powercost = 10
			cyborg.adjustBruteLoss(repair_amount)
			cyborg.adjustFireLoss(repair_amount)
			cyborg.updatehealth()
			cyborg.cell.use(powercost)
		else
			cyborg.cell.use(5)
		next_repair = world.time + repair_cooldown * 10 // Multiply by 10 since world.time is in deciseconds

		if((world.time - 2000) > msg_cooldown )
			var/msgmode = "standby"
			if(cyborg.health < 0)
				msgmode = "critical"
			else if(cyborg.health < cyborg.maxHealth)
				msgmode = "normal"
			to_chat(cyborg, span_notice("Self-repair is active in [span_boldnotice("[msgmode]")] mode."))
			msg_cooldown = world.time
	else
		deactivate_sr()

/obj/item/borg/upgrade/hypospray
	name = "medical cyborg hypospray advanced synthesiser"
	desc = "An upgrade to the Medical module cyborg's hypospray, allowing it \
		to produce more advanced and complex medical reagents."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/medical
	var/list/additional_reagents = list()
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.model.modules)
			H.upgrade_hypo()

/obj/item/borg/upgrade/hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/reagent_containers/borghypo/medical/H in R.model.modules)
			H.remove_hypo_upgrade()

/obj/item/borg/upgrade/hypospray/expanded
	name = "medical cyborg expanded hypospray"
	desc = "An upgrade to the Medical module's hypospray, allowing it \
		to treat a wider range of conditions and problems."

/obj/item/borg/upgrade/piercing_hypospray
	name = "cyborg piercing hypospray"
	desc = "An upgrade to a cyborg's hypospray, allowing it to \
		pierce armor and thick material."
	icon_state = "cyborg_upgrade3"

/obj/item/borg/upgrade/piercing_hypospray/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/found_hypo = FALSE
		for(var/obj/item/reagent_containers/borghypo/H in R.model.modules)
			if(H.bypass_protection == TRUE) //yogs start
				to_chat(user, span_warning("This unit is already equipped with a piercing hypospray module."))
				return FALSE  //yogs end

			H.bypass_protection = TRUE
			found_hypo = TRUE

		if(!found_hypo)
			return FALSE

/obj/item/borg/upgrade/piercing_hypospray/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/reagent_containers/borghypo/H in R.model.modules)
			H.bypass_protection = initial(H.bypass_protection)

/obj/item/borg/upgrade/defib
	name = "medical cyborg defibrillator"
	desc = "An upgrade to the Medical module, installing a built-in \
		defibrillator, for on the scene revival."
	icon_state = "cyborg_upgrade3"
	require_model = 1
	model_type = /obj/item/robot_model/medical
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/defib/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/shockpaddles/cyborg/S = locate() in R.model.modules //yogs start
		if(S)
			to_chat(user, span_warning("This unit is already equipped with a defibrillator module."))
			return FALSE

		S = new(R.model) //yogs end
		R.model.basic_modules += S
		R.model.add_module(S, FALSE, TRUE)

/obj/item/borg/upgrade/defib/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/shockpaddles/cyborg/S in R.model.modules)
			R.model.remove_module(S, TRUE)

/obj/item/borg/upgrade/adv_analyzer
	name = "medical cyborg advanced health analyzer"
	desc = "An upgrade to the Medical module, loading a more advanced \
		health analyzer into the holder's module, \
		replacing the old one."
	icon_state = "cyborg_upgrade5"
	require_model = TRUE
	model_type = /obj/item/robot_model/medical
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/adv_analyzer/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes old analyzer
		for(var/obj/item/healthanalyzer/healthanalyzer in R.model.modules)
			R.model.remove_module(healthanalyzer, TRUE)

		var/obj/item/healthanalyzer/advanced/advancedanal = locate() in R.model.modules

		if(advancedanal)
			to_chat(user, span_warning("This unit is already equipped with an advanced health analyzer."))
			return FALSE

		/// Puts in new advanced analyzer
		advancedanal = new(R.model)
		R.model.basic_modules += advancedanal
		R.model.add_module(advancedanal, FALSE, TRUE)

/obj/item/borg/upgrade/adv_analyzer/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes new advanced analyzer
		for(var/obj/item/healthanalyzer/advanced/advancedanal in R.model.modules)
			R.model.remove_module(advancedanal, TRUE)

		/// Puts in old analyzer
		var/obj/item/healthanalyzer/healthanalyzer = locate() in R.model.modules
		healthanalyzer = new(R.model)
		R.model.basic_modules += healthanalyzer
		R.model.add_module(healthanalyzer, FALSE, TRUE)

/obj/item/borg/upgrade/surgerykit
	name = "medical cyborg advanced surgical kit"
	desc = "An upgrade to the Medical module, loading a more advanced \
		array of surgical tools into the holder's module, \
		replacing the old ones."
	icon_state = "cyborg_upgrade5"
	require_model = TRUE
	model_type = /obj/item/robot_model/medical
	model_flags = BORG_MODEL_MEDICAL

/obj/item/borg/upgrade/surgerykit/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes old surgery tools
		for(var/obj/item/retractor/RT in R.model.modules) // the SC stands for shitcode
			R.model.remove_module(RT, TRUE)

		for(var/obj/item/hemostat/HS in R.model.modules)
			R.model.remove_module(HS, TRUE)

		for(var/obj/item/cautery/CT in R.model.modules)
			R.model.remove_module(CT, TRUE)

		for(var/obj/item/surgicaldrill/SD in R.model.modules)
			R.model.remove_module(SD, TRUE)

		for(var/obj/item/scalpel/SL in R.model.modules)
			R.model.remove_module(SL, TRUE)

		for(var/obj/item/circular_saw/CS in R.model.modules)
			R.model.remove_module(CS, TRUE)

		var/obj/item/scalpel/advanced/LS = locate() in R.model.modules
		var/obj/item/retractor/advanced/MP = locate() in R.model.modules
		var/obj/item/cautery/advanced/ST = locate() in R.model.modules
		if(LS || MP || ST)
			to_chat(user, span_warning("This unit is already equipped with an advanced surgical kit."))
			return FALSE

		/// Puts in new surgery tools
		LS = new(R.model)
		R.model.basic_modules += LS
		R.model.add_module(LS, FALSE, TRUE)

		MP = new(R.model)
		R.model.basic_modules += MP
		R.model.add_module(MP, FALSE, TRUE)

		ST = new(R.model)
		R.model.basic_modules += ST
		R.model.add_module(ST, FALSE, TRUE)

/obj/item/borg/upgrade/surgerykit/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		/// Removes new surgery tools
		for(var/obj/item/scalpel/advanced/SE in R.model.modules)
			R.model.remove_module(SE, TRUE)

		for(var/obj/item/retractor/advanced/RE in R.model.modules)
			R.model.remove_module(RE, TRUE)

		for(var/obj/item/cautery/advanced/CE in R.model.modules)
			R.model.remove_module(CE, TRUE)

		/// Puts in old surgery tools
		var/obj/item/retractor/RT = locate() in R.model.modules
		RT = new(R.model)
		R.model.basic_modules += RT
		R.model.add_module(RT, FALSE, TRUE)

		var/obj/item/hemostat/HS = locate() in R.model.modules
		HS = new(R.model)
		R.model.basic_modules += HS
		R.model.add_module(HS, FALSE, TRUE)

		var/obj/item/cautery/CT = locate() in R.model.modules
		CT = new(R.model)
		R.model.basic_modules += CT
		R.model.add_module(CT, FALSE, TRUE)

		var/obj/item/surgicaldrill/SD = locate() in R.model.modules
		SD = new(R.model)
		R.model.basic_modules += SD
		R.model.add_module(SD, FALSE, TRUE)

		var/obj/item/scalpel/SL = locate() in R.model.modules
		SL = new(R.model)
		R.model.basic_modules += SL
		R.model.add_module(SL, FALSE, TRUE)

		var/obj/item/circular_saw/CS = locate() in R.model.modules
		CS = new(R.model)
		R.model.basic_modules += CS
		R.model.add_module(CS, FALSE, TRUE)

/obj/item/borg/upgrade/ai
	name = "B.O.R.I.S. module"
	desc = "Bluespace Optimized Remote Intelligence Synchronization. An uplink device which takes the place of an MMI in cyborg endoskeletons, creating a robotic shell controlled by an AI."
	icon_state = "boris"

/obj/item/borg/upgrade/ai/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		if(R.shell)
			to_chat(user, span_warning("This unit is already an AI shell!"))
			return FALSE
		if(R.key) //You cannot replace a player unless the key is completely removed.
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
	require_model = TRUE
	model_type = /obj/item/robot_model/engineering
	model_flags = BORG_MODEL_ENGINEERING

/obj/item/borg/upgrade/rped/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/storage/part_replacer/cyborg/RPED = locate() in R.model.modules
		if(RPED)
			to_chat(user, span_warning("This unit is already equipped with a RPED module."))
			return FALSE

		RPED = new(R.model)
		R.model.basic_modules += RPED
		R.model.add_module(RPED, FALSE, TRUE)

/obj/item/borg/upgrade/rped/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/storage/part_replacer/cyborg/RPED in R.model.modules)
			R.model.remove_module(RPED, TRUE)

/obj/item/borg/upgrade/plasmacutter
	name = "mining cyborg plasma cutter"
	desc = "A plasma cutter module for the mining cyborg."
	icon = 'icons/obj/guns/energy.dmi'
	icon_state = "adv_plasmacutter"
	require_model = TRUE
	model_type = /obj/item/robot_model/miner
	model_flags = BORG_MODEL_MINER

/obj/item/borg/upgrade/plasmacutter/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)

		var/obj/item/gun/energy/plasmacutter/adv/cyborg/PC = locate() in R.model.modules
		if(PC)
			to_chat(user, span_warning("This unit is already equipped with a plasma cutter module."))
			return FALSE

		PC = new(R.model)
		R.model.basic_modules += PC
		R.model.add_module(PC, FALSE, TRUE)

/obj/item/borg/upgrade/plasmacutter/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/gun/energy/plasmacutter/adv/cyborg/PC in R.model.modules)
			R.model.remove_module(PC, TRUE)

/obj/item/borg/upgrade/transform
	name = "borg model picker (Standard)"
	desc = "Allows you to turn a cyborg into a standard cyborg."
	icon_state = "cyborg_upgrade3"
	var/obj/item/robot_model/new_model = /obj/item/robot_model/standard

/obj/item/borg/upgrade/transform/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		R.model.transform_to(new_model)

/obj/item/borg/upgrade/transform/clown
	name = "borg model picker (Clown)"
	desc = "Allows you to turn a cyborg into a clown, honk."
	icon_state = "cyborg_upgrade3"
	new_model = /obj/item/robot_model/clown

/obj/item/borg/upgrade/transform/security
	name = "borg model picker (Security)"
	desc = "Allows you to turn a cyborg into a hunter, HALT!"
	icon_state = "cyborg_upgrade3"
	new_model = /obj/item/robot_model/security

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
	require_model = 1
	model_type = /obj/item/robot_model/janitor
	model_flags = BORG_MODEL_JANITOR

/obj/item/borg/upgrade/broomer/action(mob/living/silicon/robot/R, user = usr)
	if (!..())
		return
	var/obj/item/broom/cyborg/BR = locate() in R.model.modules
	if (BR)
		to_chat(user, span_warning("This janiborg is already equipped with an experimental broom!"))
		return FALSE
	BR = new(R.model)
	R.model.basic_modules += BR
	R.model.add_module(BR, FALSE, TRUE)

/obj/item/borg/upgrade/broomer/deactivate(mob/living/silicon/robot/R, user = usr)
	if (!..())
		return
	var/obj/item/broom/cyborg/BR = locate() in R.model.modules
	if (BR)
		R.model.remove_module(BR, TRUE)

/obj/item/borg/upgrade/snack_dispenser
	name = "Cyborg Upgrade (Snack Dispenser)"
	desc = "Gives the ability to dispense speciality snacks to medical, peacekeeper, service, and clown cyborgs."

/obj/item/borg/upgrade/snack_dispenser/action(mob/living/silicon/robot/R, user)
	if(R.stat == DEAD)
		to_chat(user, span_notice("[src] will not function on a deceased cyborg."))
		return FALSE
	// model_type doesn't support more than 1 module. Thus, this:
	if(!istype(R.model, /obj/item/robot_model/medical) && !istype(R.model, /obj/item/robot_model/peacekeeper) && !istype(R.model, /obj/item/robot_model/butler) && !istype(R.model, /obj/item/robot_model/clown))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(user, "There's no mounting point for the module!")
		return FALSE

	var/obj/item/borg_snack_dispenser/snack_dispenser = new(R.model)
	R.model.basic_modules += snack_dispenser
	R.model.add_module(snack_dispenser, FALSE, TRUE)

	for(var/obj/item/borg_snack_dispenser/peacekeeper/cookiesynth in R.model.modules) // the SC stands for shitcode
		R.model.remove_module(cookiesynth, TRUE)

	for(var/obj/item/borg_snack_dispenser/medical/lollipopshooter in R.model.modules)
		R.model.remove_module(lollipopshooter, TRUE)

	return TRUE

/obj/item/borg/upgrade/snack_dispenser/deactivate(mob/living/silicon/robot/R, user)
	. = ..()
	if(!.)
		return

	for(var/obj/item/borg_snack_dispenser/snack_dispenser in R.model.modules)
		R.model.remove_module(snack_dispenser, TRUE)

	if(istype(R.model, /obj/item/robot_model/peacekeeper))
		var/obj/item/borg_snack_dispenser/peacekeeper/cookiesynth = new(R.model)
		R.model.basic_modules += cookiesynth
		R.model.add_module(cookiesynth, FALSE, TRUE)
	else // Guess they're medical, service, or clown.
		var/obj/item/borg_snack_dispenser/medical/lollipopshooter = new(R.model)
		R.model.basic_modules += lollipopshooter
		R.model.add_module(lollipopshooter, FALSE, TRUE)
