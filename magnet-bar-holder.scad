include <lib/production.scad>
include <lib/morescrews.scad>
include <BOSL2/std.scad>

/*
 * A holder for a magnet bar.
 */

// Screw mounting position. x is how far out the screw hole will be, y the
// distance from the holder edge, z the thickness.
screw_mount_d = [ 5, 6, 4 ];

// How much extra material in the horizontal plane to surround the screw with.
screw_margin = 6;

bar_d = [ 12.5, (300 - 255) / 2 + screw_mount_d.y, 11.5 ];

shell = [ 0.6 * 3, 0.6 * 3, 0.25 * 5 ];

screw = [ 5, 9, 4 ];


eps = 0.01;

module holder() {

    difference() {
        union() {

            // Surroundings for bar
            cuboid(
                bar_d + 2 * shell - [ 0, shell.y, 0 ],
                anchor = FRONT + BOTTOM + RIGHT
            );

            // Screw mounting plate
            back(screw_mount_d.y) right(screw_mount_d.x) {
                cyl(
                    r = screw_margin,
                    h = screw_mount_d.z,
                    anchor = BOTTOM
                );
                cuboid(
                    [ screw_mount_d.x + eps, 2 * screw_margin, screw_mount_d.z ],
                    anchor = BOTTOM + RIGHT
                );
            }
        }

        // The bar itself
        up(shell.z) left(shell.x) fwd(eps) cuboid(
            bar_d + [ 0, eps, 0 ],
            anchor = FRONT + BOTTOM + RIGHT
        );

        // The screw hole
        screw_hole(
            screw.x, screw.y, screw.z,
            dir = DOWN,
            at = screw_mount_d
        );

    }

}

back(5) holder();

fwd(5) yflip() holder();
