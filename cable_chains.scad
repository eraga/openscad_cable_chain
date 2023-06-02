// l — segment length
// w — segment width
// h — segment heigth
// hook — every i-th segment will have a hook, set to 0 to have no segments with a hook
// segments — array with default segment angles, each item is a segment and its value is an angle
//                              l,   w,  h, hook,  segments
SAMPLE_CABLE_CHAIN_WITH_HOOKS = [40, 20, 10, 2,  [0,0,0]];
SAMPLE_CABLE_CHAIN =           [40, 30, 16, 0];

use <cable_chain.scad>
