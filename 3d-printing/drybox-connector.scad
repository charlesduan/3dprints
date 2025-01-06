/*
 * A connector between a drybox and a filament tube.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/screws.scad>

tube_diam = 4.5;
filament_diam = 3;
screw_thread = "M6";
screw_l = 8;
stopper_l = 6;

eps = 0.01;

diff() screw(
    "M6", l = screw_l, head = "socket",
    thread_len = stopper_l - 0.5,
    anchor = BOTTOM + LEFT
) {
    tag("remove") position(BOTTOM) {
        down(eps) cyl(h = screw_l + 100, d = filament_diam, anchor = BOTTOM);
        up(stopper_l) cyl(h = screw_l + 100, d = tube_diam, anchor = BOTTOM);
    }
}

