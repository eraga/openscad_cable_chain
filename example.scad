include <cable_chains.scad>

translate([-50,0,8])
cable_chain(SAMPLE_CABLE_CHAIN, [0,0,30,30,30,30,30,30,0]);
translate([50,0,5])
cable_chain(SAMPLE_CABLE_CHAIN_WITH_HOOKS);
