include <../lib/production.scad>
include <../lib/nails.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*
 * A plate that goes over a corner of a wall.
 */

// The angle of the corner, in degrees.
angle = 127;

// The length of each side of the wall to be covered (half the total length).
length = 45;

// Thickness of the cover.
shell = 0.6 * 6;

// Height of the cover.
height = 100;

// Height of connecting flange.
flange_height = 5;

is_top = false;
is_bottom = false;

// Roundness of corners. This cannot be larger than shell.
rounding = shell / 2.0;

// Offset of the nail holes from the edge of the plate.
nail_inset = 10;

assert(rounding < shell);

eps = 0.01;

slop = 0.2;

difference() {
    // (0, 0) is the wall corner, and one edge will be at (length, 0).

    // Wall-side corners
    corners = [ [ 0, 0 ], [ length, 0 ], [ length, shell ] ];
    rot_corners = rot(-angle, p = [ [ length, -shell ], [ length, 0 ] ]);

    // Rounded angle
    outer_angle_path = concat(
        [ corners[len(corners) - 1] ],
        arc(r = shell, start = 90, angle = 180 - angle),
        [ rot_corners[0] ]
    );

    // Outer path
    outer_path = deduplicate(path_join(
        paths = [ corners, outer_angle_path, rot_corners ],
        joint = rounding,
        k = 1,
        relocate = false,
        closed = false
    ));

    inner_path_1 = back(shell / 4.0, p = right(
        length / 3.0,
        p = rect([ length / 3.0, shell / 2.0 ], anchor = FRONT + LEFT)
    ));
    inner_path_2 = rot(-angle, p = yflip(p = inner_path_1));

    union() {
        // Main body
        linear_extrude(height) polygon(outer_path);

        if (!is_top) {
            up(height - eps) linear_extrude(flange_height + eps - slop) {
                polygon(inner_path_1);
                polygon(inner_path_2);
            }
        }
    }

    up(height - 0.5) {
        back_factor = shell * 2.7 / 4.0;
        right(length / 2) back(back_factor) rotate(180) nail_mask();
        rotate(360 - angle) right(length / 2) fwd(back_factor) nail_mask();
    }

    if (!is_bottom) {
        down(eps) linear_extrude(flange_height + eps) {
            offset(r = slop) {
                polygon(inner_path_1);
                polygon(inner_path_2);
            }
        }
    }
}
