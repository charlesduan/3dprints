include <lib/production.scad>
include <BOSL2/std.scad>
include <lib/morescrews.scad>

// Dimensions of the charger's cutout
charger_cutout = [ 72, 32, 60 ];
charger_rounding = 2;

// How much not to cut out of the bottom sides
bottom_lip = [10, 3];

// Thickness of the casing
shell = 0.6 * 5;

// Screw cutout dimensions, [ shank diam, head diam, head depth ].
screw = [ 5, 9, 4 ];
screw_count = 2;

eps = 0.01;

difference() {
    back(shell) cuboid(
        charger_cutout + [2 * shell, 2 * shell, shell],
        rounding = charger_rounding + shell,
        teardrop = true,
        except = TOP,
        anchor = BACK + BOTTOM
    );
    up(shell) cuboid(
        charger_cutout + [ 0, 0, eps ],
        rounding = charger_rounding,
        except = TOP,
        anchor = BACK + BOTTOM
    );
    fwd(bottom_lip.y) down(eps) cuboid(
        [
            charger_cutout.x - 2 * bottom_lip.x,
            charger_cutout.y - 2 * bottom_lip.y,
            shell + 2 * eps
        ],
        rounding = -shell / 3,
        anchor = BACK + BOTTOM
    );
    for (i = [ 1:1:screw_count ]) {
        screw_hole(
            screw.x, screw.y, screw.z,
            dir = BACK,
            at = [ 0, 0, shell + i * charger_cutout.z / (screw_count + 1) ]
        );
    }
}
