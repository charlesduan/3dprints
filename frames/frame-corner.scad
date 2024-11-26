/*
 * Frame corners for hanging pictures
 */

// Set parameters in this file
include <frame-params.scad>

module corner_body() {
    difference() {
        intersection() {

            // Triangular prism
            linear_extrude(whole_height()) {
                polygon([ [0, 0], [0, side], [side, 0] ]);
            }

            // Round the corners
            cuboid([2 * side, 2 * side, whole_height()], rounding = shell,
                    except = BOTTOM,
                    anchor = BOTTOM + LEFT + FRONT);
        }

        // Everything else is relative to the inside corner
        translate([shell, shell, wall_shell]) {
            cutouts(side, side, BOTTOM + LEFT + FRONT);
        }
    }
}

difference() {
    corner_body();
    nail_hole([side / 2, 0, wall_shell + extra_space / 2], 0);
    nail_hole([0, side / 2, wall_shell + extra_space / 2], -90);
    nail_hole([side / 3, side / 1.75, wall_shell], 180, false);
    nail_hole([side / 1.75, side / 3, wall_shell], 90, false);
}
