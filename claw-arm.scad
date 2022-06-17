include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

path = [
    [7, 39, 0],
    [6, 25, 14],
    //[14, 20],
    [50, 0, 5],
    [98, 0, 12],
    [138, 41, 0],
    [154, 53, 2.9],
    [154, 56, 0],
    [127, 47, 0],
    [94, 10, 5],
    [61, 10, 0],
    // [43, 21],
    [39, 24, 4],
    [36, 21, 0],
];

cut_path = [
    [29, 10],
    [36, 21],
    [36, 50],
    [0, 50],
    [0, 10],
];

eps = 0.01;

thickness = 11.5;
bottom_gap = 3.5;
top_gap = 6;

difference() {
    up(thickness / 2) {
        rounded_prism([for (x = path) [x[0], x[1]]], height = thickness,
                joint_sides = [for (x = path) x[2]]);
    }
    down(eps) linear_extrude(bottom_gap + eps) polygon(cut_path);
    up(thickness - top_gap) linear_extrude(top_gap + eps) polygon(cut_path);
    translate([48, 8, -eps]) cylinder(d = 8, h = 12 + 2 * eps, anchor = BOTTOM);
}
