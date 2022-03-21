/*
 * Frame corners for hanging pictures
 */

include <BOSL2/std.scad>
include <lib/production.scad>

// Size of outer edge of the corner
side = 50;

// Shell thickness of sides, front, and back holder
shell = 1.8;

// Thickness of the material to be held
media_thickness = 5;

// Shell thickness of side on wall
wall_shell = 5;

// Extra space between the media and the wall shell. This should be large
// enough to accommodate a nail head.
extra_space = 10;

// Overhang on media. This is the inside width; the outside width will be this
// plus shell.
rabbet_width = 5;

// Diameter of the nail. No printer slop is added.
nail_diam = 2.5;


eps = 0.01;

function whole_height()
    = wall_shell + extra_space + 2 * shell + media_thickness;

module main_body() {
    difference() {
        intersection() {
            linear_extrude(whole_height()) {
                polygon([ [0, 0], [0, side], [side, 0] ]);
            }
            cuboid([2 * side, 2 * side, whole_height()], rounding = shell,
                    except = BOTTOM,
                    anchor = BOTTOM + LEFT + FRONT);
        }

        // Everything else is relative to the inside corner
        translate([shell, shell, wall_shell]) {

            // Frame window
            translate([rabbet_width, rabbet_width, 0]) {
                cube([side + eps, side + eps, whole_height()]);
            }

            // Extra space
            cube([side + eps, side + eps, extra_space]);

            // Media body
            up(extra_space + shell) {
                cube([side + eps, side + eps, media_thickness]);
            }
        }
    }
}

module nail_hole(entry_point, zrot, vert = true) {
    translate(entry_point) rotate([45, 0, zrot]) up(eps) {
        cylinder(h = whole_height() * sqrt(2) + eps, d = nail_diam,
                anchor = TOP + (vert ? BACK : FRONT));
    }
}

difference() {
    intersection() {
        cube(30, anchor = BOTTOM + LEFT + FRONT);
        main_body();
    }
    nail_hole([side / 2, 0, wall_shell + extra_space / 2], 0);
    nail_hole([0, side / 2, wall_shell + extra_space / 2], -90);
    nail_hole([side / 3, side / 1.75, wall_shell], 180, false);
    nail_hole([side / 1.75, side / 3, wall_shell], 90, false);
}
