include <../lib/production.scad>
include <../BOSL2/std.scad>

/*
 * A lamp shade for a hanging lamp.
 */

// Inner diameter of the fitter ring. This is standard 40mm (about 1 5/8
// inches).
fitter_id = 40;

// Thickness of the base.
base_thickness = 2;

// Width of the base.
base_width = 80;

// Exit angle from the base. 0 would be parallel to the base, while 90 would be
// straight down.
base_angle = 70;

// Opening dimensions. x is the (external) radius of the opening, y the vertical
// height of the lamp.
opening_d = [ 45, 120 ];

// Side thickness.
shell = 0.6;

eps = 0.01;


rotate_extrude() difference() {

    // We want to compute the center of a circle that exits the base edge at
    // the given angle, and then passes through the opening edge. To do so,
    // we focus on the chord between the two edges.

    // Base edge point.
    base_edge = [ base_width / 2, 0 ];

    // Chord midpoint.
    chord_midpoint = lerp(base_edge, opening_d, 0.5);

    // A point on the perpendicular bisector of the chord. We take the chord
    // as a vector, rotate it by 90 degrees, and add it to the chord midpoint.
    perp_bisector = chord_midpoint + [
        -opening_d.y, opening_d.x - base_edge.x
    ];

    // A point on the radius line of the base point. We take the base angle
    // (which is tangent to the circle), add 90 to be perpendicular to the
    // circle, and then take the tangent of that angle to get a y axis delta,
    // which we can add to the base edge (while adding 1 to the x axis).
    base_rad_point = base_edge + [ 1, tan(base_angle + 90) ];

    // The center of the circle must be on the radius line, and also on the
    // chord's perpendicular bisector. So the intersection between those lines
    // is the center of the circle.
    circ_center = line_intersection(
        [ chord_midpoint, perp_bisector ],
        [ base_edge, base_rad_point ]
    );


    // The outer shell is constructed based on an arc with circ_center as the
    // center, and base_edge and opening_d as the endpoints.
    polygon(concat(
        [ [ 0, 0 ] ],
        arc(cp = circ_center, points = [ base_edge, opening_d ]),
        [ [ 0, opening_d.y ] ]
    ));

    // Remove the inner ring area.
    fwd(eps) left(eps) rect(
        [ fitter_id / 2 + eps, base_thickness + 2 * eps ],
        anchor = FRONT + LEFT
    );

    // Remove the inner part of the lamp holder.
    difference() {

        // The inner shell radius is the distance between the circ_center and
        // either edge point, minus the shell.
        inner_r = norm(base_edge - circ_center) - shell;

        // Make a complete semicircle centered at circ_center.
        polygon(arc(r = inner_r, cp = circ_center, angle = [ -90, 90 ]));

        // Cut off everything in negative x
        back(circ_center.y) left(eps) rect(
            [ 2 * inner_r + eps, 2 * inner_r + eps ],
            anchor = RIGHT
        );

        // Cut off the base thickness (which, since this shape is being
        // differenced, will result in retention of the base thickness).
        fwd(eps) left(eps) rect(
            [ 2 * inner_r + eps, base_thickness + eps ],
            anchor = FRONT + LEFT
        );
    }
}
