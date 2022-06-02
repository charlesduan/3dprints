/*
 * Rocket stand, upright.
 */

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/tslot.scad>
include <lib/production.scad>
include <lib/tessellate.scad>

// C motor is 18, A motor is 13
motor_diam = 13;
motor_height = 30;
motor_shell = 1;

stem_diam = 10;
stem_extra = 20;

motor_flange = 1;
motor_flange_rad = 5;
hook_gap = 5;
hook_inset = 4;
hook_depth = 20;

eps = 0.01;

module motor() {

    up(stem_extra) motor_flange() {
        motor_insert(motor_height);
    }

}

module motor_insert(height) {
    eps = 0.01;
    chamfer = min([ motor_diam / 2 - eps, height / 4 - eps ]);
    // The motor insert part
    down(eps) intersection() {
        cyl(h = height + eps, d = motor_diam,
                chamfer2 = chamfer, anchor = BOTTOM);
        for (alpha = [45, 135]) {
            rotate(alpha) cube([motor_diam, motor_shell, height + eps],
                    anchor = BOTTOM);
        }
    }
}

// The flange upon which the motor sits.
module motor_flange() {
    main_h = motor_diam / 2 + motor_flange - stem_diam / 2;
    extra_h = motor_flange_rad * (sqrt(2) - 1);
    rc = round_corners([ [stem_diam / 2, -eps], [stem_diam / 2, extra_h],
            [motor_diam / 2 + motor_flange, main_h + extra_h] ],
            closed = false, radius = motor_flange_rad);
    difference() {

        // Flange
        union() {
            rotate_extrude() {
                polygon(concat(rc, [ [0, main_h + extra_h], [0, -eps] ]));
            }
            if (stem_extra > 0) {
                down(stem_extra + eps) {
                    linear_extrude(stem_extra + 2 * eps) circle(stem_diam / 2);
                }
            }
        }

        // Hook cutout
        translate([0, motor_diam / 2 + motor_flange + eps,
                main_h + extra_h + eps]) {

            cube([hook_gap + eps, hook_inset + motor_flange + eps,
                    hook_depth + eps], anchor = TOP + BACK);
        }
    }

    // Material above stand
    up(main_h + extra_h) children(0);
}


base_height = 15;
base_stem_height = 5;
base_diam = 30;
base_shell = 2;
base_fins = 3;
slot_thickness = 3;
slot_slop = 0.5;
slot_len = 8;

function fin_slot_height() = base_height - base_shell;
module fin_slot(height, slop = 0) {
    t_slot([slot_len, fin_width - slot_thickness, height],
            slot_thickness + slop);
}

module base(diam = base_diam, height = base_height, shell = base_shell,
        with_top = true) {

    fin_slot_height = height - shell;

    difference() {

        // Main body of base
        cyl(d = diam, h = height, anchor = BOTTOM,
                chamfer1 = base_shell / 3);

        // Cut out the fin slots
        for (i = [1 : base_fins]) {
            rotate(360 * i / base_fins) {
                translate([diam / 2, 0, -eps]) {
                    fin_slot(fin_slot_height + eps, slot_slop);
                }
            }
        }

    }

    // Taper up to the stem diameter
    if (with_top) up(height - eps) {
        rotate_extrude() {
            difference() {
                square([diam / 2, base_stem_height + eps]);
                translate([diam / 2, base_stem_height + eps]) {
                    scale([diam - stem_diam, 2 * base_stem_height]) {
                        circle(0.5, $fn = 180);
                    }
                }
            }
        }
    }

    // Put any children atop the base
    up(height + (with_top ? base_stem_height : 0)) children();
}

fin_length = 110;
fin_width = 8;
fin_skew = 10;
fin_foot = 10;
fin_shell = 1;
fin_infill_size = 5;

module fin_outer_polygon(fin_height) {
    polygon([ [0, 0], [0, fin_height],
            [fin_length, 1.75 * fin_shell - fin_skew],
            [fin_length, -fin_skew], [fin_length - fin_foot, -fin_skew]]);
}

module fin(diam) {
    fin_height = base_height;
    translate([0, 0, fin_width / 2]) {
        rotate([-90, 0, 0]) {
            fin_slot(fin_slot_height(), 0);
        }
    }
    difference() {
        linear_extrude(fin_width) fin_outer_polygon(fin_height);
        for (i = [0:1]) {
            up(i * (fin_width + fin_shell + 2 * eps) / 2 - eps) {
                linear_extrude((fin_width - fin_shell) / 2 + eps) {
                    offset(delta = -fin_shell) fin_outer_polygon(fin_height);
                }
            }
        }
    }

    // Slight cylindrical cutout
    difference() {
        left(diam / 2) cube([diam / 2 + eps, fin_height, fin_width]);
        translate([0, -eps, fin_width / 2]) {
            cylinder(d = diam, h = fin_height + 2 * eps,
                    anchor = BOTTOM + RIGHT, orient = BACK);
        }
    }
}

// Make the base
translate([0, -30, 0]) base() { motor(); }

// Test the T slots
// t_slot_test(slot_len, fin_width - slot_thickness, [ for (i = [-0.2:0.1:0.2]) slot_slop + i ]);

// Test the base for fit
// base(height = 5, shell = 0.5, with_top = false);

// Make the fins
for (i = [0 : 2]) translate([0, i * 30, 0]) fin(base_diam);

