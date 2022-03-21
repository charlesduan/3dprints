/*
 * Rocket stand, upright.
 */

include <BOSL2/std.scad>
include <lib/tslot.scad>
include <lib/production.scad>

motor_diam = 18;
motor_height = 50;
motor_raise = 12;
motor_shell = 1;

stem_diam = 5;

motor_flange = 3;
hook_gap = 5;
hook_inset = 4;
hook_depth = 10;

eps = 0.01;

module motor() {

    // The raised pedestal must be at least the height of the flange
    assert(motor_raise > motor_flange);

    difference() {
        union() {

            // The part the rocket goes into plus the raised pedestal
            cyl(h = motor_height + motor_raise, d = motor_diam,
                    chamfer2 = motor_diam / 6, anchor = BOTTOM);

            // The flange the rocket sits on
            up(motor_raise) {
                cyl(h = motor_flange, d1 = motor_diam,
                        d2 = motor_diam + motor_flange * 2, anchor = TOP);
            }
        }
        // Hollow out the cylinder
        up(motor_raise + motor_shell) cylinder(h = motor_height + eps,
                d = motor_diam - 2 * motor_shell, anchor = BOTTOM);

        // Hook cutout
        translate([0, motor_diam / 2 + motor_flange + eps, motor_raise + eps]) {
            cube([hook_gap + eps, hook_inset + motor_flange + eps,
                    hook_depth + eps], anchor = TOP + BACK);
        }
    }
}

base_height = 10;
base_stem_height = 5;
base_diam = 20;
base_shell = 2;
base_fins = 3;
slot_thickness = 1.5;
slot_slop = 0.4;

function fin_slot_height() = base_height - base_shell;
module fin_slot(diam, height, slop = 0) {
    t_slot([diam / 4, fin_width - slot_thickness, height],
            slot_thickness + slop);
}

module base(diam) {
    difference() {
        cyl(d = diam, h = base_height, anchor = BOTTOM,
                chamfer1 = base_shell / 3);
        for (i = [1 : base_fins]) {
            rotate(360 * i / base_fins) {
                translate([diam / 2, 0, -eps]) {
                    fin_slot(diam, fin_slot_height() + eps, slot_slop);
                }
            }
        }
    }
    up(base_height - eps) {
        rotate_extrude() {
            difference() {
                square([diam / 2, base_stem_height + eps]);
                translate([diam / 2, base_stem_height + eps]) {
                    scale([diam - stem_diam / 2, 2 * base_stem_height]) {
                        circle(0.5, $fn = 180);
                    }
                }
            }
        }
    }
}

fin_height = 10;
fin_length = 50;
fin_width = 5;
fin_skew = 5;
fin_foot = 10;
fin_shell = 1;

module fin_outer_polygon() {
    polygon([ [0, 0], [0, fin_height],
            [fin_length, fin_shell - fin_skew],
            [fin_length, -fin_skew], [fin_length - fin_foot, -fin_skew]]);
}

module fin(diam) {
    translate([0, fin_height - fin_slot_height(), fin_width / 2]) {
        rotate([-90, 0, 0]) {
            fin_slot(diam, fin_slot_height(), 0);
        }
    }
    linear_extrude(fin_width) {
        difference() {
            fin_outer_polygon();
            offset(delta = -fin_shell) fin_outer_polygon();
        }
    }
    difference() {
        left(diam / 2) cube([diam / 2 + eps, fin_height, fin_width]);
        translate([0, -eps, fin_width / 2]) {
            cylinder(d = diam, h = fin_height + 2 * eps,
                    anchor = BOTTOM + RIGHT, orient = BACK);
        }
    }
}

//up(base_height) motor();
base(base_diam);
translate([0, 30, 0]) fin(base_diam);
