/datum/unit_test/stale_blueprint_vision_trait_is_not_active_blueprint_mode
#ifdef FOCUS_BLUEPRINT_MODE_TEST
	focus = TRUE
#endif

/datum/unit_test/stale_blueprint_vision_trait_is_not_active_blueprint_mode/Run()
	var/mob/user = allocate(/mob)

	ADD_TRAIT(user, TRAIT_BLUEPRINT_VISION, TRAIT_GENERIC)

	TEST_ASSERT(!user.has_active_blueprint_mode(), "A stale blueprint vision trait should not count as active blueprint mode.")

	user.exit_blueprint()

	TEST_ASSERT(!HAS_TRAIT(user, TRAIT_BLUEPRINT_VISION), "Exiting blueprint mode should remove stale blueprint vision.")
	TEST_ASSERT_NULL(user.blueprints, "Exiting blueprint mode should clear stale blueprint datum references.")
