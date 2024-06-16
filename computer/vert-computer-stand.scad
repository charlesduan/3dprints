/*
 * Stand for holding a computer device vertically.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// Dimensions of the cavity of the stand. x is the lateral width, y the
// thickness of the device to be held, and z the vertical height. Only y needs
// to be precise.
cavity_d = [ 140, 36, 80 ];

// Distance of the front (x) and back (y) horizontal flanges.
flange_depths = [ 40, 15 ];

// Shell thicknesses. x is ignored, y the thickness of the vertical arms, z the
// thickness of the horizontal flanges.
shell_d = [ 0, 0.6 * 5, 2 ];

// Rounding of the corners of the arms and flanges.
corner_round = 20;

// For cutting out the center of the holder, at least this much border will be
// left on the arms or flanges.
min_border = 30;

// Maximum size of the fillet pieces supporting the vertical arms.
max_fillet = 20;

eps = 0.01;

difference() {

    cut_x = cavity_d.x - 2 * min_border;
    cut_front_y = flange_depths[0] > min_border ?
        flange_depths[0] - min_border + shell_d.y : 0;
    cut_back_y = flange_depths[1] > min_border ?
        flange_depths[1] - min_border + shell_d.y : 0;
    cut_z = cavity_d.z - min_border;

    union() {

        // The vertical arms.
        cuboid(
            cavity_d + [ 0, 2 * shell_d.y, shell_d.z ],
            rounding = corner_round,
            edges = "Y",
            except = BOTTOM,
            anchor = BOTTOM + BACK
        );

        // The front flange.
        if (flange_depths[0] > 0) {
            fwd(cavity_d.y + 2 * shell_d.y - eps) cuboid(
                [ cavity_d.x, flange_depths[0] + eps, shell_d.z ],
                rounding = min(corner_round, flange_depths[0] / 2),
                edges = "Z",
                except = BACK,
                anchor = BOTTOM + BACK
            );

            // The fillet for the front flange.
            up(shell_d.z) fwd(cavity_d.y + 2 * shell_d.y) rounding_edge_mask(
                l = cavity_d.x,
                r = min(flange_depths[0] / 2, max_fillet),
                orient = RIGHT,
                spin = 180
            );

        }

        // The back flange.
        if (flange_depths[1] > 0) {
            fwd(eps) cuboid(
                [ cavity_d.x, flange_depths[1] + eps, shell_d.z ],
                rounding = min(corner_round, flange_depths[1] / 2),
                edges = "Z",
                except = FRONT,
                anchor = BOTTOM + FRONT
            );

            // The fillet for the back flange.
            up (shell_d.z) rounding_edge_mask(
                l = cavity_d.x,
                r = min(flange_depths[1] / 2, max_fillet),
                orient = LEFT
            );
        }


    }

    // The cavity for the device.
    up(shell_d.z) fwd(shell_d.y) cuboid(
        cavity_d + [ 2 * eps, 0, eps ],
        anchor = BOTTOM + BACK
    );

    // The cutout.
    if (cut_x > 0 && cut_z > 0) {
        down(eps) back(cut_back_y - shell_d.y) cuboid(
            [ cut_x, cut_back_y + cut_front_y + cavity_d.y, cut_z ],
            anchor = BOTTOM + BACK
        );
    }

}
