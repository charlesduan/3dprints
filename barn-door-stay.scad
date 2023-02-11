include <BOSL2/std.scad>
include <lib/production.scad>
include <lib/morescrews.scad>

// Gap from wall to door
wall_gap = 45;

// Thickness of door
door_thickness = 20;

bottom_thickness = 4;
side_thickness = 6;

// Length of the stay body
length = 50;

// Extra space for door to move laterally
door_slop = 2;

screw_shank_diam = 5;
screw_head_diam = 9;
screw_head_height = 4;

screw_hole_height = length / 5;

max_screw_distance = 15;

rounding = 3;
eps = 0.01;

function total_width() = (
    wall_gap
    + door_thickness
    + door_slop / 2
    + side_thickness
);

//
// Bottom part. The origin is the center of the wall just above the bottom
// shell.
//
up(eps) bottom_half(2 * max(total_width(), length)) cuboid(
    [total_width(), length, 2 * (bottom_thickness + eps)],
    anchor = LEFT,
    rounding = rounding,
    edges = [BOTTOM, RIGHT],
    except = LEFT
);

right(total_width()) difference() {
    //
    // Outer stay
    //
    top_half(2 * max(length, side_thickness)) xcyl(
        l = side_thickness, d = length,
        rounding = rounding,
        anchor = RIGHT
    );

    // Hole for screw head
    translate([eps, 0, screw_hole_height]) xcyl(
        d = screw_head_diam, l = side_thickness + 2 * eps,
        anchor = RIGHT
    );
}

function inner_stay_width() = wall_gap - door_slop / 2;

difference() {
    //
    // Inner stay
    //
    top_half(2 * max(inner_stay_width(), length)) xcyl(
        l = inner_stay_width(), d = length,
        rounding2 = rounding,
        anchor = LEFT
    );

    screw_hole(
        shank_d = screw_shank_diam,
        head_d = screw_head_diam,
        countersink = screw_head_height,
        dir = LEFT,
        at = [
            min(max_screw_distance, eps + inner_stay_width()),
            0, screw_hole_height
        ]
    );

}
