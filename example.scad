include <cable_chains.scad>

// Chain length and angles defined in array
translate([-50,0,8])
cable_chain(SAMPLE_CABLE_CHAIN, [0,0,30,30,30,30,30,30,0]);


// Chain length and angles defined in type definition
translate([50,0,5])
cable_chain(SAMPLE_CABLE_CHAIN_WITH_HOOKS);


// Chain length and angles defined by variables
WIDE_CABLE_CHAIN = [30, 30, 10, 0, 30];
translate([150,0,5])
cable_chain(WIDE_CABLE_CHAIN, length = 350, turn_angle = 150);
