/datum/unit_test/pottery_recipe_handles_missing_step_time
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/pottery_recipe_handles_missing_step_time/Run()
	var/datum/pottery_recipe/recipe = new
	recipe.step_to_time = list()

	var/delay = recipe.get_delay(null, 0)
	TEST_ASSERT(isnum(delay), "Pottery recipes with missing step timings should still return a numeric delay.")

/datum/unit_test/structure_examine_status_handles_zero_integrity
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/structure_examine_status_handles_zero_integrity/Run()
	var/obj/structure/structure = allocate(/obj/structure)
	structure.uses_integrity = TRUE
	structure.max_integrity = 0

	TEST_ASSERT_NULL(structure.examine_status(null), "Zero-integrity structures should not divide by zero while examined.")

/datum/unit_test/footstep_data_includes_wood_barefoot
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/footstep_data_includes_wood_barefoot/Run()
	TEST_ASSERT((FOOTSTEP_WOOD_BAREFOOT in GLOB.barefootstep), "Wood barefoot footstep data should exist when a turf override asks for it.")

/datum/unit_test/language_holder_handles_missing_atom
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/language_holder_handles_missing_atom/Run()
	var/datum/language_holder/holder = new
	holder.remove_language(/datum/language/common)

	TEST_ASSERT_EQUAL(holder.has_language(/datum/language/elvish), FALSE, "Detached language holders should not ask a null atom for shadow languages.")

/datum/unit_test/loinspent_ignores_nonhuman_owner
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/loinspent_ignores_nonhuman_owner/Run()
	var/mob/living/simple_animal/animal = allocate(/mob/living/simple_animal)
	var/datum/status_effect/debuff/loinspent/effect = new(list(animal))
	animal.mob_timers["chafing_loins"] = 0

	effect.tick()

	TEST_ASSERT_NOTEQUAL(animal.mob_timers["chafing_loins"], 0, "Loinspent should still update its cooldown before ignoring non-human owners.")

/datum/unit_test/human_smoke_protection_ignores_nonclothing_mask
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/human_smoke_protection_ignores_nonclothing_mask/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/reagent_containers/food/snacks/produce/poppy/poppy = allocate(/obj/item/reagent_containers/food/snacks/produce/poppy)
	human.vars["wear_mask"] = poppy

	TEST_ASSERT_EQUAL(human.has_smoke_protection(), FALSE, "Human smoke protection should ignore non-clothing mask-slot contents.")

/datum/unit_test/carbon_cremation_handles_missing_chest
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/carbon_cremation_handles_missing_chest/Run()
	var/mob/living/carbon/human/human = allocate(/mob/living/carbon/human)
	var/obj/item/bodypart/chest/chest = human.get_bodypart(BODY_ZONE_CHEST)
	human.remove_bodypart(chest)
	human.on_fire = TRUE
	human.stat = DEAD

	human.check_cremation()

	TEST_ASSERT_NULL(human.get_bodypart(BODY_ZONE_CHEST), "Cremation should stop cleanly when a carbon has no chest bodypart.")

/mob/living/carbon/human/runtime_regression_null_blood/get_blood_type()
	return null

/datum/unit_test/bodypart_blood_splatter_handles_null_blood_type
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/bodypart_blood_splatter_handles_null_blood_type/Run()
	var/mob/living/carbon/human/runtime_regression_null_blood/original_owner = allocate(/mob/living/carbon/human/runtime_regression_null_blood)
	var/obj/item/bodypart/l_arm/arm = allocate(/obj/item/bodypart/l_arm, run_loc_floor_bottom_left)
	arm.original_owner = original_owner

	arm.throw_impact(get_turf(arm), null)

	TEST_ASSERT_EQUAL(arm.get_blood_splatter_color(), COLOR_BLOOD, "Dropped bodyparts should fall back to normal blood color when their owner has no blood type.")

/datum/unit_test/alchemy_examine_handles_observer
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/alchemy_examine_handles_observer/Run()
	var/mob/dead/observer/observer = allocate(/mob/dead/observer)
	var/obj/item/reagent_containers/food/snacks/produce/poppy/poppy = allocate(/obj/item/reagent_containers/food/snacks/produce/poppy)

	var/list/examine_lines = poppy.examine(observer)

	TEST_ASSERT(islist(examine_lines), "Alchemy precursor examine should not ask observers for living skill data.")

/datum/unit_test/tgui_payload_handles_missing_client
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/tgui_payload_handles_missing_client/Run()
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/datum/host = allocate(/datum)
	var/datum/tgui/ui = allocate(/datum/tgui, user, host, "RuntimeRegression", "Runtime Regression")

	var/list/payload = ui.get_payload()
	var/list/config = payload["config"]
	var/list/window_config = config["window"]

	TEST_ASSERT_EQUAL(window_config["fancy"], FALSE, "TGUI payloads should use safe client defaults when a user has disconnected.")

/datum/unit_test/chat_message_ignores_clientless_viewer
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/chat_message_ignores_clientless_viewer/Run()
	var/mob/living/carbon/human/viewer = allocate(/mob/living/carbon/human)
	var/mob/living/carbon/human/speaker = allocate(/mob/living/carbon/human)

	viewer.create_chat_message(speaker, null, "hello", list())

	TEST_ASSERT_NULL(viewer.client, "Runechat should not create chatmessage datums for mobs without clients.")

/datum/unit_test/crafting_move_products_ignores_qdeleted_outputs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/crafting_move_products_ignores_qdeleted_outputs/Run()
	var/datum/repeatable_crafting_recipe/recipe = allocate(/datum/repeatable_crafting_recipe)
	var/mob/living/carbon/human/user = allocate(/mob/living/carbon/human)
	var/obj/item/natural/stone/stone = allocate(/obj/item/natural/stone, run_loc_floor_bottom_left)
	qdel(stone)

	recipe.move_products(list(stone), user)

	TEST_ASSERT(QDELETED(stone), "Crafting product handoff should skip outputs that were already consumed by qdel.")

/datum/unit_test/looping_sound_start_ignores_qdeleted_sound
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/looping_sound_start_ignores_qdeleted_sound/Run()
	var/datum/looping_sound/loop = new(run_loc_floor_bottom_left)
	qdel(loop)

	loop.start()

	TEST_ASSERT(QDELETED(loop), "Looping sounds should not schedule timers after they have started qdel.")

/datum/unit_test/putrid_feed_corpse_handles_missing_master
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/putrid_feed_corpse_handles_missing_master/Run()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/our_mob = allocate(/mob/living/simple_animal/hostile/retaliate/meatvine)
	our_mob.master = null
	var/datum/ai_controller/controller = allocate(/datum/ai_controller, our_mob)
	var/datum/ai_planning_subtree/papameat_feed_corpse/subtree = allocate(/datum/ai_planning_subtree/papameat_feed_corpse)

	subtree.SelectBehaviors(controller, 1)

	TEST_ASSERT_NULL(controller.blackboard[BB_CORPSE_TO_FEED], "Putrid corpse-feeding planning should stop cleanly when its meatvine has no master.")

/datum/unit_test/listed_action_group_handles_missing_palette
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/listed_action_group_handles_missing_palette/Run()
	var/datum/action_group/listed/group = allocate(/datum/action_group/listed)

	group.refresh_actions()

	TEST_ASSERT_EQUAL(group.size(), 0, "Listed action groups should tolerate being refreshed during HUD teardown.")

/datum/unit_test/tgui_window_handles_missing_client
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/tgui_window_handles_missing_client/Run()
	var/datum/tgui_window/window = new(null, "runtime_regression")

	window.initialize()

	TEST_ASSERT_EQUAL(window.status, TGUI_WINDOW_CLOSED, "TGUI windows should ignore initialize calls when they have no valid client.")
	qdel(window)

/datum/unit_test/wild_plant_harvest_ignores_abstract_family_defs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/wild_plant_harvest_ignores_abstract_family_defs/Run()
	var/list/abstract_plant_defs = list(
		/datum/plant_def/alchemical,
		/datum/plant_def/mushroom,
	)

	for(var/plant_def_type as anything in abstract_plant_defs)
		var/obj/structure/wild_plant/plant = allocate(/obj/structure/wild_plant, run_loc_floor_bottom_left, plant_def_type, -1)
		plant.yield_produce()
		TEST_ASSERT(QDELETED(plant), "Wild plants should not try to spawn produce from abstract plant family definitions.")

/datum/unit_test/soil_yield_ignores_abstract_family_defs
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/soil_yield_ignores_abstract_family_defs/Run()
	var/obj/structure/soil/soil = allocate(/obj/structure/soil, run_loc_floor_bottom_left)
	soil.plant = allocate(/datum/plant_def/mushroom)
	soil.plant_genetics = allocate(/datum/plant_genetics, soil.plant)
	soil.produce_ready = TRUE

	soil.yield_produce()

	TEST_ASSERT_EQUAL(soil.produce_ready, FALSE, "Soil should clear ready produce when its plant definition cannot yield produce.")

/datum/unit_test/visible_non_genital_organs_accept_visibility_toggle
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/visible_non_genital_organs_accept_visibility_toggle/Run()
	var/obj/item/organ/tail/tail = allocate(/obj/item/organ/tail)
	var/was_visible = tail.visible_organ

	call(tail, "toggle_visibility")("Show Above clothes")

	TEST_ASSERT_EQUAL(tail.visible_organ, was_visible, "Visible non-genital organs should accept the visibility toggle hook without runtiming.")

/datum/unit_test/quest_turn_in_markers_are_indexed
#ifdef FOCUS_RUNTIME_REGRESSION_TEST
	focus = TRUE
#endif

/datum/unit_test/quest_turn_in_markers_are_indexed/Run()
	var/obj/effect/decal/marker_export/marker = allocate(/obj/effect/decal/marker_export, run_loc_floor_bottom_left)

	TEST_ASSERT((marker in GLOB.quest_turn_in_markers), "Quest turn-in markers should be indexed instead of found by scanning the whole world.")
