/*
 * USB drive case for Verbatim USB drive.
 */
include <BOSL2/std.scad>
include <../lib/production.scad>

drive_sz = [11.6, 15.5, 1.7];
case_sz = [12.3, 35, 2.3];
front_shell = 0.8;
hole_diam = 5;

// Dimensions of the overhang. x is the lateral overlap of the sides, y the
// overlap of the back, z the thickness.
overhang_sz = [0.3, 2, 0.5];

eps = 0.01;

difference() {
    union() {

        // The main body. The circular part is effected by rounding.
        cuboid(
            case_sz,
            rounding = case_sz.x / 2,
            edges = "Z", except = FRONT,
            anchor = FRONT + TOP
        );

        overhang_tot = [
            (case_sz.x - drive_sz.x) / 2 + overhang_sz.x,
            drive_sz.y + 2 * front_shell,
            eps + overhang_sz.z
        ];
        down(eps) {
            // Side overhangs
            right(case_sz.x / 2) cuboid(
                overhang_tot, anchor = FRONT + BOTTOM + RIGHT
            );
            left(case_sz.x / 2) cuboid(
                overhang_tot, anchor = FRONT + BOTTOM + LEFT
            );

            back(overhang_tot.y) cuboid(
                [ case_sz.x, overhang_sz.y + front_shell, overhang_tot.z ],
                anchor = BACK + BOTTOM
            );

        }
    }
    up(eps) back(front_shell) {
        cuboid(drive_sz + [0, 0, eps], anchor = FRONT + TOP);
    }

    up(eps) back(case_sz.y - case_sz.x / 2) {
        cyl(d = hole_diam, h = case_sz.z + 2 * eps, anchor = TOP);
    }
    
}

layer_thickness = 0.05;

down(layer_thickness) back(drive_sz.y + 2 * front_shell) cuboid(
    [
        case_sz.x, overhang_sz.y + front_shell,
        overhang_sz.z + layer_thickness
    ],
    anchor = BACK + BOTTOM
);

