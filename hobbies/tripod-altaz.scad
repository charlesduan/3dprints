/*
 * Adapts a surveyor tripod to a telescope mount, in particular the Orion 7033
 * adapter.
 */

include <BOSL2/std.scad>
include <lib/morescrews.scad>
include <lib/production.scad>

/*
 * Overall dimensions of the adapter.
 */

// Diameter of the tripod opening.
ring_diam = 39.8;

// Distance that the ring will descend into the tripod.
ring_height = 8;

// Deepest that the tripod ring can go, inclusive of the screw head.
ring_max_height = 13;

// Atop the ring will be a flange that sits on top of the tripod.
flange_diam = 68;
flange_height = 12;

/*
 * Dimensions of the mount.
 */


// Size of the base cutout.
mount_dims = [ 45, 38.2, 4 ];

// Diameters of the holes in the mount.
small_hole_diam = 5;
large_hole_diam = 19;

//
// Distances from the mount edge to the small hole, from the small hole to the
// large hole, and the large hole to the other edge. The sum of these and the
// hole diameters must equal mount_dims.x.
//
hole_gaps = [ 6, 5, 10 ];

assert(mount_dims.x == small_hole_diam + large_hole_diam + sum(hole_gaps));


/*
 * Dimensions of the metal hardware.
 */

// Outer diameter of the screw (not the hole).
screw_diam = 6.1;

// Diameter of the screw head.
screw_head_diam = 11.7;

// Thickness of the screw head, just to check the ring depth.
screw_head_thickness = 4;

assert(ring_height + screw_head_thickness <= ring_max_height);

// Face-to-face diameter of the hex nut.
nut_diam = 23.7;

// Diameter of the screw thread (outer) that will fit in the nut.
nut_thread_diam = 15.5;

// Height of the nut.
nut_height = 13.9;

// How much extra space to give around the hardware and/or ring. This is a full
// diameter space (i.e., for a hole of 6mm, a hole of 7mm will be made).
slop = 0.5;

// Thickness of the adapter below the nut, for the nut to sit on.
nut_seat_thickness = 1.5;

// How high, relative to the bottom of the adapter, the mount will sit.
function mount_height() = ring_height + flange_height - mount_dims.z;

// Make sure the nut fully fits inside the mount.
assert(nut_seat_thickness + nut_height <= mount_height());

eps = 0.01;
chamfer = 1;
layer_height = 0.2;

// We want to distribute the nut and the screw within the tripod's inner ring to
// give equal space around the edges.
screw_nut_gap = 1;
function hardware_gap() =
    (ring_diam - nut_diam - screw_diam - screw_nut_gap - slop) / 2;

// There must be enough space between all the items.
assert(hardware_gap() >= slop);
assert(hardware_gap() >= (screw_head_diam - screw_diam) / 2);

// Determines where the centers of each of the hardware parts should be. The
// screw is assumed to be on the left, and element 0. Returns a two-element
// array.
function hardware_centers() = [
    -ring_diam / 2 + hardware_gap() + screw_diam / 2,
    ring_diam / 2 - hardware_gap() - nut_diam / 2
];
    

difference() {

    union() {
        // The body of the mount adapter: smaller ring inside the tripod.
        cyl(d = ring_diam - slop, h = ring_height + eps, anchor = BOTTOM,
                chamfer1=chamfer);

        // The body of the mount adapter: larger ring above the tripod.
        up(ring_height) {
            cyl(d = flange_diam, h = flange_height, anchor = BOTTOM,
                    chamfer = chamfer);
        }
    }

    // Hole for the nut.
    translate([hardware_centers()[1], 0, nut_seat_thickness]) {
        linear_extrude(mount_height() - nut_seat_thickness - layer_height) {
            rotate(360 / 12) hexagon(id = nut_diam + slop, anchor = CENTER);
        }
    }

    // Hole for the screw that fits in the nut.
    translate([hardware_centers()[1], 0, -eps]) {
        cylinder(
            d = nut_thread_diam + slop,
            h = nut_seat_thickness + eps - layer_height,
            anchor = BOTTOM
        );
    }

    // Hole for the screw.
    translate([hardware_centers()[0], 0, -eps]) {
        cylinder(
            d = screw_diam + slop,
            h = mount_height() + eps - layer_height,
            anchor = BOTTOM
        );
    }

    //
    // Compute where the cutout for the mount should go. We know that the mount
    // must align with the screw. Thus, the left edge of the mount will be the
    // center of the screw, shifted by (1) the radius of the mount's screw hole
    // plus (2) the distance between the screw hole and the mount edge.
    //
    mount_left_edge = hardware_centers()[0]
        - small_hole_diam / 2
        - hole_gaps[0];
    translate([mount_left_edge, 0, mount_height()]) {
        cube(mount_dims + [0, 0, eps], anchor = BOTTOM + LEFT);
    }
}
