// name — name, used in nopscadlib stl export
// l — segment length
// w — segment width
// h — segment heigth
// hook — every i-th segment will have a hook, set to 0 to have no segments with a hook
// segments — array with default segment angles, each item is a segment and its value is an angle
// lh — layer heigth while 3d printing, if not set or 0 — defaults to .2mm
//                                                 name,  l,   w,  h, hook,  smnts,  lh
SAMPLE_CABLE_CHAIN_WITH_HOOKS = ["sample_chain_w_hooks", 40, 20, 10, 2, 30, [0,0,0], .3];
SAMPLE_CABLE_CHAIN =            ["sample_chain"        , 40, 30, 16, 0, 30];

use <cable_chain.scad>
