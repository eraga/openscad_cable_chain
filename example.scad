include <NopSCADlib/utils/core/core.scad>
include <cable_chains.scad>

//// Chain length and angles defined in array
//translate([-50,0,8])
//cable_chain(SAMPLE_CABLE_CHAIN, [0,0,30,30,30,30,30,30,0]);
//
//
//// Chain length and angles defined in type definition
//translate([50,0,5])
//cable_chain(SAMPLE_CABLE_CHAIN_WITH_HOOKS);
//
//
// Chain length and angles defined by variables
//WIDE_CABLE_CHAIN = ["", 30, 30, 10, 0, 33];
//translate([150,0,5])
//cable_chain(WIDE_CABLE_CHAIN, length = 350, turn_angle = 180);

// Chain STL helper
//                                    name,  l,   w,  h, hook,      smnts,  lh,    of
XY_CABLE_CHAIN = ["ABS_y_axis_cable_chain", 20, 20, 12, 2, 33, [0,-10,20, -10, 0, 0], 0.3, true];
cable_chain(XY_CABLE_CHAIN);

//translate([250,0,5]) {
//    cable_chain_section_body_and_cap(XY_CABLE_CHAIN);
//    translate([0,50,0])
//    cable_chain_section_body_and_cap(XY_CABLE_CHAIN, hook = true);
//}


