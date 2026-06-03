#define TEST_TRAIT_CAN_STEER_SHIP "Can steer the ship"

/obj/structure/ship_wheel/unit_test

/obj/structure/ship_wheel/unit_test/Initialize(mapload)
	return INITIALIZE_HINT_NORMAL

/datum/unit_test/voyage_navigator_job_is_voyage_only_and_can_steer
#ifdef FOCUS_VOYAGE_NAVIGATOR_TEST
	focus = TRUE
#endif

/datum/unit_test/voyage_navigator_job_is_voyage_only_and_can_steer/Run()
	var/navigator_type = text2path("/datum/job/navigator")
	TEST_ASSERT_NOTNULL(navigator_type, "Navigator job type should exist.")

	var/navigator_outfit_type = text2path("/datum/outfit/navigator")
	TEST_ASSERT_NOTNULL(navigator_outfit_type, "Navigator outfit type should exist.")

	var/datum/job/navigator_job = new navigator_type
	TEST_ASSERT_EQUAL(navigator_job.title, "Navigator", "Navigator job should have the expected title.")
	TEST_ASSERT_EQUAL(navigator_job.spawn_positions, 0, "Navigator should have no default roundstart slots.")
	TEST_ASSERT_EQUAL(navigator_job.total_positions, 0, "Navigator should have no default latejoin slots.")
	TEST_ASSERT_EQUAL(navigator_job.outfit, navigator_outfit_type, "Navigator should use its dedicated outfit.")
	TEST_ASSERT(TEST_TRAIT_CAN_STEER_SHIP in navigator_job.traits, "Navigator should receive the ship steering trait.")

	var/datum/map_adjustment/voyager/voyage_adjustment = new
	TEST_ASSERT_EQUAL(voyage_adjustment.slot_adjust[navigator_type], 2, "Voyage should grant two Navigator slots.")

	if(!length(SSjob.name_occupations))
		SSjob.SetupOccupations()

	var/obj/structure/ship_wheel/wheel = allocate(/obj/structure/ship_wheel/unit_test)
	var/mob/living/carbon/human/test_pilot = allocate(/mob/living/carbon/human)
	test_pilot.job = /datum/job/towner::title

	TEST_ASSERT(!wheel.can_navigate(test_pilot), "A mob without the steering trait should not pilot the ship.")

	ADD_TRAIT(test_pilot, TEST_TRAIT_CAN_STEER_SHIP, "unit_test")
	TEST_ASSERT(wheel.can_navigate(test_pilot), "The steering trait should be enough to pilot the ship.")

#undef TEST_TRAIT_CAN_STEER_SHIP
