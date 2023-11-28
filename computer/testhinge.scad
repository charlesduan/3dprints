include <../lib/production.scad>
include <../lib/articulation.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*
s = hinge_struct();
d = struct_val(s, "d");

cuboid([ hinge_knuckle_width(s), d, 1 ]) position(TOP) hinge_knuckle(s);

back(10)
cuboid([ hinge_knuckle_width(s), d, 1 ]) position(TOP) hinge_knuckle(
    s, center = true
);
*/

wire_clip(d = 4, w = 20, extra_h = 0.75);
