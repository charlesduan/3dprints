/*
 * Labeling tag for a woven storage bin.
 */
include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// x is the prong width, y the shell thickness, z the height.
prong_d = [ 20, 2, 20 ];

// Positions of the centers of the prongs.
prong_pos = [ -12, 40 ];

// x is the body width, y the shell thickness, z the height.
body_d = [ 120, 2, 20 ];

// x is ignored, y is the gap between prongs and body, z is the thickness.
bridge_d = [ 0, 2, 2 ];

// Rounding.
rounding = 0.75;

eps = 0.01;


cuboid(body_d, rounding = rounding, anchor = BOTTOM + BACK) {
    position(TOP + BACK) xcopies(spacing = prong_pos) {
        back(bridge_d.y) cuboid(
            prong_d, rounding = rounding, except = TOP + FRONT,
            anchor = TOP + FRONT
        );
        fwd(body_d.y / 2) cuboid(
            [ prong_d.x, (body_d.y + prong_d.y) / 2 + bridge_d.y, bridge_d.z ],
            rounding = rounding, edges = "Y",
            anchor = TOP + FRONT
        );
    }
}
