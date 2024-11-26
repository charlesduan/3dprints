/*
 * A closet rod hanger meant to hang in a bookshelf using shelf pins.
 */

include <BOSL2/std.scad>
include <lib/production.scad>

// Treating the pin as standing up on its bottom, the dimensions of the pin.
pin_d = [ 7.5, 3, 10 ];

rod_diam = 23;

pin_dist = 31.75;

// Thickness of the plastic between the shelf wall and the end of the rod
rod_wall_shell = 2;

// The wall surrounding the rod. x is the thickness; y the insertion depth.
rod_shell = [ 0.6 * 5, 20 ];

// Thickness of the wall around the pins.
pin_shell = 0.6 * [ 5, 5, 5 ];

// How far to drop the pin down to fit into the slot
pin_drop = pin_d.y;

eps = 0.01;

difference() {

    y_total = pin_d.y + pin_drop + pin_dist + 2 * pin_shell.y;
    union() {

        // Where the pins go
        cuboid(
            [ pin_d.x + 2 * pin_shell.x, y_total, pin_d.z + pin_shell.z ],
            rounding = min(pin_shell) / 2,
            except = BOTTOM,
            anchor = BOTTOM
        );

        // Rod holder
        cyl(
            d = rod_diam + 2 * rod_shell.x,
            h = rod_shell.y + rod_wall_shell,
            rounding2 = rod_wall_shell / 2,
            anchor = BOTTOM
        );
    }

    // Inside of rod
    up(rod_wall_shell) cyl(
        d = rod_diam,
        h = rod_shell.y + eps,
        anchor = BOTTOM
    );

    for (pin_top = [
            y_total / 2 - pin_shell.y,
            -y_total / 2 + pin_shell.y + pin_d.y + pin_drop
    ]) {

        // Pin holes. Anchor point is the back right bottom of the pins.
        translate([pin_d.x / 2, pin_top, -eps]) {

            // The hole where the pin itself sits
            cuboid(
                pin_d + [ 0, pin_drop, eps ],
                anchor = BOTTOM + BACK + RIGHT
            );

            // The hole for sliding the pin in
            fwd(pin_drop) cuboid(
                pin_d + [ pin_shell.x + rod_diam, 0, eps ],
                anchor = BOTTOM + BACK + RIGHT
            );
        }
    }

}
