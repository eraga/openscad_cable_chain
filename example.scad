include <cable_chains.scad>

translate([-50,0,8])
cable_chain(SAMPLE_CABLE_CHAIN);
translate([50,0,5])
cable_chain(SAMPLE_CABLE_CHAIN_WITH_HOOKS);
