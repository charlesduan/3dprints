/*
 * USB drive case for Verbatim USB drive.
 */
include <BOSL2/std.scad>
include <lib/production.scad>

drive_sz = [11.6, 15.5, 1.7];
case_sz = [12.3, 35, 2.3];
front_shell = 0.8;
hole_diam = 5;

overhang_sz = [0.3, 0, 0.5];

eps = 0.01;

difference() {
    union() {
        cuboid(
            case_sz,
            rounding = case_sz.x / 2,
            edges = "Z", except = FRONT,
            anchor = FRONT + TOP
        );

        overhang_tot = overhang_sz + [
            (case_sz.x - drive_sz.x) / 2,
            drive_sz.y + 2 * front_shell,
            eps
        ];
        down(eps) {
            right(case_sz.x / 2) cuboid(
                overhang_tot, anchor = FRONT + BOTTOM + RIGHT
            );
            left(case_sz.x / 2) cuboid(
                overhang_tot, anchor = FRONT + BOTTOM + LEFT
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
