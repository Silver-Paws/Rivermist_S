/// Counts quirk
/proc/cmp_quirk_cost(datum/quirk/A, datum/quirk/B)
    return B.point_value - A.point_value

/// Penalize player for picking quirks that don't affect them for some reason and give free points
/datum/quirk/proc/penalize_points(penalize_text = "")
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	// Get all boons we have
	var/list/boons = list()
	for(var/datum/quirk/Q in H.quirks)
		if(Q.quirk_category == QUIRK_BOON)
			boons += Q
	if(!length(boons))
		return

	// Remove the same amount of quirks that match our vice points
	var/debt = abs(point_value)
	sortTim(boons, /proc/cmp_quirk_cost)
	while(debt > 0 && length(boons))
		var/datum/quirk/first = boons[1]
		var/min_cost = first.point_value
		var/list/candidates = list()
		for(var/datum/quirk/Q in boons)
			if(Q.point_value == min_cost)
				candidates += Q

		var/datum/quirk/chosen = pick(candidates)
		debt -= abs(chosen.point_value)
		boons -= chosen
		H.remove_quirk(chosen.type)

	to_chat(H, span_warning(penalize_text))
