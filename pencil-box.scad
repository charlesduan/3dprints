$fa = 1;
$fs = 0.4;

width = 40;
length = 30;
height = 100;

cutout_rad = 10;
screw_height = cutout_rad / 2;
screw_rad = 4.5 / 2;

shell = 2;

eps = 0.01;

difference() {

    // Outer shell
    cube([width, length, height]);

    // Pencil cutout
    translate([shell, shell, shell]) {
        cube([width - 2 * shell, length - 2 * shell, height - shell + eps]);
    }

    // Screw hole
    translate([width / 2, length + eps, height - screw_height]) {
        rotate([90, 0, 0]) cylinder(shell + 2 * eps, r = screw_rad);
    }

    // Front cutout
    translate([width / 2, -eps, height]) {
        rotate([-90, 0, 0]) cylinder(shell + 2 * eps, r = cutout_rad);
    }

}
