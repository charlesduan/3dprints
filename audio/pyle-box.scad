include <../lib/production.scad>
include <../lib/morescrews.scad>
include <BOSL2/std.scad>

/*
 * A box for containing a Pyle outlet-style audio receiver. This design will
 * likely work for containing any appliance with a Decora switch.
 */


// The cutout for the switch body.
switch_cutout = [ 33, 66.5, 2.5 ];

// Rounding radius for the switch cutout.
cutout_round = 1;

// Distance between the mounting screws.
mount_screw_dist = 83.3;

// Diameter of the mounting screws.
mount_shank_d = 3.2;

// Dimensions of the mounting screw head, in diameter and thickness.
mount_head_d = [ 5.6, 3 ];

// Extra frame area around the cutout.
switch_frame = [ 5, 20, 60 ];

// Shell around the sides.
box_shell = 0.6 * 4;

// Rounding of the box.
box_round = 3;

// Screw parameters.
screw = [ 5, 9, 4 ];


eps = 0.01;

difference() {
    inside_d = [
        switch_cutout.x + 2 * switch_frame.x,
        switch_cutout.y + 2 * switch_frame.y,
        switch_frame.z
    ];

    outside_d = [
        inside_d.x + 2 * box_shell,
        inside_d.y + 2 * box_shell,
        inside_d.z + switch_cutout.z
    ];


    // The outer shell
    down(switch_cutout.z) cuboid(
        outside_d,
        rounding = box_round,
        anchor = BOTTOM
    );

    // The inside space
    cuboid(
        inside_d + [ 0, 0, eps ],
        rounding = max(0, box_round - box_shell),
        except = TOP,
        anchor = BOTTOM
    );

    // The front cutout
    up(eps) cuboid(
        switch_cutout + [ 0, 0, 2 * eps ],
        rounding = cutout_round,
        edges = "Z",
        anchor = TOP
    );

    down(switch_cutout.z + eps) {
        ycopies(spacing = mount_screw_dist, n = 2) {
            cyl(
                h = switch_cutout.z + 2 * eps,
                d = mount_shank_d,
                anchor = BOTTOM
            );
            cyl(
                h = min(switch_cutout.z - 0.5, mount_head_d.y) + eps,
                d = mount_head_d.x,
                anchor = BOTTOM
            );
        }
    }

    for (y = [ -1, 1 ]) {
        screw_hole(
            screw.x, screw.y, screw.z,
            dir = RIGHT,
            at = [ inside_d.x / 2 - 1, y * inside_d.y / 4, 17 ],
            head_l = 5
        );
    }

}
