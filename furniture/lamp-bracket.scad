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
ring_bot_d = [ 58, 0, 3.2 ];

// Total height of the bottom bracket (for providing insertion space). This can
// be made larger than necessary to provide extra maneuvering space.
ring_bot_total_h = 15;

// Overall width of the device. This must be greater than all the ring
// diameters.
outer_diam = ring_bot_d.x + 4;

// Space for the desk mount point. x is zero, y is the shell thickness, z the
// desk thickness.
bridge_d = [ 0, 0.6 * 6, 39 ];

// Dimensions of the mount sides. x is zero, y the lateral depth of the mount, z
// the shell thickness. the desk.
mount_d = [ 0, outer_diam, 0.6 * 6 ];

// Extra space for the mount. x is ignored, y is the lateral inset of the mount
// from the center of the desk, z is the extra height given to the mount.
extra_d = [ 0, 0, 10 ];


// Body rounding.
rounding = 2;

eps = 0.01;

function ring_tot_z() = ring_mid_d.z + ring_bot_d.z + extra_d.z;

function tot_z() = ring_tot_z() + bridge_d.z + mount_d.z;

diff() {
    up(ring_tot_z()) fwd(outer_diam / 2 + extra_d.y) offset_sweep(
        octagon(id = outer_diam, realign = true),
        h = tot_z(),
        top = os_chamfer(rounding),
        bottom = os_chamfer(rounding),
        anchor = TOP
    ) {
        position(TOP) cuboid(
            [ outer_diam, outer_diam / 2 + bridge_d.y + extra_d.y, tot_z() ],
            chamfer = rounding,
            anchor = TOP + FRONT
        );
        tag("remove") position(TOP) up(eps) linear_sweep(
            octagon(id = ring_mid_d.x, realign = true),
            h = ring_tot_z() + 2 * eps,
            anchor = TOP
        );
        tag("remove") position(TOP) down(ring_mid_d.z) linear_sweep(
            octagon(id = ring_bot_d.x, realign = true),
            h = ring_bot_d.z + extra_d.z + eps,
            anchor = TOP
        );
    }

    tag("remove") cuboid(
        [ outer_diam + 2 * eps, outer_diam + extra_d.y + eps, bridge_d.z ],
        anchor = TOP + BACK
    );

        /*
        */
}

