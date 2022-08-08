/*
 * Frame edges for hanging pictures
 */

// Set parameters in this file
include <frame-params.scad>

module edge_body(width, length) {

    // The body is a trapezoid of 45 degree angles. Thus, the top part of the
    // trapezoid is width - 2 * length. If the top edge of the trapezoid would
    // be negative, then a triangle is made to whatever height is allowed to
    // maintain a 45 degree angle, namely width / 2.
    difference() {
        linear_extrude(whole_height()) {
            if (width > 2 * length) {
                h = length; w2 = width - 2 * length;
                trapezoid(h = h, w1 = width, w2 = w2, anchor = FRONT);
            } else {
                h = width / 2; w2 = 0;
                trapezoid(h = h, w1 = width, w2 = w2, anchor = FRONT);
            }
        }
        up(whole_height()) {
            rounding_edge_mask(l = width, r = shell, orient = RIGHT);
        }


        translate([0, shell, wall_shell]) {
            cutouts(width, length, BOTTOM + FRONT);
        }
    }
}

difference() {
    edge_body(edge_width, side);
    nail_hole([0, 0, wall_shell + extra_space / 2], 0);
    nail_hole([0, side / 1.75, wall_shell], 180, false);
}
