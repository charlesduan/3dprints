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
bottom_diam = 20;
rim_height = 5;
rim_seat = 5;

eps = 0.01;

function slope() = raise_height / (filter_diam - bottom_diam) * 2;

function cone_diam(h) = bottom_diam + h / slope() * 2;

function arm_width() = (cone_diam(bottom_thickness) / 2 + shell) * sqrt(3);
function arm_x() = filter_diam / 2 + arm_offset + arm_thickness / 2;
function arm_offset() = cone_diam(raise_height - arm_dip) / 2;

difference() {

    outer_diam = cone_diam(rim_height + raise_height) + 2 * shell;

    union() {
        // Outer cone
        cyl(d1 = bottom_diam + 2 * shell, d2 = outer_diam,
                h = rim_height + raise_height,
                anchor = BOTTOM,
                rounding2 = shell / 3);

        // Arm bridge
        cuboid([arm_x() - arm_offset(), arm_width(), bottom_thickness],
                anchor = BOTTOM + LEFT);
    }

    // Screw hole
    down(eps) cyl(d = screw_diam, h = bottom_thickness + 2 * eps,
            anchor = BOTTOM);

    // Cavity for portafilter
    up(rim_height + raise_height + eps) {
        cyl(d = filter_diam, h = rim_height + eps, anchor = TOP);
    }

    // Internal cavity
    up(bottom_thickness - eps) {
        cyl(d1 = cone_diam(bottom_thickness - eps),
                d2 = cone_diam(raise_height + eps),
                h = raise_height - bottom_thickness + 2 * eps,
                chamfer2 = rim_seat,
                chamfang2 = 45,
                anchor = BOTTOM);
    }

    up(bottom_thickness - eps) {
        pie_slice(ang = 120, spin = -60, r = outer_diam / 2 + eps,
                h = rim_height + raise_height - bottom_thickness + 2 * eps);
    }

}

// Everything is centered at the middle of the arm pillar
right(arm_x()) difference() {

    left(arm_offset()) difference() {
        intersection() {
            cyl(r1 = bottom_diam / 2 + shell,
                    r2 = cone_diam(raise_height) / 2 + shell,
                    h = raise_height,
                    anchor = BOTTOM);
            translate([-10, 0, -eps]) {
                cuboid([cone_diam(raise_height) + 2 * shell + eps,
                    arm_width(), raise_height + 2 * eps],
                    rounding = shell / 3,
                    edges = TOP,
                    anchor = BOTTOM + LEFT);
            }
        }
        translate([-arm_thickness, 0, bottom_thickness - eps]) {
            cyl(r1 = cone_diam(bottom_thickness) / 2 + shell,
                r2 = cone_diam(raise_height + eps) / 2 + shell,
                h = raise_height - bottom_thickness + 2 * eps,
                anchor = BOTTOM);
        }
    }
    up(raise_height - arm_dip) {
        rotate([0, 90, 0]) {
            cylinder(d = arm_diam, h = cone_diam(raise_height),
                    anchor = RIGHT);
        }
    }
}

