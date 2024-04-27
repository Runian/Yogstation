
/*

Contents:
- Assorted ninjadrain_act() procs
- What is Object Oriented Programming

They *could* go in their appropriate files, but this is supposed to be modular

*/

/// What happens when ninja gloves are used (with special interaction) on this atom. If it drains power, returns a numerical value. Otherwise, returns a non-numerical value.
/atom/proc/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN
	return INVALID_DRAIN

/// Notifies all AIs about a hacking attempt at this machinery's location.
/obj/machinery/proc/notify_AI_of_hack()
	var/turf/location = get_turf(src)
	var/alertstr = "[span_userdanger("Network Alert: Hacking attempt detected[location ? " in [location]" : ". Unable to pinpoint location"]")]."
	for(var/mob/living/silicon/ai/AI in GLOB.player_list)
		to_chat(AI, alertstr)

// APC //
/// Drains the power of the APC's cell and emags the APC afterward.
/obj/machinery/power/apc/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN
	
	// Safety check: Will the drain cause the suit's cell to reach its maximum?
	var/max_capacity = FALSE
	// Safety check: What is the amount to be drained in this loop?
	var/drain = 0
	var/drain_total = 0

	if(!cell || !cell.charge)
		return drain_total

	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, loc)

	while(ninja_gloves.candrain && cell.charge > 0 && !max_capacity)
		drain = rand(ninja_gloves.mindrain, ninja_gloves.maxdrain)
		drain = min(drain, cell.charge)

		if(ninja_suit.cell.charge + drain > ninja_suit.cell.maxcharge)
			drain = ninja_suit.cell.maxcharge - ninja_suit.cell.charge
			max_capacity = TRUE

		if(!do_after(ninja, 1 SECONDS, src))
			break

		spark_system.start()
		playsound(loc, "sparks", 50, 1)
		cell.use(drain)
		ninja_suit.cell.give(drain)
		drain_total += drain

	if(!(obj_flags & EMAGGED))
		flick("apc-spark", src)
		playsound(loc, "sparks", 50, 1)
		obj_flags |= EMAGGED
		locked = FALSE
		update_appearance(UPDATE_ICON)

	return drain_total


// SMES //
/// Drains the power of the SMES's charge.
/obj/machinery/power/smes/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN

	// Safety check: Will the drain cause the suit's cell to reach its maximum?
	var/max_capacity = FALSE
	// Safety check: What is the amount to be drained in this loop?
	var/drain = 0
	var/drain_total = 0

	if(!charge)
		return drain_total

	var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, loc)

	while(ninja_gloves.candrain && charge > 0 && !max_capacity)
		drain = rand(ninja_gloves.mindrain, ninja_gloves.maxdrain)
		drain = min(drain, charge)

		if(ninja_suit.cell.charge + drain > ninja_suit.cell.maxcharge)
			drain = ninja_suit.cell.maxcharge - ninja_suit.cell.charge
			max_capacity = TRUE

		if(!do_after(ninja, 1 SECONDS, src))
			break

		spark_system.start()
		playsound(loc, "sparks", 50, 1)
		charge -= drain
		ninja_suit.cell.give(drain)
		drain_total += drain

	return drain_total

// SMES //
/// Drains the power of the cell's charge and corrupts it.
/obj/item/stock_parts/cell/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN

	if(!charge)
		return 0
	
	if(!do_after(ninja, 3 SECONDS, src) || !ninja_gloves.candrain)
		return INVALID_DRAIN

	var/drain = charge
	if(ninja_suit.cell.charge + drain > ninja_suit.cell.maxcharge)
		drain = ninja_suit.cell.maxcharge - ninja_suit.cell.charge

	use(drain)
	ninja_suit.cell.give(charge)
	corrupt()
	update_appearance(UPDATE_ICON)

	return drain

// RD SERVER //
/// Takes all the research points and completes the research sercets objective.
/obj/machinery/rnd/server/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN

	to_chat(ninja, span_notice("Research notes detected. Corrupting data..."))
	notify_AI_of_hack()

	if(!do_after(ninja, 30 SECONDS, target = src))
		return DRAIN_RD_HACK_FAILED

	stored_research.set_points_all(0)
	to_chat(ninja, span_notice("Sabotage complete. Research notes corrupted."))

	var/datum/antagonist/ninja/ninja_antag = ninja.mind.has_antag_datum(/datum/antagonist/ninja)
	if(ninja_antag)
		var/datum/objective/research_secrets/objective = locate() in ninja_antag.objectives
		if(objective)
			objective.completed = TRUE

	return DRAIN_RD_HACK

// MASTER RD SERVER //
/// If source code is still there, overloads it and completes the research sercets objective. Otherwise, refer back to RD SERVER.
/obj/machinery/rnd/server/master/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN

	// If the traitor theft objective is still present, this will destroy it...
	if(!source_code_hdd)
		return ..()

	to_chat(ninja, span_notice("Hacking \the [src]..."))
	notify_AI_of_hack()
	to_chat(ninja, span_notice("Encrypted source code detected. Overloading storage device..."))

	if(!do_after(ninja, 30 SECONDS, target = src))
		return DRAIN_RD_HACK_FAILED

	overload_source_code_hdd()
	to_chat(ninja, span_notice("Sabotage complete. Storage device overloaded."))

	var/datum/antagonist/ninja/ninja_antag = ninja.mind.has_antag_datum(/datum/antagonist/ninja)
	if(ninja_antag)
		var/datum/objective/research_secrets/objective = locate() in ninja_antag.objectives
		if(objective)
			objective.completed = TRUE

	return DRAIN_RD_HACK

// CABLE //
/// Drains the cable's powernet for power. If powernet doesn't have enough power, drains powernet's connected APCs.
/obj/structure/cable/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/ninja_suit, mob/living/carbon/human/ninja, obj/item/clothing/gloves/space_ninja/ninja_gloves)
	if(!ninja_suit || !ninja || !ninja_gloves)
		return INVALID_DRAIN

	// Safety check: Will the drain cause the suit's cell to reach its maximum?
	var/max_capacity = FALSE
	// Safety check: What is the amount to be drained in this loop?
	var/drain = 0
	var/drain_total = 0

	var/datum/powernet/powernet = powernet
	while(ninja_gloves.candrain && !max_capacity && src && powernet)
		drain = rand(ninja_gloves.mindrain, ninja_gloves.maxdrain)
		drain = round(drain/2) // Since cables are easier to find, it shall be slower.

		if(!do_after(ninja, 1 SECONDS, src))
			break

		var/drained = min(drain, delayed_surplus())
		add_delayedload(drained)

		// Got enough power.
		if(drained >= drain)
			if(ninja_suit.cell.charge + drained > ninja_suit.cell.maxcharge)
				drained = ninja_suit.cell.maxcharge - ninja_suit.cell.charge
				max_capacity = TRUE

			ninja_suit.spark_system.start()
			playsound(loc, "sparks", 50, 1)
			ninja_suit.cell.give(drained)
			drain_total += drained
			continue

		// Not enough power. Drain from connected APCs up to required.
		var/remaining_drain = drain - drained
		for(var/obj/machinery/power/terminal/terminal in powernet.nodes)
			if(!istype(terminal.master, /obj/machinery/power/apc))
				continue

			var/obj/machinery/power/apc/apc = terminal.master
			if(!apc.operating || !apc.cell || !apc.cell.charge)
				continue

			if(remaining_drain <= 0)
				break
			
			var/to_drain = min(remaining_drain, 5)
			apc.cell.charge = max(0, apc.cell.charge - to_drain)
			drained += to_drain
			remaining_drain -= to_drain

		if(ninja_suit.cell.charge + drained > ninja_suit.cell.maxcharge)
			drained = ninja_suit.cell.maxcharge - ninja_suit.cell.charge
			max_capacity = TRUE
		
		// No power at all.
		if(!drained)
			break
	
		ninja_suit.spark_system.start()
		playsound(loc, "sparks", 50, 1)
		ninja_suit.cell.give(drained)
		drain_total += drained

	return drain_total

// MECH //
/obj/mecha/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/S, mob/living/carbon/human/H, obj/item/clothing/gloves/space_ninja/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check
	var/drain = 0 //Drain amount
	. = 0

	occupant_message(span_danger("Warning: Unauthorized access through sub-route 4, block H, detected."))
	if(get_charge())
		while(G.candrain && cell.charge > 0 && !maxcapacity)
			drain = rand(G.mindrain,G.maxdrain)
			if(cell.charge < drain)
				drain = cell.charge
			if(S.cell.charge + drain > S.cell.maxcharge)
				drain = S.cell.maxcharge - S.cell.charge
				maxcapacity = 1
			if (do_after(H, 1 SECONDS, src))
				spark_system.start()
				playsound(loc, "sparks", 50, 1)
				cell.use(drain)
				S.cell.give(drain)
				. += drain
			else
				break

//BORG//
/mob/living/silicon/robot/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/S, mob/living/carbon/human/H, obj/item/clothing/gloves/space_ninja/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	var/maxcapacity = 0 //Safety check
	var/drain = 0 //Drain amount
	. = 0

	to_chat(src, span_danger("Warning: Unauthorized access through sub-route 12, block C, detected."))

	if(cell && cell.charge)
		while(G.candrain && cell.charge > 0 && !maxcapacity)
			drain = rand(G.mindrain,G.maxdrain)
			if(cell.charge < drain)
				drain = cell.charge
			if(S.cell.charge+drain > S.cell.maxcharge)
				drain = S.cell.maxcharge - S.cell.charge
				maxcapacity = 1
			if (do_after(H, 1 SECONDS, src))
				spark_system.start()
				playsound(loc, "sparks", 50, 1)
				cell.use(drain)
				S.cell.give(drain)
				. += drain
			else
				break


//CARBON MOBS//
/mob/living/carbon/ninjadrain_act(obj/item/clothing/suit/space/space_ninja/S, mob/living/carbon/human/H, obj/item/clothing/gloves/space_ninja/G)
	if(!S || !H || !G)
		return INVALID_DRAIN

	. = DRAIN_MOB_SHOCK_FAILED

	//Default cell = 10,000 charge, 10,000/1000 = 10 uses without charging/upgrading
	if(S.cell && S.cell.charge && S.cell.use(1000))
		. = DRAIN_MOB_SHOCK
		//Got that electric touch
		var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
		spark_system.set_up(5, 0, loc)
		playsound(src, "sparks", 50, 1)
		visible_message(span_danger("[H] electrocutes [src] with [H.p_their()] touch!"), span_userdanger("[H] electrocutes you with [H.p_their()] touch!"))
		electrocute_act(15, H)
