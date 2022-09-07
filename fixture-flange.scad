/*
 * A wall flange for a wall fixture such as a towel holder.
 */

include <BOSL2/std.scad>
include <lib/morescrews.scad>
include <lib/production.scad>


// Width and height of the flange at its widest point (furthest from the wall).
outer_dimens = [21, 36];

// Width of the flange at its narrowest point (closest to the wall).
inner_dimens = [21, 29];

// Thickness of the flange.
thickness = 5;

// Screw dimensions
screw_shank = 4.5;
screw_head = 8.5;
screw_sink = 4;

// Thickness and height of wall side points to increase friction.
friction_dimens = [0.5, 0.6];

eps = 0.01;

difference() {
    union() {
        prismoid(
            size1 = outer_dimens,
            size2 = inner_dimens,
            h = thickness,
            anchor = TOP
        );
        down(eps) {
            prismoid(
                size1 = [0.75 * inner_dimens.x, friction_dimens[0]],
                size2 = [0.75 * inner_dimens.x, 0],
                h = friction_dimens[1] + eps,
                anchor = BOTTOM
            );
            prismoid(
                size1 = [friction_dimens[0], 0.75 * inner_dimens.y],
                size2 = [0, 0.75 * inner_dimens.y],
                h = friction_dimens[1] + eps,
                anchor = BOTTOM
            );
        }
    }
    screw_hole(
        screw_shank, screw_head, countersink = screw_sink
    );
}
