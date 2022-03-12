/*
 * Rocket stand, upright.
 */

include <BOSL2/std.scad>

motor_diam = 13;
motor_height = 50;
motor_raise = 12;

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
        translate([0, motor_diam / 2 + motor_flange + eps, motor_raise + eps]) {
            cube([hook_gap + eps, hook_inset + motor_flange + eps,
                    hook_depth + eps], anchor = TOP + BACK);
        }
    }
}

motor();
