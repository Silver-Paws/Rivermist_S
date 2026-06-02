/mob/living/carbon/human/thermal_vision_sight_test
	var/update_sight_calls = 0

/mob/living/carbon/human/thermal_vision_sight_test/update_sight()
	update_sight_calls++
	return ..()

/datum/unit_test/thermal_vision_sources_refresh_sight
#ifdef FOCUS_THERMAL_VISION_SIGHT_TEST
	focus = TRUE
#endif

/datum/unit_test/thermal_vision_sources_refresh_sight/Run()
	var/mob/living/carbon/human/thermal_vision_sight_test/human = allocate(/mob/living/carbon/human/thermal_vision_sight_test)

	var/initial_calls = human.update_sight_calls
	human.apply_status_effect(/datum/status_effect/buff/secondsight)
	TEST_ASSERT(HAS_TRAIT(human, TRAIT_THERMAL_VISION), "Second Sight should add thermal vision.")
	TEST_ASSERT_EQUAL(human.update_sight_calls, initial_calls + 1, "Second Sight should refresh sight after adding thermal vision.")

	var/datum/status_effect/buff/secondsight/secondsight = human.has_status_effect(/datum/status_effect/buff/secondsight)
	TEST_ASSERT_NOTNULL(secondsight, "Second Sight status effect should exist after being applied.")
	initial_calls = human.update_sight_calls
	secondsight.on_remove()
	TEST_ASSERT(!HAS_TRAIT(human, TRAIT_THERMAL_VISION), "Second Sight removal should remove thermal vision.")
	TEST_ASSERT_EQUAL(human.update_sight_calls, initial_calls + 1, "Second Sight should refresh sight after removing thermal vision.")

	var/obj/item/clothing/head/crown/circlet/vision/circlet = allocate(/obj/item/clothing/head/crown/circlet/vision)
	initial_calls = human.update_sight_calls
	circlet.equipped(human, ITEM_SLOT_HEAD)
	TEST_ASSERT(HAS_TRAIT(human, TRAIT_THERMAL_VISION), "Vision circlet should add thermal vision while worn.")
	TEST_ASSERT_EQUAL(human.update_sight_calls, initial_calls + 1, "Vision circlet should refresh sight after adding thermal vision.")

	initial_calls = human.update_sight_calls
	circlet.dropped(human)
	TEST_ASSERT(!HAS_TRAIT(human, TRAIT_THERMAL_VISION), "Vision circlet should remove thermal vision when dropped.")
	TEST_ASSERT_EQUAL(human.update_sight_calls, initial_calls + 1, "Vision circlet should refresh sight after removing thermal vision.")
