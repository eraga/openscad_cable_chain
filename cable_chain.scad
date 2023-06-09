include <NopSCADlib/utils/core/core.scad>
use <NopSCADlib/utils/horiholes.scad>
include <NopSCADlib/utils/core/rounded_rectangle.scad>


function cable_chain_name(type) = type[0];
function cable_chain_segment_length(type) = type[1];
function cable_chain_segment_width(type) = type[2];
function cable_chain_segment_heigth(type) = type[3];
function cable_chain_hook_spacing(type) = type[4];
function cable_chain_max_angle(type) = type[5];
function cable_chain_default_segments(type) = is_undef(type[6]) ? [0] : type[6];
function cable_chain_3dprinted_layer_heigth(type) = is_undef(type[7]) ? .2 : type[7] == 0 ? .2 : type[7];
function cable_chain_one_way_flex(type) = is_undef(type[8]) ? false : type[8] == false ? false : true;


function str_replace(string, search_chr, replace_chr) = chr([
    for (c = str(string))
        c == search_chr ? ord(replace_chr) : ord(c)
    ]);

/**
* STL helper
*/
module cable_chain_section_body_and_cap(type, hook = false) {
    l = cable_chain_segment_length(type);
    w = cable_chain_segment_width(type);
    h = cable_chain_segment_heigth(type);
    $fn = 90;
    translate([0, 0, h / 2]) {
        translate([0, - l, - h + 1.5])
            rotate([0, 0, 0])
                cable_chain_section_cap(type);

        cable_chain_section_body(type, hook = hook);
    }
}

module cable_chain_section(type, color = "yellow", hook = true) {

    with_hook = hook ? "_with_hook" : "";

    name = str(cable_chain_name(type), with_hook);
    stl(name);

    color("blue")
        render()
            cable_chain_section_cap(type);

    color(color)
        render()
            cable_chain_section_body(type, hook = hook);
}

module cable_chain_section_cap(type, expansion = 0) {
    l = cable_chain_segment_length(type);
    w = cable_chain_segment_width(type);
    h = cable_chain_segment_heigth(type);
    translate([0, l / 12, h / 2 - 1 / 2 - .25]) {
        cube([w - 6, l / 3, 1.5 + expansion], center = true);
        cube([w - 3 + expansion * 10, l / 3 / 2, 1.5 + expansion], center = true);
    }
}

module cable_chain_section_body_base(
    type,
    start = true,
    end = true,
) {
    l = cable_chain_segment_length(type);
    w = cable_chain_segment_width(type);
    h = cable_chain_segment_heigth(type);
    z = cable_chain_3dprinted_layer_heigth(type);
    owf = cable_chain_one_way_flex(type);

    module ear_mount() {
        translate_z(h / 2)
        cube([3.2, h / 2, h / 2], center = true);
        translate_z(- h / 2){
            if (owf) {
                translate([0, h * 3 / 8, 0])
                    cube([3.2, h / 4, h], center = true);
            }
            cube([3.2, h / 2, h / 2], center = true);
        }

        rotate([0, 90, 0])
            difference() {
                union() {
                    cylinder(d = h, h = 3.2, center = true);
                    rotate([0, 0, 90])
                        horicylinder(r = (h + .25) / 2, z = z, h = 3.2, center = true);
                }
                rotate([0,0,90])
                horicylinder(r = 3/2, z = z, h = 4, center = true);
            }
    }

    difference() {
        union() {
            hull() {
                cube([w, l, h], center = true);
                if (end) {
                    translate([0, l / 2, 0]) {
                        rotate([0, 90, 0])
                            cylinder(d = h, h = w, center = true);

                        if (owf) {
                            translate([0, 0, -h/4])
                                rounded_cube_yz([w, h, h/2], r = 1, xy_center = true, z_center = true);
//                                cube([w, h, h/2], center = true);
                        }
                    }
                }
                if (start) {
                    translate([0, - l / 2 + h / 4, 0])
                        rotate([0, 90, 0])
                            cylinder(d = h, h = w, center = true);
                }
            }

            if (start) {
                translate([0, - l / 2, 0])
                    rotate([0, 90, 0])
                        cylinder(d = 3, h = w + 1, center = true);
            }

        }

        if (end) {
            translate([0, l / 2, 0])
                rotate([90, 0, 90])
                    horihole(r = 3.5/2, z = z, h = w * 2);

            translate([0, l * 0.8, 0])
                cube([w - 3.1, l, h * 2], center = true);
        }

        if (start) {
            translate([- w / 2, - l / 2, 0])
                ear_mount();
            translate([w / 2, - l / 2, 0])
                ear_mount();

            translate([0, 0, 2])
                cube([w - 6, l * 2, h], center = true);

        }
    }
}

module cable_chain_section_body(
type,
d_cooler = 24.5,
d_filament_feeder = 4.5,
hook = true
) {
    l = cable_chain_segment_length(type);
    w = cable_chain_segment_width(type);
    h = cable_chain_segment_heigth(type);

    hook_th = 8;
    hook_h = 4;

    module attach_hook(d, cooler = false) {
        difference() {
            union() {
                difference() {
                    hull() {
                        cylinder(d = d + hook_th, h = hook_h, center = true);
                        translate([0, - d / 2 - hook_th / 2, - hook_h / 2])
                            cube([d / 2, d / 2, hook_h]);
                    }
                    cylinder(d = d, h = hook_h * 2, center = true);
                }
                //                if(cooler) {
                //                    difference() {
                //                        cylinder(d = d + 1, h = 1, center = true);
                //                        cylinder(d = d - 1.5, h = 2, center = true);
                //                    }
                //                }
            }
            translate([- d / 4, - d / 6, - d / 2])
                cube([d * 2, d * 2, d * 2]);

        }
    }

    difference() {
        union() {
            cable_chain_section_body_base(type);
            if (hook) {
                if (d_cooler > 0) {
                    translate([(d_cooler / 2 + w / 2), 0, d_cooler / 2 + hook_th / 2 - h / 2])
                        rotate([90, 0, 180])
                            attach_hook(d = d_cooler, cooler = true);
                }

                //                if (d_filament_feeder > 0) {
                //                    translate([(d_cooler / 2 + w / 2), 0, 0]) {
                //                        translate([(d_filament_feeder / 2 + d_cooler / 2) + hook_th / 2, 0, d_filament_feeder / 2 +
                //                                hook_th
                //                                / 2 - h / 2]) {
                //                            rotate([90, 0, 180])
                //                                attach_hook(d = d_filament_feeder);
                //                        }
                //                        translate([hook_th / 2, 0, - h / 2 + hook_th / 4])
                //                            cube([d_cooler, hook_h, hook_th / 2], center = true);
                //                    }
                //                }
            }
        }


        translate_z(- 1.5)
        cable_chain_section_cap(type, expansion = 1);
    }

}

function greatest_of(a, b) = a >= b ? a : b;


function cable_chain_generate_angles(type, l, a) = concat([
    for (i = [0 : l / cable_chain_segment_length(type)])
    0
    ], [for (j = [1 : a / cable_chain_max_angle(type)]) cable_chain_max_angle(type)]);

/**
* type — chain type
* segments — array of segment angles, each item represents a segment
*/
module cable_chain(type, segments = [], length = undef, turn_angle = undef) {
    if (!is_undef(length) || !is_undef(turn_angle)) {
        assert(!is_undef(length), "length should be set");
        assert(!is_undef(turn_angle), "turn_angle should be set");
    }

    l = cable_chain_segment_length(type);
    w = cable_chain_segment_width(type);
    h = cable_chain_segment_heigth(type);
    hs = cable_chain_hook_spacing(type);
    _segments = is_undef(length) ? segments : cable_chain_generate_angles(type, length, turn_angle);
    angles = len(_segments) > 0 ? _segments : cable_chain_default_segments(type);
    total_segments = len(angles);

    module rotated_section(angles, segment = 0) {
        angle = angles[0];
        set_color = hs != 0 && segment % hs == 0 ? "green" : "white";

        rotate([angle, 0, 0])
            translate([0, l / 2, 0])
                cable_chain_section(type, color = set_color, hook = segment % hs == 0);

        if (len(angles) > 1) {
            remaining_angles = [for (a = [1 : len(angles) - 1]) angles[a]];
            rotate([angle, 0, 0])
                translate([0, l, 0])
                    rotated_section(remaining_angles, segment = segment + 1)
                    children();

        } else {
            children();
        }
    }


    rotated_section(angles, segment = 1)
    children();
}

