include <BOSL2/std.scad>
include <lib/production.scad>

raise_height = 35;
screw_diam = 5.3;

filter_diam = 61;

neck_diam = 21;

arm_dip = 8;
arm_diam = 23;
arm_offset = 25;
arm_thickness = 7;

shell = 3;
bottom_thickness = 3;
rim_height = 10;
rim_seat = 5;

eps = 0.01;

difference() {

    union() {
        // Outer cylinder of support
        cyl(d = filter_diam + 2 * shell, h = raise_height + rim_height,
                chamfer = shell / 3,
                anchor = BOTTOM);

        // Arm base
        cuboid([filter_diam / 2 + arm_offset + arm_thickness,
                arm_diam + 2 * shell, bottom_thickness],
                chamfer = shell / 3,
                anchor = BOTTOM + LEFT);
    }

    // Cavity for filter
    up(raise_height) {
        cylinder(d = filter_diam, h = rim_height + eps, anchor = BOTTOM);
    }

    // Screw hole
    down(eps) {
        cylinder(d = screw_diam, h = bottom_thickness + 2 * eps);
    }

    up(bottom_thickness) {

        rhmbtpe = raise_height - bottom_thickness + eps;

        // Cavity below filter
        cyl(d = filter_diam, h = rhmbtpe, chamfer2 = rim_seat + eps,
                anchor = BOTTOM);

        // Handle region cutout
        cuboid([filter_diam, neck_diam, rhmbtpe + rim_height],
                chamfer = -shell / 3, edges = TOP,
                anchor = BOTTOM + LEFT);
    }

}

// Everything is centered at the middle of the arm pillar
right(filter_diam / 2 + arm_offset + arm_thickness / 2) {

    difference() {
        // Arm pillar
        up(bottom_thickness / 2) {
            cuboid([arm_thickness, arm_diam + 2 * shell,
                    raise_height - bottom_thickness / 2],
                    anchor = BOTTOM,
                    chamfer = shell / 3, except = BOTTOM);
        }
        up(raise_height - arm_dip) {
            rotate([0, 90, 0]) {
                cylinder(d = arm_diam, h = arm_thickness + 2 * eps,
                        anchor = RIGHT);
            }
        }
    }
}
