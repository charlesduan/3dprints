/*
 * Chainring guard
 */

include <BOSL2/std.scad>
include <lib/production.scad>

// Bolt circle diameter
bcd = 130;

// Bolt diameter. Include printer slop
bolt_diam = 10.5;

// Outer bolt diameter. Include printer slop
bolt_flange_diam = 12.5;

// Thickness of the bolt flange.
bolt_flange_thickness = 1.01;

// Minimum margin between bolt hole edge and inner circle cutout
bolt_margin = 5;

// Crank cutout diameter. Include printer slop
crank_cutout_diam = 114.5;

// Number of teeth on largest chainring
teeth = 40;

// Distance from inside of chainring teeth to edge of guard. This must be at
// least the length of the teeth.
guard_margin = 8;

/*
 * Width of the solid guard ring, excluding the guard margin. The overall width
 * of the guard ring will be guard_margin + guard_width.
 */
guard_width = 8;

// Thickness of the chainring.
ring_thickness = 3.2;

// Additional thickness of the outer perimeter.
ring_edge_thickness = 3.01;

// Width of the additional outer perimeter.
ring_edge_width = 6;

// Gap to leave for the crank
crank_gap = 30;

// Edge rounding radius
edge_rounding = 1.5;

eps = 0.01;

function ring_diameter() = teeth * 0.5 * 25.4 / 3.14159 + 2 * guard_margin;

function ring_inner_diameter() = 
    ring_diameter() - 2 * (guard_margin + guard_width);

module foreach_hole() {
    for (i = [0 : 4]) {
        rotate(i * 360 / 5) children();
    }
}

// Main body
difference() {
    union() {

        // Overall body
        difference() {
            cyl(d = ring_diameter(), h = ring_thickness,
                    chamfer1 = edge_rounding, anchor = BOTTOM);
            down(eps) cyl(d = ring_inner_diameter(),
                    h = ring_thickness + 2 * eps,
                    rounding2 = -edge_rounding,
                    anchor = BOTTOM);
        }

        // Supports to bolt holes
        linear_extrude(ring_thickness) intersection() {
            circle(d = ring_inner_diameter() + 2 * edge_rounding + eps);
            foreach_hole() {
                offset(r = bolt_diam / 2 + bolt_margin) right(bcd / 2) {
                    regular_ngon(n = 3, id = (ring_diameter() - bcd) / 2,
                            anchor = "tip0", spin = 180);
                }
            }
        }

    }
    // Remove circle for crank spider
    down(eps) cyl(d = crank_cutout_diam, h = ring_thickness + 2 * eps,
            anchor = BOTTOM);

    // Remove the hole
    foreach_hole() {
        translate([bcd / 2, 0, -eps]) {
            cylinder(d = bolt_diam, h = ring_thickness + 2 * eps);
        }
        translate([bcd / 2, 0, ring_thickness + eps]) {
            cylinder(d = bolt_flange_diam,
                    h = bolt_flange_thickness + eps, anchor = TOP);
        }
    }
}

// Outer perimeter
up(ring_thickness - eps) difference() {
    edge_diam = ring_diameter() - ring_edge_width * 2;
    cyl(d = ring_diameter(), h = ring_edge_thickness + eps,
            rounding2 = edge_rounding, anchor = BOTTOM);
    down(eps) cyl(d = edge_diam, h = ring_edge_thickness + 3 * eps,
            rounding1 = edge_rounding,
            rounding2 = -edge_rounding, anchor = BOTTOM);
    cube([ring_diameter() / 2 + eps, crank_gap, ring_edge_thickness + 2 * eps],
            anchor = BOTTOM + RIGHT);

}
