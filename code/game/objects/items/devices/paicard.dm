/obj/item/paicard
	name = "personal AI device"
	icon = 'icons/obj/aicards.dmi'
	icon_state = "pai"
	item_state = "electronic"
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	slot_flags = ITEM_SLOT_BELT
	cryo_preserve = TRUE
	var/mob/living/silicon/pai/pai
	resistance_flags = FIRE_PROOF | ACID_PROOF | INDESTRUCTIBLE

/obj/item/paicard/suicide_act(mob/living/user)
	user.visible_message(span_suicide("[user] is staring sadly at [src]! [user.p_they()] can't keep living without real human intimacy!"))
	return OXYLOSS

/obj/item/paicard/Initialize(mapload)
	SSpai.paicard_list += src
	add_overlay("pai-off")
	return ..()

/obj/item/paicard/Destroy()
	//Will stop people throwing friend pAIs into the singularity so they can respawn
	SSpai.paicard_list -= src
	if (!QDELETED(pai))
		QDEL_NULL(pai)
	return ..()

/obj/item/paicard/attack_self(mob/user)
	if (!in_range(src, user))
		return
	user.set_machine(src)
	var/dat = ""
	dat += "<HTML><HEAD><meta charset='UTF-8'></HEAD><BODY>"
	
	dat +="<TT><B>Personal AI Device</B><BR>"
	if(pai)
		if(!pai.master_dna || !pai.master)
			dat += "<a href='byond://?src=[REF(src)];setdna=1'>Imprint Master DNA</a><br>"
		dat += "Installed Personality: [pai.name]<br>"
		dat += "Prime directive: <br>[pai.laws.zeroth]<br>"
		for(var/slaws in pai.laws.inherent)
			dat += "Additional directives: <br>[slaws]<br>"
		dat += "<a href='byond://?src=[REF(src)];setlaws=1'>Configure Directives</a><br>"
		dat += "<br>"
		dat += "<h3>Device Settings</h3><br>"
		if(pai.radio)
			dat += "<b>Radio Uplink</b><br>"
			dat += "Transmit: <A href='byond://?src=[REF(src)];toggle_transmit=1'>\[[pai.can_transmit? "Disable" : "Enable"] Radio Transmission\]</a><br>"
			dat += "Receive: <A href='byond://?src=[REF(src)];toggle_receive=1'>\[[pai.can_receive? "Disable" : "Enable"] Radio Reception\]</a><br>"
		else
			dat += "<b>Radio Uplink</b><br>"
			dat += "<font color=red><i>Radio firmware not loaded. Please install a pAI personality to load firmware.</i></font><br>"
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.real_name == pai.master || H.dna.unique_enzymes == pai.master_dna)
				dat += "<A href='byond://?src=[REF(src)];toggle_holo=1'>\[[pai.canholo? "Disable" : "Enable"] holomatrix projectors\]</a><br>"
		dat += "<A href='byond://?src=[REF(src)];wipe=1'>\[Wipe current pAI personality\]</a><br>"
	else
		dat += "No personality installed.<br>"
		dat += "Searching for a personality... Press view available personalities to notify potential candidates."
		dat += "<A href='byond://?src=[REF(src)];request=1'>\[View available personalities\]</a><br>"
	
	dat += "</BODY></HTML>"
	user << browse(dat, "window=paicard")
	onclose(user, "paicard")
	return

/obj/item/paicard/Topic(href, href_list)

	if(!usr || usr.stat)
		return

	if(href_list["request"])
		SSpai.findPAI(src, usr)

	if(pai)
		if(!(loc == usr))
			return
		if(href_list["setdna"])
			if(pai.master_dna)
				return
			if(!iscarbon(usr))
				to_chat(usr, span_warning("You don't have any DNA, or your DNA is incompatible with this device!"))
			else
				var/mob/living/carbon/M = usr
				pai.master = M.real_name
				pai.master_dna = M.dna.unique_enzymes
				to_chat(pai, span_notice("You have been bound to a new master."))
				pai.emittersemicd = FALSE
		if(href_list["wipe"])
			var/confirm = tgui_alert(usr, "Are you CERTAIN you wish to delete the current personality? This action cannot be undone.", "Personality Wipe", list("Yes", "No"))
			if(confirm == "Yes")
				if(pai)
					to_chat(pai, span_warning("You feel yourself slipping away from reality."))
					to_chat(pai, span_danger("Byte by byte you lose your sense of self."))
					to_chat(pai, span_userdanger("Your mental faculties leave you."))
					to_chat(pai, span_rose("oblivion... "))
					qdel(pai)
		if(href_list["toggle_transmit"] || href_list["toggle_receive"])
			var/transmitting = href_list["toggle_transmit"] //it can't be both so if we know it's not transmitting it must be receiving.
			var/transmit_holder = (transmitting ? WIRE_TX : WIRE_RX)
			if(transmitting)
				pai.can_transmit = !pai.can_transmit
			else //receiving
				pai.can_receive = !pai.can_receive
			pai.radio.wires.cut(transmit_holder)//wires.cut toggles cut and uncut states
			transmit_holder = (transmitting ? pai.can_transmit : pai.can_receive) //recycling can be fun!
			to_chat(usr,span_warning("You [transmit_holder ? "enable" : "disable"] your pAI's [transmitting ? "outgoing" : "incoming"] radio transmissions!"))
			to_chat(pai,span_warning("Your owner has [transmit_holder ? "enabled" : "disabled"] your [transmitting ? "outgoing" : "incoming"] radio transmissions!"))
		if(href_list["setlaws"])
			var/newlaw = stripped_multiline_input(usr, "Enter any additional directives you would like your pAI personality to follow. Note that these directives will not override the personality's allegiance to its imprinted master. Conflicting directives will be ignored.", "pAI Directive Configuration", pai.laws.supplied[1], MAX_MESSAGE_LEN)
			if(newlaw && pai)
				pai.set_supplied_laws(list(newlaw))
		if(href_list["toggle_holo"])
			if(pai.canholo)
				to_chat(pai, span_userdanger("Your owner has disabled your holomatrix projectors!"))
				pai.canholo = FALSE
				to_chat(usr, span_warning("You disable your pAI's holomatrix!"))
			else
				to_chat(pai, span_boldnotice("Your owner has enabled your holomatrix projectors!"))
				pai.canholo = TRUE
				to_chat(usr, span_notice("You enable your pAI's holomatrix!"))

	attack_self(usr)

// 		WIRE_SIGNAL = 1
//		WIRE_RECEIVE = 2
//		WIRE_TRANSMIT = 4

/obj/item/paicard/proc/setPersonality(mob/living/silicon/pai/personality)
	src.pai = personality
	src.add_overlay("pai-null")

	playsound(loc, 'sound/effects/pai_boot.ogg', 50, TRUE, -1)
	audible_message("\The [src] plays a cheerful startup noise!")

/obj/item/paicard/proc/setEmotion(emotion)
	if(pai)
		src.cut_overlays()
		switch(emotion)
			if(1)
				src.add_overlay("pai-happy")
			if(2)
				src.add_overlay("pai-cat")
			if(3)
				src.add_overlay("pai-extremely-happy")
			if(4)
				src.add_overlay("pai-face")
			if(5)
				src.add_overlay("pai-laugh")
			if(6)
				src.add_overlay("pai-off")
			if(7)
				src.add_overlay("pai-sad")
			if(8)
				src.add_overlay("pai-angry")
			if(9)
				src.add_overlay("pai-what")
			if(10)
				src.add_overlay("pai-null")
			if(11)
				src.add_overlay("pai-sunglasses")

/obj/item/paicard/proc/alertUpdate()
	audible_message(span_info("[src] flashes a message across its screen, \"Additional personalities available for download.\""), span_notice("[src] vibrates with an alert."))

/obj/item/paicard/emp_act(severity)
	. = ..()
	if (. & EMP_PROTECT_SELF)
		return
	if(pai && !pai.holoform)
		pai.emp_act(severity)

