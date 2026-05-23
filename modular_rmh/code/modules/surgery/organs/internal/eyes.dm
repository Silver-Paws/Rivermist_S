/obj/item/organ/eyes
	/// Switch for eyes emissive glow
	var/user_glowing_pref = TRUE

/obj/item/organ/eyes/imprint_organ_dna(datum/organ_dna/eyes/eyes_dna)
	..()
	eyes_dna.eye_glowing = glows

/obj/item/organ/eyes/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = FALSE, new_zone = null)
	. = ..()
	if(glows)
		add_verb(M, /mob/living/carbon/proc/set_eyes_glowing)

/obj/item/organ/eyes/Remove(mob/living/carbon/M, special = 0)
	. = ..()
	remove_verb(M, /mob/living/carbon/proc/set_eyes_glowing)

/mob/living/carbon/proc/set_eyes_glowing()
	set name = "Switch eyes glowing"
	set category = "IC"
	for(var/obj/item/organ/eyes/eyes in internal_organs)
		eyes.user_glowing_pref = !eyes.user_glowing_pref
	update_body_parts(TRUE)
