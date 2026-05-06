/*
 * A clip for attaching a cable to the edge of a ceiling cove. The cove is
 * assumed to be a flat piece of lumber extending lengthwise across the wall
 * near the ceiling. The cable, clipped to the edge of the cove, serves also to
 * block lights placed on the cove.
 */

include <../lib/production.scad>
include <../BOSL2/std.scad>

// Thickness of the cove lumber.
cove_thickness = 19.2;

// Diameter of the cable.
cable_diam = 6.5;

// Thickness of the clip.
shell = 2;

// Length of the clip, in the direction parallel to the cove edge.
length = 30;

// Overall width of the clip, from cove edge toward the wall.
clip_width = 30;

// Edge rounding.
rounding = 0.5;

// Information about small prongs. x is offset from the end of the clip, y the
// offset from the top or bottom.
prong_pos = [ 4, 2 ];

// Size of the prong. x is the base width, y the height.
prong_size = [ 2, 1.5 ];

// Number of prongs per side.
num_prongs = 3;

eps = 0.01;

function cable_shell_r() = cable_diam / 2 + shell;

linear_extrude(length) diff() rect(
    [ clip_width + shell, cove_thickness + 2 * shell ],
    rounding = rounding,
    anchor = RIGHT
) {
    position(BACK + LEFT) back(cable_diam / 2 - shell) ellipse(
        r = cable_shell_r(),
        anchor = LEFT
    ) position(CENTER) {
        rect([ 2 * cable_shell_r(), cable_shell_r() ], anchor = TOP);
        tag("remove") {
            ellipse(d = cable_diam);
            rect([ cable_diam, cable_shell_r() + eps ], anchor = TOP);
        }
        // tag("keep") #ellipse(d = cable_diam);
    }
    tag("remove") position(RIGHT) right(eps) rect(
        [ clip_width + eps, cove_thickness ],
        anchor = RIGHT
    );
}

left(prong_pos.x) zcopies(
    sp = prong_pos.y, l = length - 2 * prong_pos.y, n = num_prongs
) {
    fwd(cove_thickness / 2 + eps) ycyl(
        d1 = prong_size.x, d2 = 0, h = prong_size.y + eps,
        anchor = FRONT
    );

    back(cove_thickness / 2 + eps) ycyl(
        d2 = prong_size.x, d1 = 0, h = prong_size.y + eps,
        anchor = BACK
    );
}

