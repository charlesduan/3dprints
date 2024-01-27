/*
 * Bracket for mounting a Lampat LED desk lamp to an edge of a desk.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// In the below three, x is the diameter, y is ignored, z is the height.

// Dimensions of the inner ring of the bracket. 
ring_mid_d = [ 49.5, 0, 6 ];

// Dimensions of the top ring of the bracket (closest to the lamp).
ring_top_d = [ 56, 0, 3.4 ];

// Dimensions of the bottom ring of the bracket (furthest from the lamp).
ring_bot_d = [ 57.2, 0, 3.2 ];

// Total height of the bottom bracket (for providing insertion space). This can
// be made larger than necessary to provide extra maneuvering space.
ring_bot_total_h = 15;

// Space for the desk mount point.
mount_gap = 18;

// Overall width of the device. This must be greater than all the ring
// diameters.
outer_diam = 67;

// Dimensions of the mount sides. x is the lateral width that will span the
// desk, y the thickness of the mount sides, and z the vertical height against
// the desk.
mount_d = [ 77, 0.6 * 5, 50 ];


// Body rounding.
rounding = 2;

eps = 0.01;

function ring_tot_z() = ring_mid_d.z + ring_bot_d.z;

diff() {
    cyl(
        d = outer_diam,
        h = ring_tot_z(),
        chamfer = rounding,
        anchor = BOTTOM
    ) {
        position(TOP) cuboid(
            [ mount_d.x, 2 * mount_d.y + mount_gap, mount_d.z + ring_tot_z() ],
            chamfer = rounding,
            anchor = TOP
        );
        tag("remove") position(BOTTOM) cuboid(
            [ mount_d.x + 2 * eps, mount_gap, mount_d.z + eps ],
            anchor = TOP
        );
        tag("remove") position(BOTTOM) down(eps) cyl(
            h = ring_tot_z() + 2 * eps,
            d = ring_mid_d.x,
            anchor = BOTTOM
        );
        tag("remove") position(BOTTOM) up(ring_bot_d.z) cyl(
            d = ring_bot_d.x,
            h = ring_bot_d.z + ring_bot_total_h,
            anchor = TOP
        );
    }
}

