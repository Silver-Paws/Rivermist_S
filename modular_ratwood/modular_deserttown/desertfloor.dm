/turf/open/floor/desert/dunes
	name = "sand"
	desc = "Its course and rough, and it gets everywhere."
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	icon_state = "dune1"
	footstep = FOOTSTEP_SAND
	//barefootstep = FOOTSTEP_SAND
	//clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.wav'
	/* NEED TO REPAIR FOR RMH
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
						/turf/open/floor/grass,
						/turf/open/floor/desert_grass,
						/turf/open/floor/desert/dirt,
						/turf/open/floor/dirt/road,
						/turf/open/floor/desert/dirt/desert,
						/turf/open/floor/desert/dirt/road/desert,
						/turf/open/floor/desert/citybrick,
						/turf/open/floor/cobble,
						/turf/open/floor/cobblerock,
						/turf/open/floor/cobble/mossy,
						/turf/open/floor/grass/red,
						/turf/open/floor/grass/yel,
						/turf/open/floor/grass/cold,
						/turf/open/floor/grass/eora,
						/turf/open/floor/grass/healthy,
						/turf/open/floor/grass/hell,
						/turf/open/floor/grass/mixyel,
						/turf/open/floor/snow/patchy,
						/turf/open/floor/snow,
						/turf/open/floor/snow/rough,) */
	// slowdown = 1
	// neighborlay = "duneedge"
/* NEED TO REPAIR FOR RMH
/turf/open/floor/desert/dunes/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)
*/
/turf/open/floor/desert/dunes/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "dune[rand(1,16)]"

/obj/effect/decal/duneedge
	name = ""
	desc = ""
	icon = 'modular_ratwood/modular_deserttown/icons/duneedge.dmi'
	icon_state = "duneedge"
	mouse_opacity = 0

/turf/open/floor/desert/sandbrick
	icon_state = "sand-brick1"
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
/* NEED TO REPAIR FOR RMH
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/desert, /turf/closed/mineral, /turf/closed/wall/mineral/desert/stonebrick, /turf/closed/wall/mineral/desert/wood, /turf/closed/wall/mineral/desert/wooddark, /turf/closed/wall/mineral/desert/stone, /turf/closed/wall/mineral/desert/stone/moss, /turf/open/floor/desert/cobble, /turf/open/floor/desert/dirt, /turf/open/floor/desert/grass)
*/
	damage_deflection = 10
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/* NEED TO REPAIR FOR RMH
/turf/open/floor/desert/sandbrick/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)
*/

/turf/open/floor/desert/sandbrick/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "sand-brick[rand(1,4)]"

/turf/open/floor/desert/citybrick
	icon_state = "city-brick1"
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	/* NEED TO REPAIR FOR RMH
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/desert, /turf/closed/mineral, /turf/closed/wall/mineral/desert/stonebrick, /turf/closed/wall/mineral/desert/wood, /turf/closed/wall/mineral/desert/wooddark, /turf/closed/wall/mineral/desert/stone, /turf/closed/wall/mineral/desert/stone/moss, /turf/open/floor/desert/cobble, /turf/open/floor/desert/dirt, /turf/open/floor/desert/grass)
	*/
	damage_deflection = 10
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	abstract_type = /turf/open/floor/desert/citybrick

/turf/open/floor/desert/citybrick/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/* NEED TO REPAIR FOR RMH
/turf/open/floor/desert/citybrick/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)
	*/
/turf/open/floor/desert/citybrick/citybrick1
	icon_state = "city-brick1-1"

/turf/open/floor/desert/citybrick/citybrick1/Initialize()
	. = ..()
	icon_state = "city-brick1-[rand(1,4)]"


/turf/open/floor/desert/citybrick/citybrick2
	icon_state = "city-brick2-1"

/turf/open/floor/desert/citybrick/citybrick2/Initialize()
	. = ..()
	icon_state = "city-brick2-[rand(1,5)]"


/turf/open/floor/desert/citybrick/citybrick3
	icon_state = "city-brick3-1" //this only has one variant


/turf/open/floor/desert/citybrick/citybrick4
	icon_state = "city-brick4-1"

/turf/open/floor/desert/citybrick/citybrick4/Initialize()
	. = ..()
	icon_state = "city-brick4-[rand(1,2)]"

/turf/open/floor/desert/citybrick/citybrick5
	icon_state = "city-brick5-1"

/turf/open/floor/desert/citybrick/citybrick5/Initialize()
	. = ..()
	icon_state = "city-brick5-[rand(1,2)]"


/turf/open/floor/desert/citybrick/citybrick6
	icon_state = "city-brick6-1"

/turf/open/floor/desert/citybrick/citybrick6/Initialize()
	. = ..()
	icon_state = "city-brick6-[rand(1,2)]"

/turf/open/floor/desert/lightpath
	icon_state = "light-path1"
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	/* NEED TO REPAIR FOR RMH
	canSmoothWith = list(/turf/open/floor/desert, /turf/closed/mineral, /turf/closed/wall/mineral)
	*/
	// slowdown = 0 //Could be due tweaking but turning it off for now for practical reasons
	footstep = FOOTSTEP_SAND
	//barefootstep = FOOTSTEP_SAND
	//clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	/* NEED TO REPAIR FOR RMH
	smooth = SMOOTH_TRUE
	*/
	/* NEED TO REPAIR FOR RMH
/turf/open/floor/desert/lightpath/cardinal_smooth(adjacencies)
	desertsmooth(adjacencies)
	*/
/turf/open/floor/desert/lightpath/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "light-path[rand(1,8)]"


/turf/open/floor/desert/darkpath
	icon_state = "dark-path1"
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	/* NEED TO REPAIR FOR RMH
	canSmoothWith = list(/turf/open/floor/desert, /turf/closed/mineral, /turf/closed/wall/mineral)
	*/
	slowdown = 0
	footstep = FOOTSTEP_SAND
	//barefootstep = FOOTSTEP_SAND
	//clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	//NEED TO REPAIR FOR RMH smooth = SMOOTH_TRUE

	/* NEED TO REPAIR FOR RMH
/turf/open/floor/desert/darkpath/cardinal_smooth(adjacencies)
	desertsmooth(adjacencies)
	*/
/turf/open/floor/desert/darkpath/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "dark-path[rand(1,8)]"

/obj/effect/decal/desertgrassedge
	name = ""
	desc = ""
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	icon_state = "desertgrassedge"
	mouse_opacity = 0

/turf/open/floor/desert/desert_grass
	name = "desert grass"
	desc = "Grass, barely."
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	icon_state = "desertgrass1"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	//NEED TO REPAIR FOR RMH tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	//NEED TO REPAIR FOR RMH smooth = SMOOTH_TRUE
	/* NEED TO REPAIR FOR RMH
	canSmoothWith = list(
						/turf/open/floor/grass,
						/turf/open/floor/dunes,
						/turf/open/floor/dirt,
						/turf/open/floor/dirt/road,
						/turf/open/floor/dirt/desert,
						/turf/open/floor/dirt/road/desert,
						/turf/open/floor/citybrick,
						/turf/open/floor/grassred,
						/turf/open/floor/grassyel,
						/turf/open/floor/grasscold,
						/turf/open/floor/grassgrey,
						/turf/open/floor/grasspurple,
						/turf/open/floor/snowpatchy,
						/turf/open/floor/snow,
						/turf/open/floor/snowrough,
						/turf/open/floor/cobble,
						/turf/open/floor/cobblerock,
						/turf/open/floor/cobble/mossy,)
	neighborlay = "desertgrassedge"
	*/
	neighborlay = "desertgrassedge"
	spread_chance = 15
	burn_power = 6

/turf/open/floor/desert/desert_grass/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)
	icon_state = "desertgrass[rand(1,16)]"

/* NEED TO REPAIR FOR RMH
/turf/open/floor/desert_grass/cardinal_smooth(adjacencies)
	desertsmooth(adjacencies)

/turf/open/floor/desert/desert_grass/turf_destruction(damage_flag)
	. = ..()
	src.ChangeTurf(/turf/open/floor/dirt/desert, flags = CHANGETURF_INHERIT_AIR)
*/
/turf/open/floor/desert_grass/nospawn

/turf/open/floor/dirt/desert
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'

/turf/open/floor/dirt/desert/nospawn

/turf/open/floor/dirt/road/desert
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'

/turf/open/floor/grass/desert
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'

///.

/turf/open/floor/desert/deserttile
	icon_state = "tiledrab"
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	/* NEED TO REPAIR FOR RMH
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/desert, /turf/closed/mineral, /turf/closed/wall/mineral/desert/stonebrick, /turf/closed/wall/mineral/desert/wood, /turf/closed/wall/mineral/desert/wooddark, /turf/closed/wall/mineral/desert/stone, /turf/closed/wall/mineral/desert/stone/moss, /turf/open/floor/desert/cobble, /turf/open/floor/desert/dirt, /turf/open/floor/desert/grass)
	*/
	damage_deflection = 10
	max_integrity = 1000
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	abstract_type = /turf/open/floor/desert/deserttile

/turf/open/floor/naturalstone/sandstone
	name = "rough sandstone ground"
	desc = "Rough sandstone that's been exposed to the air either through erosion or the swing of a pickaxe. Dust wisps through the cracks."
	icon = 'modular_ratwood/modular_deserttown/icons/desertfloor.dmi'
	/* NEED TO REPAIR FOR RMH
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/desert,
						/turf/closed/mineral,
						/turf/closed/wall/mineral)
	*/
