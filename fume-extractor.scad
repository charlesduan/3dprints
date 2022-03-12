//
// Fume extractor
//

include <BOSL2/std.scad>

eps = 0.01;
fan_body_width = 120;
filter_width = 117;
filter_length = 167;
filter_height = 30;

module fan_surface(nut_height, hole_height) {
    hole_distance  = 105 / 2;
    body_distance = fan_body_width / 2;
    inner_margin = 2.5;
    hole_diam = 4.3 + 1;
    nut_diam = 7.1 + 1.4;
    // The corner triangle circumscribes a square positioned at the corner of
    // the body such that the screw hole is in the center.
    corner_tri = (body_distance - hole_distance) * 4;
    difference() {
        linear_extrude(nut_height + hole_height) {
            difference() {
                union() {
                    // Body square
                    difference() {
                        square(fan_body_width, center = true);
                        square(fan_body_width - 2*inner_margin, center = true);
                    }
                    // Corner triangles
                    translate([body_distance, body_distance]) {
                        polygon([ [0, 0], [0, -corner_tri], [-corner_tri, 0] ]);
                    }
                    translate([-body_distance, body_distance]) {
                        polygon([ [0, 0], [0, -corner_tri], [corner_tri, 0] ]);
                    }
                    translate([body_distance, -body_distance]) {
                        polygon([ [0, 0], [0, corner_tri], [-corner_tri, 0] ]);
                    }
                    translate([-body_distance, -body_distance]) {
                        polygon([ [0, 0], [0, corner_tri], [corner_tri, 0] ]);
                    }
                }

                // Screw holes
                translate([hole_distance, hole_distance]) {
                    circle(d = hole_diam);
                }
                translate([-hole_distance, hole_distance]) {
                    circle(d = hole_diam);
                }
                translate([hole_distance, -hole_distance]) {
                    circle(d = hole_diam);
                }
                translate([-hole_distance, -hole_distance]) {
                    circle(d = hole_diam);
                }
            }
        }
        translate([hole_distance, hole_distance, hole_height]) {
            cylinder(h = nut_height + eps, d = nut_diam, $fn = 6);
        }
        translate([-hole_distance, hole_distance, hole_height]) {
            cylinder(h = nut_height + eps, d = nut_diam, $fn = 6);
        }
        translate([hole_distance, -hole_distance, hole_height]) {
            cylinder(h = nut_height + eps, d = nut_diam, $fn = 6);
        }
        translate([-hole_distance, -hole_distance, hole_height]) {
            cylinder(h = nut_height + eps, d = nut_diam, $fn = 6);
        }
    }
    translate([0, 0, hole_height + nut_height]) children();
}

module air_chamber(shell, slope = 1) {
    height = (filter_length - fan_body_width) / 2 * slope + 2 * eps;
    translate([0, 0, -eps]) difference() {
        prismoid([fan_body_width, fan_body_width],
                [filter_width + 2 * shell, filter_length + 2 * shell], height +
                2 * eps);
        translate([0, 0, -eps]) prismoid(
                [fan_body_width - 2 * shell, fan_body_width - 2 * shell],
                [filter_width, filter_length],
                height + 4 * eps);
    }
    translate([0, 0, height]) children();
}

module filter_box(shell, height_frac = 1) {
    translate([0, 0, -eps]) difference() {
        cube([filter_width + 2 * shell, filter_length + 2 * shell,
                filter_height * height_frac + eps], anchor=BOTTOM);
        translate([0, 0, -eps]) {
            cube([filter_width, filter_length,
                    filter_height * height_frac + 3 * eps], anchor=BOTTOM);
        }
    }
}

fan_surface(3, 1) {
    air_chamber(2, slope = 1) {
        filter_box(2, 0.5);
    }
}

