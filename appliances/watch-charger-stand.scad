include <BOSL2/std.scad>
include <lib/production.scad>
include <lib/morescrews.scad>

// Platform dimensions.
platform = [ 100, 60, 10 ];

// Back dimensions.
wall_mount = [ 50, 10, 50 ];

// Size of cutout for USB plug.
usb_cutout = [ 20, 10 ];

// Charger inset dimensions.
charger_inset = [ 45, 29, 2 ];
charger_inset_rounding = 5;

// Screw cutout dimensions, [ shank diam, head diam, head depth ].
screw = [ 5, 9, 4 ];
screw_count = 2;

rounding = 2.5;
eps = 0.01;


difference() {
    union() {
        back(wall_mount.y) cuboid(
            platform + [0, wall_mount.y, 0],
            rounding = rounding,
            except = BACK,
            anchor = BOTTOM + BACK
        );
        cuboid(
            wall_mount + [ 0, 0, platform.z ],
            rounding = rounding,
            except = BACK,
            anchor = BOTTOM + FRONT
        );

    }

    down(eps) cuboid(
        [usb_cutout.x, usb_cutout.y, platform.z + 2 * eps],
        anchor = BOTTOM + BACK
    );

    translate([0, -(platform.y + usb_cutout.y) / 2, platform.z + eps]) {
        cuboid(
            charger_inset + [0, 0, eps],
            anchor = TOP,
            rounding = charger_inset_rounding,
            edges = "Z"
        );
    }

    for (i = [ 1:1:screw_count ]) {
        screw_hole(
            screw.x, screw.y, screw.z,
            dir = BACK,
            at = [ 0, 0, platform.z + i * wall_mount.z / (screw_count + 1) ]
        );
    }
}

