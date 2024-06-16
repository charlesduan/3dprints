include <../lib/production.scad>
include <BOSL2/std.scad>

/*
 * A frame for making a bike key compatible with a Keysmart holder.
 */

// The dimensions of the key that will be surrounded by the key frame. x is the
// key width, y the length to include, and z the thickness.
key_d = [ 6.6, 15, 3.0 ];

// The cutout region of the key. x is the amount cut out from each side, y the
// length of the cutout, z the distance from the end to the edge of the cutout.
cutout_d = [ 1.0, 3.5, 2.0 ];

// How much plastic to surround the key with. x is the width around the key, y
// the separation between the hole and the key, and z the vertical shell.
shell = [ 0.6 * 3, 0.6 * 3, 0.25 * 3 ];

// Keysmart hole size.
hole_diam = 4.5;

// Horizontal shell around the hole.
hole_shell = 0.6 * 5;

// Size of the thumb pull. y is the pull width, x is the pull's total width, and
// z is the offset of the pull's edge from the hole center.
thumb_pull_d = [ 22, 7, 0 ];

eps = 0.01;

function height() = key_d.z + 2 * shell.z;

// Half the height of the key holder.
function half_height() = key_d.z / 2 + shell.z;

// The edge of the hole, where the key should abut, plus a space of shell.y.
function hole_edge() = hole_diam / 2 + shell.y;

difference() {
    union() {

        // The keysmart holder area
        cyl(
            d = hole_diam + 2 * hole_shell,
            h = height(),
            anchor = BOTTOM
        );

        // The key holding area
        cuboid(
            [ key_d.x + 2 * shell.x, key_d.y + hole_edge(), height() ],
            anchor = BOTTOM + BACK
        );

        // The thumb pull
        fwd(thumb_pull_d.z) cuboid(
            [ thumb_pull_d.x, thumb_pull_d.y, height() ],
            anchor = BOTTOM + BACK,
            rounding = half_height() / 2
        );
    }

    // Keysmart hole
    down(eps) cyl(
        d = hole_diam,
        h = height() + 2 * eps,
        anchor = BOTTOM
    );

    // Space where the key sits
    fwd(hole_edge()) up(shell.z) difference() {

        // The overall key space
        cuboid(key_d + [ 0, eps, 0 ], anchor = BOTTOM + BACK);

        // The cutout portion from each side of the key space
        for (i = [ -1, 1 ]) {
            translate([ i * key_d.x / 2, -cutout_d.z ]) {
                scale([ cutout_d.x * 2, cutout_d.y, 1 ]) {
                    cyl(d = 1, h = key_d.z, anchor = BOTTOM + BACK);
                }
            }
        }

    }
}
