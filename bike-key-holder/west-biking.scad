include <../lib/production.scad>
include <BOSL2/std.scad>

/*
 * A frame for making a bike key compatible with a Keysmart holder.
 */

// The inset region of the key.
key_slot = [ 4.5, 2.9, 2.4 ];

// The flange region of the key.
key_flange = [ 6.15, 1.6, key_slot.z ];

// How much plastic to surround the key with. x is the width around the key, y
// the extra length beyond the key slot, and z the vertical shell.
shell = [ 0.6 * 3, 7, 0.25 * 3 ];

// Keysmart hole size.
hole_diam = 4.5;

// Horizontal shell around the hole.
hole_shell = 0.6 * 5;

// Size of the thumb pull. y is the pull width, x is the pull's total width, and
// z is the offset of the pull's edge from the hole center.
thumb_pull_d = [ 22, 7, 0 ];

eps = 0.01;

function half_height() = key_slot.z / 2 + shell.z;
function hole_edge() = hole_diam / 2 + hole_shell;

difference() {
    union() {

        // The keysmart holder area
        cyl(
            d = hole_diam + 2 * hole_shell,
            h = half_height(),
            anchor = BOTTOM
        );

        // The key holding area
        cuboid(
            [
                key_flange.x + 2 * shell.x, 
                key_slot.y + key_flange.y + shell.y + hole_edge(),
                half_height(),
            ],
            anchor = BOTTOM + BACK
        );

        // The thumb pull
        fwd(thumb_pull_d.z) cuboid(
            [ thumb_pull_d.x, thumb_pull_d.y, half_height() ],
            anchor = BOTTOM + BACK,
            rounding = half_height() / 2,
            except = TOP
        );
    }

    // Keysmart hole
    down(eps) cyl(
        d = hole_diam,
        h = key_slot.z + 2 * shell.z + 2 * eps,
        anchor = BOTTOM
    );

    fwd(hole_edge()) up(shell.z) {

        // Flange portion of the key holder hole
        cuboid(
            key_flange,
            anchor = BOTTOM + BACK
        );

        // Inset portion of the key holder hole
        cuboid(
            key_slot + [ 0, key_flange.y + eps, 0 ],
            anchor = BOTTOM + BACK
        );

        // Forward portion of the key holder hole
        fwd(key_slot.y + key_flange.y) cuboid(
            [ key_flange.x, shell.y + eps, key_flange.z ],
            anchor = BOTTOM + BACK
        );
    }
}
