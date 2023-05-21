include <lib/production.scad>
include <BOSL2/std.scad>

/*
 * A frame for making a bike key compatible with a Keysmart holder.
 */

// The inset region of the key.
key_slot = [ 4.5, 2.9, 2.5 ];

// The flange region of the key.
key_flange = [ 6.15, 1.6, key_slot.z ];

// How much plastic to surround the key with.
shell = [ 0.6 * 3, 0.6 * 5, 0.25 * 3 ];

// Keysmart hole size.
hole_diam = 4.5;

eps = 0.01;

difference() {
    back(hole_diam / 2 + shell.y) union() {

        // The keysmart holder area
        cyl(
            d = hole_diam + 2 * shell.y,
            h = key_slot.z + 2 * shell.z,
            anchor = BOTTOM
        );

        // The key holding area
        cuboid(
            [
                key_flange.x + 2 * shell.x, 
                key_slot.y + key_flange.y + shell.x + shell.y + hole_diam / 2,
                key_slot.z + 2 * shell.z
            ],
            anchor = BOTTOM + BACK
        );
    }

    // Keysmart hole
    back(hole_diam / 2 + shell.y) down(eps) cyl(
        d = hole_diam,
        h = key_slot.z + 2 * shell.z + 2 * eps,
        anchor = BOTTOM
    );

    up(shell.z) {

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
            [ key_flange.x, shell.x + eps, key_flange.z ],
            anchor = BOTTOM + BACK
        );
    }
}
