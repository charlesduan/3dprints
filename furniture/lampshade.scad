/*
 * Lampshade for standing lamp.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>


// Height of the lampshade.
height = 150;

// Width of the bottom of the lampshade.
base_width = 170;

// Diameter of the hole at the top of the lampshade.
top_hole_width = 100;

// Thickness of the lampshade, measured horizontally.
shell = 2 * 0.6;

// Dimensions of the holder bracket. x is the inner diameter, y the outer
// diameter, z the thickness.
bracket_d = [ 36, 60, 2.5 ];

// Horizontal thickness of the support arms.
arm_w = 10;

// Number of arms.
arm_n = 3;

// Rounding for the main body
body_round = shell / 3;

// Rounding for the bracket
bracket_round = 1;

eps = 0.01;


rotate_extrude() polygon(round_corners([
    [ base_width / 2 - shell, 0 ],
    [ base_width / 2, 0 ],
    [ top_hole_width / 2 + shell, height ],
    [ top_hole_width / 2, height ]
], radius = body_round));

intersection() {
    cyl(
        h = height, 
        d1 = base_width - shell,
        d2 = top_hole_width + shell,
        anchor = BOTTOM
    );

    difference() {
        union() {
            rot_copies(n = arm_n) {
                cuboid(
                    [ base_width / 2, arm_w, bracket_d.z ],
                    rounding = bracket_round,
                    anchor = BOTTOM + LEFT
                );
            }
            cyl(
                d = bracket_d.y, h = bracket_d.z, rounding = bracket_round,
                anchor = BOTTOM
            );
        }
        down(eps) cyl(
            d = bracket_d.x, h = bracket_d.z + 2 * eps,
            rounding = -bracket_round,
            anchor = BOTTOM
        );
    }
}
