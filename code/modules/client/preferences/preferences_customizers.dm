/datum/preferences/proc/validate_customizer_entries()
	customizer_entries = SANITIZE_LIST(customizer_entries)
	listclearnulls(customizer_entries)
	var/datum/species/species = pref_species
	var/list/customizers = species.customizers
	/// Check if we have any customizer entries that don't match.
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/validated = FALSE
		for(var/customizer_type as anything in customizers)
			if(customizer_type != entry.customizer_type)
				continue
			var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
			if(!(entry.customizer_choice_type in customizer.customizer_choices))
				continue
			var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
			if(entry.type != customizer_choice.customizer_entry_type)
				continue
			validated = TRUE
			break

		if(!validated)
			customizer_entries -= entry

	/// Check if we have any missing customizer entries
	for(var/customizer_type as anything in customizers)
		var/found = FALSE
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			if(entry.customizer_type != customizer_type)
				continue
			found = TRUE
			break
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!found)
			customizer_entries += customizer.make_default_customizer_entry(src, FALSE)

	/// Validate the variables within customizer entries
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		customizer_choice.validate_entry(src, entry)

	enforce_required_genital_set()

/datum/preferences/proc/print_customizers_page()
	var/list/dat = list()
	. = dat
	if(!pref_species)
		return

	// Keep older or partially initialized preference records from opening a broken customizer UI.
	validate_customizer_entries()

	var/list/customizers = pref_species.customizers
	if(!customizers)
		return
	dat += "<div class='genital-set-card'>"
	dat += "<div><b>Genital Set:</b> [get_current_genital_set_label()]</div>"
	dat += "<a href='?_src_=prefs;task=change_customizer;customizer_task=toggle_genital_set'>Toggle Genitals</a>"
	dat += "<small>You must keep either a complete masculine or feminine set.</small>"
	dat += "</div>"
	dat += "<div class='feature-grid'>"
	for(var/customizer_type as anything in customizers)
		var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
		if(!customizer.is_allowed(src))
			continue
		var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
		if(!entry)
			stack_trace("Missing customizer entry in preferences for customizer [customizer_type]")
			continue
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)

		var/card_class = entry.disabled ? "feature-card disabled" : "feature-card"
		dat += "<div class='[card_class]'>"
		if(customizer.allows_disabling)
			var/title_status = entry.disabled ? "Enable" : "Disable"
			dat += "<a class='feature-title' href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=toggle_missing'>[customizer.name]<small>[title_status]</small></a>"
		else
			dat += "<div class='feature-title static'>[customizer.name]<small>Fixed</small></div>"
		if(!entry.disabled)
			var/choice_link
			if(length(customizer.customizer_choices) > 1)
				choice_link = "href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=change_choice'"
			else
				choice_link = "class='linkOff'"
			if(length(customizer.customizer_choices) > 1)
				dat += "<a class='feature-choice' [choice_link]>[choice.name]<small>Change type</small></a>"
			else
				dat += "<div class='feature-choice static'>[choice.name]</div>"

			var/list/choice_list = choice.show_pref_choices(src, entry, customizer_type)
			if(choice_list)
				dat += "<div class='feature-controls'>"
				dat += choice_list
				dat += "</div>"
		else
			dat += "<div class='muted'>Disabled</div>"

		dat += "</div>"
	dat += "</div>"
	return

/// We dont associate the entries just to be safer for save/load, so we can't lookup easily and we do this.
/datum/preferences/proc/get_customizer_entry_for_customizer_type(customizer_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(entry.customizer_type == customizer_type)
			return entry

/datum/preferences/proc/get_customizer_entry_for_entry_type(entry_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(istype(entry, entry_type))
			return entry

/datum/preferences/proc/has_enabled_customizer_entry_type(entry_type)
	var/datum/customizer_entry/entry = get_customizer_entry_for_entry_type(entry_type)
	return entry && !entry.disabled

/datum/preferences/proc/set_customizer_entry_type_enabled(entry_type, enabled)
	var/datum/customizer_entry/entry = get_customizer_entry_for_entry_type(entry_type)
	if(entry)
		entry.disabled = !enabled

/datum/preferences/proc/species_has_masculine_genital_set()
	return get_customizer_entry_for_entry_type(/datum/customizer_entry/organ/genitals/penis) && get_customizer_entry_for_entry_type(/datum/customizer_entry/organ/genitals/testicles)

/datum/preferences/proc/species_has_feminine_genital_set()
	return get_customizer_entry_for_entry_type(/datum/customizer_entry/organ/genitals/breasts) && get_customizer_entry_for_entry_type(/datum/customizer_entry/organ/genitals/vagina)

/datum/preferences/proc/has_masculine_genital_set()
	return has_enabled_customizer_entry_type(/datum/customizer_entry/organ/genitals/penis) && has_enabled_customizer_entry_type(/datum/customizer_entry/organ/genitals/testicles)

/datum/preferences/proc/has_feminine_genital_set()
	return has_enabled_customizer_entry_type(/datum/customizer_entry/organ/genitals/breasts) && has_enabled_customizer_entry_type(/datum/customizer_entry/organ/genitals/vagina)

/datum/preferences/proc/get_preferred_genital_set()
	if(has_masculine_genital_set())
		return "masculine"
	if(has_feminine_genital_set())
		return "feminine"
	if(gender == FEMALE)
		return "feminine"
	return "masculine"

/datum/preferences/proc/get_current_genital_set_label()
	var/has_masculine = has_masculine_genital_set()
	var/has_feminine = has_feminine_genital_set()
	if(has_masculine && has_feminine)
		return "Mixed"
	if(has_masculine)
		return "Masculine"
	if(has_feminine)
		return "Feminine"
	return "Unset"

/datum/preferences/proc/set_genital_set(genital_set)
	var/masculine = genital_set == "masculine"
	set_customizer_entry_type_enabled(/datum/customizer_entry/organ/genitals/penis, masculine)
	set_customizer_entry_type_enabled(/datum/customizer_entry/organ/genitals/testicles, masculine)
	set_customizer_entry_type_enabled(/datum/customizer_entry/organ/genitals/breasts, !masculine)
	set_customizer_entry_type_enabled(/datum/customizer_entry/organ/genitals/vagina, !masculine)

/datum/preferences/proc/toggle_genital_set()
	if(has_masculine_genital_set() && !has_feminine_genital_set())
		set_genital_set("feminine")
	else
		set_genital_set("masculine")

/datum/preferences/proc/enforce_required_genital_set(preferred_set)
	if(has_masculine_genital_set() || has_feminine_genital_set())
		return FALSE
	if(!preferred_set)
		preferred_set = get_preferred_genital_set()
	if(preferred_set == "feminine" && species_has_feminine_genital_set())
		set_genital_set("feminine")
		return TRUE
	if(preferred_set == "masculine" && species_has_masculine_genital_set())
		set_genital_set("masculine")
		return TRUE
	if(species_has_masculine_genital_set())
		set_genital_set("masculine")
		return TRUE
	if(species_has_feminine_genital_set())
		set_genital_set("feminine")
		return TRUE
	return FALSE

/datum/preferences/proc/cleanup_quirks_for_customizer_entry(datum/customizer_entry/entry)
	return FALSE

/// Gets an associative list of organ slots to organ dna created from organ customization
/datum/preferences/proc/get_organ_dna_list()
	enforce_required_genital_set()
	var/list/organ_list = list()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		var/datum/organ_dna/dna = customizer_choice.create_organ_dna(entry, src)
		if(!dna)
			continue
		organ_list[customizer_choice.get_organ_slot()] = dna

	return organ_list

/datum/preferences/proc/customize_organ(obj/item/organ/organ)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		if(!(customizer_choice.get_organ_slot() == organ.slot))
			continue
		customizer_choice.customize_organ(organ, entry)

/datum/preferences/proc/apply_customizers_to_character(mob/living/carbon/human/human)
	enforce_required_genital_set()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/customizer_choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		var/datum/customizer/customizer = CUSTOMIZER(entry.customizer_type)
		if(!customizer.is_allowed(src))
			continue
		if(entry.disabled)
			continue
		customizer_choice.apply_customizer_to_character(human, src, entry)

/datum/preferences/proc/handle_customizer_topic(mob/user, href_list)
	//needs_update = TRUE
	if(href_list["customizer_task"] == "toggle_genital_set")
		toggle_genital_set()
		mark_preview_appearance_dirty()
		return
	var/previous_genital_set = get_preferred_genital_set()
	var/customizer_type = text2path(href_list["customizer"])
	var/datum/customizer_entry/entry = get_customizer_entry_for_customizer_type(customizer_type)
	if(!entry)
		return
	var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
	var/datum/customizer/customizer = CUSTOMIZER(customizer_type)
	switch(href_list["customizer_task"])
		if("toggle_missing")
			if(customizer.allows_disabling)
				entry.disabled = !entry.disabled
				if(entry.disabled)
					cleanup_quirks_for_customizer_entry(entry)
		if("change_choice")
			var/list/choice_list = list()
			for(var/choice_type in customizer.customizer_choices)
				var/datum/customizer_choice/iter_choice = CUSTOMIZER_CHOICE(choice_type)
				choice_list[iter_choice.name] = choice_type
			var/chosen_input = input(user, "Choose your [lowertext(customizer.name)]:", "Character Preference")  as null|anything in choice_list
			if(!chosen_input)
				return
			var/choice_type = choice_list[chosen_input]
			if(choice_type == choice.type)
				return
			customizer_entries -= entry
			entry = customizer.create_customizer_entry(src, choice_type)
			customizer_entries += entry
			cleanup_quirks_for_customizer_entry(entry)
		else
			choice.handle_topic(user, href_list, src, entry, customizer_type)
	if(enforce_required_genital_set(previous_genital_set))
		to_chat(user, span_warning("You must keep either a complete masculine or feminine genital set."))
	mark_preview_appearance_dirty()

/datum/preferences/proc/reset_all_customizer_accessory_colors()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.reset_accessory_colors(src, entry)

/datum/preferences/proc/randomize_all_customizer_accessories()
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		var/datum/customizer_choice/choice = CUSTOMIZER_CHOICE(entry.customizer_choice_type)
		choice.randomize_entry(entry, src)

/datum/preferences/proc/ShowCustomizers(mob/user)
	var/list/dat = list()
	dat += {"
	<html lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<style>
			body {
				margin: 0;
				background: #1a1a1a;
				color: #d8cf9f;
				font-family: Verdana, Geneva, sans-serif;
				font-size: 12px;
			}
			.wrap {
				padding: 14px;
			}
			.panel {
				background: #2a2723;
				border: 2px solid #5b4b40;
				box-shadow: inset 0 0 0 1px #141211;
				padding: 12px;
			}
			h2 {
				margin: 0 0 10px;
				color: #eee69c;
				font-size: 16px;
				text-transform: uppercase;
				letter-spacing: 0;
			}
			a {
				color: #eee69c;
				font-weight: bold;
				text-decoration: none;
			}
			a:hover {
				color: #f1e78b;
			}
			.genital-set-card {
				background: #342d28;
				border: 1px solid #5b4b40;
				box-shadow: inset 0 0 0 1px #171515;
				margin-bottom: 12px;
				padding: 9px 10px;
				text-align: center;
			}
			.genital-set-card small {
				display: block;
				color: #9f9377;
				margin-top: 3px;
			}
			.feature-grid {
				text-align: left;
			}
			.feature-card {
				display: inline-block;
				vertical-align: top;
				width: 31.8%;
				min-height: 138px;
				box-sizing: border-box;
				background: #342d28;
				border: 1px solid #5b4b40;
				box-shadow: inset 0 0 0 1px #171515;
				margin: 0 1% 10px 0;
				padding: 8px;
			}
			.feature-card.disabled {
				background: #211f1d;
				opacity: 0.78;
			}
			.feature-title {
				display: block;
				background: #705d4f;
				border: 1px solid #171515;
				color: #161418;
				font-weight: bold;
				margin-bottom: 6px;
				padding: 6px 7px;
				text-transform: uppercase;
			}
			.feature-title:hover {
				background: #8b735f;
				color: #161418;
			}
			.feature-title small {
				float: right;
				color: #2b2320;
				font-weight: normal;
				text-transform: none;
			}
			.feature-title.static {
				cursor: default;
			}
			.feature-choice {
				display: block;
				background: #171515;
				border: 1px solid #5b4b40;
				margin-bottom: 7px;
				padding: 5px 7px;
			}
			.feature-choice small {
				display: block;
				color: #8f846c;
				font-weight: normal;
				margin-top: 2px;
			}
			.feature-choice.static {
				color: #bcae82;
				font-weight: bold;
			}
			.feature-controls {
				color: #d8cf9f;
				line-height: 1.55;
			}
			.feature-controls a {
				color: #eee69c;
			}
			.linkOff {
				color: #8f846c !important;
			}
			.muted {
				color: #8f846c;
				margin-top: 8px;
			}
			.accessory-box {
				text-align: center;
				margin: 9px 0;
			}
			.accessory-frame {
				background: #161418;
				border: 1px solid #5b4b40;
				display: inline-block;
				padding: 8px;
			}
			.accessory-preview {
				margin-bottom: 5px;
				line-height: 64px;
				min-height: 64px;
			}
			.accessory-preview img {
				height: 64px;
				image-rendering: pixelated;
				vertical-align: middle;
				width: 64px;
			}
			.accessory-controls {
				margin-top: 5px;
			}
			.accessory-arrow {
				font-size: 16px;
				padding: 0 5px;
			}
			.accessory-dropdown {
				background: #1d1a17;
				border: 1px solid #5b4b40;
				margin: 9px 0;
				max-height: 300px;
				overflow-y: auto;
				padding: 8px;
			}
			.accessory-grid-card {
				display: inline-block;
				vertical-align: top;
				width: 92px;
				min-height: 96px;
				background: #161418;
				border: 1px solid #43372f;
				margin: 3px;
				padding: 5px;
				text-align: center;
			}
			.accessory-grid-card.selected {
				border-color: #eee69c;
			}
			.accessory-grid-card img {
				display: block;
				height: 64px;
				image-rendering: pixelated;
				margin: 0 auto;
				width: 64px;
			}
			.accessory-grid-label {
				color: #d8cf9f;
				font-size: 10px;
				margin-top: 3px;
			}
			.accessory-grid-card.selected .accessory-grid-label {
				color: #eee69c;
			}
			.color_holder_box {
				display: inline-block;
				width: 24px;
				height: 10px;
				border: 1px solid #161616;
				padding: 0;
				vertical-align: middle;
			}
			.footer {
				margin-top: 12px;
				text-align: right;
			}
		</style>
	</head>
	<body>
		<div class="wrap">
			<div class="panel">
				<h2>Features</h2>
	"}
	dat += print_customizers_page()
	dat += {"
				<div class="footer"><a href='?_src_=prefs;preference=body_customize;task=menu'>Customize Appearance</a></div>
			</div>
		</div>
		<script>
			(function() {
				function getDirection(step) {
					switch(step) {
						case 1:
							return "&dir=4";
						case 2:
							return "&dir=8";
						case 3:
							return "&dir=1";
					}
					return "";
				}
				function setPreview(card, step) {
					var img = card.getElementsByTagName("img").item(0);
					if(!img) {
						return;
					}
					img.src = card.getAttribute("data-icon") + "?state=" + card.getAttribute("data-state") + getDirection(step);
				}
				function wireCard(card) {
					if(!card.addEventListener) {
						return;
					}
					card.addEventListener("mouseenter", function() {
						card.spinStep = 0;
						card.spinTimer = setInterval(function() {
							card.spinStep = (card.spinStep + 1) % 4;
							setPreview(card, card.spinStep);
						}, 200);
					});
					card.addEventListener("mouseleave", function() {
						clearInterval(card.spinTimer);
						card.spinStep = 0;
						setPreview(card, 0);
					});
				}
				var divs = document.getElementsByTagName("div");
				var i = 0;
				while(i < divs.length) {
					var card = divs.item(i);
					if((" " + card.className + " ").indexOf(" accessory-grid-card ") >= 0) {
						wireCard(card);
					}
					i++;
				}
			})();
		</script>
	</body>
	</html>
	"}
	var/datum/browser/popup = new(user, "customization", "<div align='center'>Customization</div>", 630, 730)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/get_hair_color()
	var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/head)
	if(entry)
		return entry.hair_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_facial_hair_color()
	var/datum/customizer_entry/hair/entry = get_customizer_entry_of_type(/datum/customizer_entry/hair/facial)
	if(entry)
		return entry.hair_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_eye_color()
	var/datum/customizer_entry/organ/eyes/entry = get_customizer_entry_of_type(/datum/customizer_entry/organ/eyes)
	if(entry)
		return entry.eye_color
	else
		return "FFFFFF"

/datum/preferences/proc/get_chest_color()
	var/list/zone_list = body_markings[BODY_ZONE_CHEST]
	if(!zone_list)
		return null
	for(var/marking_name in zone_list)
		var/datum/body_marking/marking = GLOB.body_markings[marking_name]
		if(!marking.covers_chest)
			continue
		var/marking_color = zone_list[marking_name]
		return marking_color
	return null

/datum/preferences/proc/get_customizer_entry_of_type(entry_type)
	for(var/datum/customizer_entry/entry as anything in customizer_entries)
		if(entry.type == entry_type)
			return entry
	return null

/datum/preferences/proc/has_enabled_customizer_entry(entry_type)
	var/datum/customizer_entry/entry = get_customizer_entry_of_type(entry_type)
	return entry && !entry.disabled


/datum/preferences/proc/genderize_customizer_entries()
	customizer_entries = SANITIZE_LIST(customizer_entries)
	var/datum/species/species = pref_species
	var/list/customizers = species.customizers

	/// Check if we have any missing customizer entries
	for(var/datum/customizer/customizer_type as anything in customizers)
		if(customizer_type.gender_enabled == null)
			continue
		for(var/datum/customizer_entry/entry as anything in customizer_entries)
			if(entry.customizer_type != customizer_type)
				continue
			if(customizer_type.gender_enabled == gender)
				entry.disabled = FALSE
			else
				entry.disabled = TRUE
			break
	enforce_required_genital_set()

/datum/preferences/proc/clear_flavor()
	flavortext = null
	nsfwflavortext = null
	erpprefs_flavor = null
	ooc_notes = null
	ooc_extra = null
	song_title = null
	song_artist = null
	headshot_link = null
	img_gallery = null
	nsfw_img_gallery = null
