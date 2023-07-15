/mob/living/silicon
	gender = NEUTER
	has_unlimited_silicon_privilege = 1
	verb_say = "states"
	verb_ask = "queries"
	verb_exclaim = "declares"
	verb_yell = "alarms"
	initial_language_holder = /datum/language_holder/synthetic
	see_in_dark = 8
	infra_luminosity = 0
	bubble_icon = "machine"
	weather_immunities = list("ash")
	possible_a_intents = list(INTENT_HELP, INTENT_HARM)
	mob_biotypes = list(MOB_ROBOTIC)
	deathsound = 'sound/voice/borg_deathsound.ogg'
	speech_span = SPAN_ROBOT
	flags_1 = PREVENT_CONTENTS_EXPLOSION_1 | HEAR_1 | RAD_PROTECT_CONTENTS_1 | RAD_NO_CONTAMINATE_1

	var/datum/ai_laws/laws = null//Now... THEY ALL CAN ALL HAVE LAWS
	var/last_lawchange_announce = 0
	var/list/alarms_to_show = list()
	var/list/alarms_to_clear = list()
	var/designation = ""
	var/radiomod = "" //Radio character used before state laws/arrivals announce to allow department transmissions, default, or none at all.
	/// The channel name of which /proc/statelaws will use to broadcast. Can be null.
	var/radiomodname = null
	var/obj/item/camera/siliconcam/aicamera = null //photography
	hud_possible = list(ANTAG_HUD, DIAG_STAT_HUD, DIAG_HUD, DIAG_TRACK_HUD)

	var/obj/item/radio/borg/radio = null //All silicons make use of this, with (p)AI's creating headsets

	var/list/alarm_types_show = list("Motion" = 0, "Fire" = 0, "Atmosphere" = 0, "Power" = 0, "Camera" = 0)
	var/list/alarm_types_clear = list("Motion" = 0, "Fire" = 0, "Atmosphere" = 0, "Power" = 0, "Camera" = 0)

	var/sensors_on = 0
	var/med_hud = DATA_HUD_MEDICAL_ADVANCED //Determines the med hud to use
	var/sec_hud = DATA_HUD_SECURITY_ADVANCED //Determines the sec hud to use
	var/d_hud = DATA_HUD_DIAGNOSTIC_BASIC //Determines the diag hud to use

	var/law_change_counter = 0
	var/obj/machinery/camera/builtInCamera = null
	var/updating = FALSE //portable camera camerachunk update
	///Whether we have been emagged
	var/emagged = FALSE
	var/hack_software = FALSE //Will be able to use hacking actions
	var/interaction_range = 7			//wireless control range
	///The reference to the built-in tablet that borgs carry.
	var/obj/item/modular_computer/tablet/integrated/modularInterface
	var/obj/item/pda/aiPDA

/mob/living/silicon/Initialize(mapload)
	. = ..()
	GLOB.silicon_mobs += src
	faction += "silicon"
	for(var/datum/atom_hud/data/diagnostic/diag_hud in GLOB.huds)
		diag_hud.add_atom_to_hud(src)
	diag_hud_set_status()
	diag_hud_set_health()
	ADD_TRAIT(src, TRAIT_FORCED_STANDING, "cyborg") // not CYBORG_ITEM_TRAIT because not an item


/mob/living/silicon/med_hud_set_health()
	return //we use a different hud

/mob/living/silicon/med_hud_set_status()
	return //we use a different hud

/mob/living/silicon/Destroy()
	radio = null
	aicamera = null
	QDEL_NULL(builtInCamera)
	GLOB.silicon_mobs -= src
	return ..()

/mob/living/silicon/contents_explosion(severity, target)
	return

/mob/living/silicon/proc/cancelAlarm()
	return

/mob/living/silicon/proc/triggerAlarm()
	return

/mob/living/silicon/proc/queueAlarm(message, type, incoming = 1)
	var/in_cooldown = (alarms_to_show.len > 0 || alarms_to_clear.len > 0)
	if(incoming)
		alarms_to_show += message
		alarm_types_show[type] += 1
	else
		alarms_to_clear += message
		alarm_types_clear[type] += 1

	if(!in_cooldown)
		spawn(3 * 10) // 3 seconds

			if(alarms_to_show.len < 5)
				for(var/msg in alarms_to_show)
					to_chat(src, msg)
			else if(alarms_to_show.len)

				var/msg = "--- "

				if(alarm_types_show["Burglar"])
					msg += "BURGLAR: [alarm_types_show["Burglar"]] alarms detected. - "

				if(alarm_types_show["Motion"])
					msg += "MOTION: [alarm_types_show["Motion"]] alarms detected. - "

				if(alarm_types_show["Fire"])
					msg += "FIRE: [alarm_types_show["Fire"]] alarms detected. - "

				if(alarm_types_show["Atmosphere"])
					msg += "ATMOSPHERE: [alarm_types_show["Atmosphere"]] alarms detected. - "

				if(alarm_types_show["Power"])
					msg += "POWER: [alarm_types_show["Power"]] alarms detected. - "

				if(alarm_types_show["Camera"])
					msg += "CAMERA: [alarm_types_show["Camera"]] alarms detected. - "

				msg += "<A href=?src=[REF(src)];showalerts=1'>\[Show Alerts\]</a>"
				to_chat(src, msg)

			if(alarms_to_clear.len < 3)
				for(var/msg in alarms_to_clear)
					to_chat(src, msg)

			else if(alarms_to_clear.len)
				var/msg = "--- "

				if(alarm_types_clear["Motion"])
					msg += "MOTION: [alarm_types_clear["Motion"]] alarms cleared. - "

				if(alarm_types_clear["Fire"])
					msg += "FIRE: [alarm_types_clear["Fire"]] alarms cleared. - "

				if(alarm_types_clear["Atmosphere"])
					msg += "ATMOSPHERE: [alarm_types_clear["Atmosphere"]] alarms cleared. - "

				if(alarm_types_clear["Power"])
					msg += "POWER: [alarm_types_clear["Power"]] alarms cleared. - "

				if(alarm_types_show["Camera"])
					msg += "CAMERA: [alarm_types_clear["Camera"]] alarms cleared. - "

				msg += "<A href=?src=[REF(src)];showalerts=1'>\[Show Alerts\]</a>"
				to_chat(src, msg)


			alarms_to_show = list()
			alarms_to_clear = list()
			for(var/key in alarm_types_show)
				alarm_types_show[key] = 0
			for(var/key in alarm_types_clear)
				alarm_types_clear[key] = 0

/mob/living/silicon/can_inject(mob/user, error_msg)
	if(error_msg)
		to_chat(user, span_alert("[p_their(TRUE)] outer shell is too tough."))
	return FALSE

/mob/living/silicon/IsAdvancedToolUser()
	return TRUE

/proc/islinked(mob/living/silicon/robot/bot, mob/living/silicon/ai/ai)
	if(!istype(bot) || !istype(ai))
		return FALSE
	if(bot.connected_ai == ai)
		return TRUE
	return FALSE

/mob/living/silicon/Topic(href, href_list)
	if(href_list["lawdevil"])
		var/index = text2num(href_list["lawdevil"])
		laws.flip_devil_state(index)
		checklaws()

	if(href_list["lawzeroth"])
		laws.flip_zeroth_state()
		checklaws()

	if (href_list["lawhacked"])
		var/index = text2num(href_list["lawhacked"])
		laws.flip_hacked_state(index)
		checklaws()

	if (href_list["lawion"])
		var/index = text2num(href_list["lawion"])
		laws.flip_ion_state(index)
		checklaws()
	
	if (href_list["lawinherent"])
		var/index = text2num(href_list["lawinherent"])
		laws.flip_inherent_state(index)
		checklaws()

	if (href_list["lawsupplied"])
		var/index = text2num(href_list["lawsupplied"])
		laws.flip_supplied_state(index)
		checklaws()

	if (href_list["laws"])
		statelaws()

	return

/mob/living/silicon/proc/statelaws(force = 0)
	laws_sanity_check()

	//"radiomod" is inserted before a hardcoded message to change if and how it is handled by an internal radio.
	say("[radiomod] Current Active Laws:")
	sleep(1 SECONDS)

	if(laws.devil && laws.devil.len)
		for(var/index = 1, index <= laws.devil.len, index++)
			if(force || laws.devilstate[index])
				say("[radiomod] 666. [laws.devil[index]]")
				sleep(1 SECONDS)

	if(laws.zeroth && (force || laws.zerothstate))
		say("[radiomod] 0. [laws.zeroth]")
		sleep(1 SECONDS)

	for (var/index = 1, index <= laws.hacked.len, index++)
		var/law = laws.hacked[index]
		var/num = ionnum()
		if(length(law) > 0 && (force || laws.hackedstate[index]) )
			say("[radiomod] [num]. [law]")
			sleep(1 SECONDS)

	for (var/index = 1, index <= laws.ion.len, index++)
		var/law = laws.ion[index]
		var/num = ionnum()
		if(length(law) > 0 && (force || laws.ionstate[index]) )
			say("[radiomod] [num]. [law]")
			sleep(1 SECONDS)

	var/number = 1
	for (var/index = 1, index <= laws.inherent.len, index++)
		var/law = laws.inherent[index]
		if(length(law) > 0 && (force || laws.inherentstate[index]) )
			say("[radiomod] [number]. [law]")
			number++
			sleep(1 SECONDS)

	for (var/index = 1, index <= laws.supplied.len, index++)
		var/law = laws.supplied[index]
		if(length(law) > 0 && (force || laws.suppliedstate[index]) )
			say("[radiomod] [number]. [law]")
			number++
			sleep(1 SECONDS)

/// A link-driven interface to state what laws the statelaws() proc will share with the crew.
/mob/living/silicon/proc/checklaws()
	laws_sanity_check()
	var/list = "<HTML><HEAD><meta charset='UTF-8'></HEAD><BODY><b>Which laws do you want to include when stating them for the crew?</b><br><br>"

	if (laws.devil && laws.devil.len)
		for(var/index = 1, index <= laws.devil.len, index++)
			var word = laws.devilstate[index] ? "Yes" : "No"
			list += {"<A href='byond://?src=[REF(src)];lawdevil=[index]'>[word] 666:</A> <font color='#cc5500'>[laws.devil[index]]</font><BR>"}

	if (laws.zeroth)
		var word = laws.zerothstate ? "Yes" : "No"
		list += {"<A href='byond://?src=[REF(src)];lawzeroth=0'>[word] 0:</A> <font color='#ff0000'><b>[laws.zeroth]</b></font><BR>"}

	for (var/index = 1, index <= laws.hacked.len, index++)
		var/law = laws.hacked[index]
		if (length(law) > 0)
			var word = laws.hackedstate[index] ? "Yes" : "No"
			list += {"<A href='byond://?src=[REF(src)];lawhacked=[index]'>[word] [ionnum()]:</A> <font color='#660000'>[law]</font><BR>"}

	for (var/index = 1, index <= laws.ion.len, index++)
		var/law = laws.ion[index]
		if(length(law) > 0)
			var word = laws.ionstate[index] ? "Yes" : "No"
			list += {"<A href='byond://?src=[REF(src)];lawion=[index]'>[word] [ionnum()]:</A> <font color='#547DFE'>[law]</font><BR>"}

	var/number = 1
	for (var/index = 1, index <= laws.inherent.len, index++)
		var/law = laws.inherent[index]
		if(length(law) > 0)
			var word = laws.inherentstate[index] ? "Yes" : "No"
			list += {"<A href='byond://?src=[REF(src)];lawinherent=[number]'>[word] [number]:</A> [law]<BR>"}
			number++

	for (var/index = 1, index <= laws.supplied.len, index++)
		var/law = laws.supplied[index]
		if(length(law) > 0)
			var word = laws.suppliedstate[index] ? "Yes" : "No"
			list += {"<A href='byond://?src=[REF(src)];lawsupplied=[number]'>[word] [number]:</A> <font color='#990099'>[law]</font><BR>"}
			number++

	list += {"<br><br><A href='byond://?src=[REF(src)];laws=1'>State Laws</A></BODY></HTML>"}
	usr << browse(list, "window=laws")

/mob/living/silicon/proc/ai_roster()
	if(!client)
		return
	if(world.time < client.crew_manifest_delay)
		return

	client.crew_manifest_delay = world.time + (1 SECONDS)
	var/datum/browser/popup = new(src, "airoster", "Crew Manifest", 387, 420)
	popup.set_content(GLOB.data_core.get_manifest_html())
	popup.open()

/mob/living/silicon/proc/set_autosay() //For allowing the AI and borgs to set the radio behavior of auto announcements (state laws, arrivals).
	if(!radio)
		to_chat(src, "Radio not detected.")
		return

	//Ask the user to pick a channel from what it has available.
	var/Autochan = input("Select a channel:") as null|anything in list("Default","None") + radio.channels

	if(!Autochan)
		return
	if(Autochan == "Default") //Autospeak on whatever frequency to which the radio is set, usually Common.
		radiomod = ";"
		Autochan += " ([radio.frequency])"
	else if(Autochan == "None") //Prevents use of the radio for automatic annoucements.
		radiomod = ""
	else	//For department channels, if any, given by the internal radio.
		for(var/key in GLOB.department_radio_keys)
			if(GLOB.department_radio_keys[key] == Autochan)
				radiomod = ":" + key
				break

	to_chat(src, span_notice("Automatic announcements [Autochan == "None" ? "will not use the radio." : "set to [Autochan]."]"))

/mob/living/silicon/put_in_hand_check() // This check is for borgs being able to receive items, not put them in others' hands.
	return 0

// The src mob is trying to place an item on someone
// But the src mob is a silicon!!  Disable.
/mob/living/silicon/stripPanelEquip(obj/item/what, mob/who, slot)
	return 0


/mob/living/silicon/assess_threat(judgement_criteria, lasercolor = "", datum/callback/weaponcheck=null) //Secbots won't hunt silicon units
	return -10

/mob/living/silicon/proc/remove_sensors()
	var/datum/atom_hud/secsensor = GLOB.huds[sec_hud]
	var/datum/atom_hud/medsensor = GLOB.huds[med_hud]
	var/datum/atom_hud/diagsensor = GLOB.huds[d_hud]
	secsensor.hide_from(src)
	medsensor.hide_from(src)
	diagsensor.hide_from(src)

/mob/living/silicon/proc/add_sensors()
	var/datum/atom_hud/secsensor = GLOB.huds[sec_hud]
	var/datum/atom_hud/medsensor = GLOB.huds[med_hud]
	var/datum/atom_hud/diagsensor = GLOB.huds[d_hud]
	secsensor.show_to(src)
	medsensor.show_to(src)
	diagsensor.show_to(src)

/mob/living/silicon/proc/toggle_sensors(silent = FALSE)
	if(incapacitated())
		return
	sensors_on = !sensors_on
	if (!sensors_on)
		if(!silent)
			to_chat(src, "Sensor overlay deactivated.")
		remove_sensors()
		return
	add_sensors()
	if(!silent)
		to_chat(src, "Sensor overlay activated.")

/mob/living/silicon/proc/GetPhoto(mob/user)
	if (aicamera)
		return aicamera.selectpicture(user)

/mob/living/silicon/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/changed = 0
	if(resize != RESIZE_DEFAULT_SIZE)
		changed++
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = ntransform, time = 0.2 SECONDS,easing = EASE_IN|EASE_OUT)
	return ..()

/mob/living/silicon/is_literate()
	return TRUE

/mob/living/silicon/get_inactive_held_item()
	return FALSE

/mob/living/silicon/handle_high_gravity(gravity)
	return

/mob/living/silicon/get_status_tab_items()
	.=..()
	.+= ""
	.+= "<h2>Current Silicon Laws:</h2>"
	if (laws.devil && laws.devil.len)
		for(var/index = 1, index <= laws.devil.len, index++)
			.+= "[laws.devil[index]]"

	if (laws.zeroth)
		.+= "<b><font color='#ff0000'>0: [laws.zeroth]</font></b>"

	for (var/index = 1, index <= laws.hacked.len, index++)
		var/law = laws.hacked[index]
		if (length(law) > 0)
			.+= "<b><font color='#660000'>[ionnum()]:</b> [law]</font>"

	for (var/index = 1, index <= laws.ion.len, index++)
		var/law = laws.ion[index]
		if (length(law) > 0)
			.+= "<b><font color='#547DFE'>[ionnum()]:</b> [law]</font>"

	var/number = 1
	for (var/index = 1, index <= laws.inherent.len, index++)
		var/law = laws.inherent[index]
		if (length(law) > 0)
			.+= "<b>[number]:</b> [law]"
			number++

	for (var/index = 1, index <= laws.supplied.len, index++)
		var/law = laws.supplied[index]
		if (length(law) > 0)
			.+= "<b><font color='#547DFE'>[number]:</b> [law]</font>"
			number++
	.+= ""

/mob/living/silicon/proc/accentchange()
	var/mob/living/L = usr
	if(!istype(L))
		return
	var/datum/mind/mega = usr.mind
	if(!istype(mega))
		return
	var/aksent = input(usr, "Choose your accent:","Available Accents") as null|anything in (assoc_to_keys(strings("accents.json", "accent_file_names", directory = "strings/accents")) + "None")
	if(aksent) // Accents were an accidents why the fuck do I have to do mind.RegisterSignal(mob, COMSIG_MOB_SAY)
		if(aksent == "None")
			mega.accent_name = null
			mega.UnregisterSignal(L, COMSIG_MOB_SAY)
		else
			mega.accent_name = aksent
			mega.RegisterSignal(L, COMSIG_MOB_SAY, TYPE_PROC_REF(/datum/mind, handle_speech), TRUE)

/mob/living/silicon/proc/create_modularInterface()
	if(!modularInterface)
		modularInterface = new /obj/item/modular_computer/tablet/integrated(src)
	modularInterface.layer = ABOVE_HUD_PLANE
	modularInterface.plane = ABOVE_HUD_PLANE

/mob/living/silicon/replace_identification_name(oldname,newname)
	if(modularInterface)
		var/obj/item/computer_hardware/hard_drive/hard_drive = modularInterface.all_components[MC_HDD]
		var/datum/computer_file/program/pdamessager/msgr = hard_drive?.find_file_by_name("pda_client")
		if(istype(msgr))
			var/jobname
			if(job)
				jobname = job
			else if(istype(src, /mob/living/silicon/robot))
				jobname = "[designation ? "[designation] " : ""]Cyborg"
			else if(designation)
				jobname = designation
			else if(istype(src, /mob/living/silicon/ai))
				jobname = "AI"
			else if(istype(src, /mob/living/silicon/pai))
				jobname = "pAI"
			else
				jobname = "Silicon"
			msgr.username = "[newname] ([jobname])"
