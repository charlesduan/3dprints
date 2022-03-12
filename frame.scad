include <BOSL2/std.scad>

$fa = 1;
$fs = 0.4;


width = 140;
length = 105;
slop = 1;
rabbet_width = 10;
rabbet_height = 8;
margin = 12;
shell = 2;
corner_round = 2;

corner_height = 2;
corner_width = 15;
corner_thickness = 1;

hanger_thickness = 3;
hanger_width = 40;

eps = 0.01;

module four_corners(w, l) {
    translate([-w / 2, -l / 2]) children();
    translate([-w / 2, l / 2]) rotate([0, 0, -90]) children();
    translate([w / 2, l / 2]) rotate([0, 0, 180]) children();
    translate([w / 2, -l / 2]) rotate([0, 0, 90]) children();
}

function side_thickness() = margin - rabbet_width;

assert(side_thickness() > 0);
assert(hanger_thickness + corner_height < rabbet_height);

difference() {

    // Outer surface
    down(shell) {
        cuboid([width + slop + 2 * side_thickness(),
                length + slop + 2 * side_thickness(),
                rabbet_height + shell], anchor = BOTTOM,
                chamfer = corner_round, except = TOP);
    }

    // Where the object itself goes
    cuboid([width + slop, length + slop, rabbet_height + eps],
            anchor = BOTTOM);

    // Frame window
    up(eps) {
        cuboid([width + slop - 2 * rabbet_width,
                length + slop - 2 * rabbet_width,
                shell + 2 * eps], anchor = TOP);
    }

}

// Corners
four_corners(width + slop + 2 * eps, length + slop + 2 * eps) {
    up(corner_height) {
        linear_extrude(corner_thickness) {
            polygon([ [0, 0], [corner_width + eps, 0],
                    [0, corner_width + eps] ]);
        }
    }
}

// Hanger
translate([0, (length + slop) / 2 + eps, rabbet_height]) {
    rotate([0, 90, 0]) {
        linear_extrude(hanger_width, center = true) {
            polygon([ [0, 0], [hanger_thickness + eps, 0],
                    [0, -hanger_thickness - eps] ]);
        }
    }
}
