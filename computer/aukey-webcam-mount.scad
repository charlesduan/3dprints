include <../lib/production.scad>
include <../lib/articulation.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*
 * Camera mount for Aukey webcam.
 */

// The mount connector is basically a spherical shell, which sits between the
// camera and a spherical ball joint. These two variables are the inner and
// outer diameters of the shell.
outer_d = 15.3;
inner_d = 12.9;

// The cutout from the shell allows the camera's freedom to move
cutout_d = 9.5;

// Center-to-side width of the camera.
bar_width = 50;

// Extra bar to the right of the mount (for holding while moving the camera).
bar_extra = 20;

// Thickness of the bar.
bar_thickness = 5;

// Rounding of the bar.
bar_chamfer = 0.3;

// Amount to raise the mount above the bar.
mount_raise = 5;

// Computes the length of a leg of a right triangle given the hypotenuse and
// other leg length.
function rt_leg(hypot, leg) = sqrt(hypot ^ 2 - leg ^ 2);

module mount(bot_chamfer = 0.5, extra_bottom = eps, cutout = false) {

    inner_shell_r = inner_d / 2 + bot_chamfer;
    inner_arc = arc(
        d = inner_d,
        angle = [ asin(bot_chamfer * 2 / inner_d), acos(cutout_d / inner_d) ]
    );
    outer_arc = reverse(arc(d = outer_d, angle = acos(cutout_d / inner_d)));
    arc_corner = [ inner_arc[len(inner_arc) - 1].x, outer_arc[0].y ];

    path = cutout ?
        concat(
            [
                [ 0, -extra_bottom - eps ],
                [ inner_shell_r, -extra_bottom - eps ],
                [ inner_shell_r, 0 ]
            ],
            inner_arc,
            [ arc_corner, [ 0, arc_corner.y ] ]
        )
        :
        concat(
            [
                [ outer_d / 2, -extra_bottom ],
                [ inner_shell_r, -extra_bottom ],
                [ inner_shell_r, 0 ]
            ],
            inner_arc,
            [ arc_corner ],
            outer_arc
        );
    rotate_sweep(path);
}

hs = struct_set(hinge_struct(), [
    "extra_h", bar_chamfer,
    "chamfer", bar_chamfer
]);

difference() {
    bar_tot_width = bar_width + bar_extra + hinge_knuckle_width(hs);
    right(bar_extra) cuboid(
        [ bar_tot_width, struct_val(hs, "d"), bar_thickness ],
        chamfer = bar_chamfer,
        anchor = TOP + RIGHT
    ) {
        position(LEFT + TOP) down(bar_chamfer) hinge_knuckle(
            hs, anchor = LEFT
        );
    }
    up(mount_raise) mount(
        extra_bottom = bar_thickness + mount_raise, cutout = true
    );
}
difference() {
    up(mount_raise) mount(extra_bottom = bar_thickness + mount_raise);
    down(bar_thickness) chamfer_cylinder_mask(
        d = outer_d, chamfer = bar_chamfer,
        orient = DOWN
    );
}

/************************************************************************
 *
 * Articulation arm.
 *
 ************************************************************************/

// Articulation arm length.
arm_l = 120;

// Diameter of the wire.
wire_d = 4;

eps = 0.01;

back(20) down(bar_thickness) cuboid(
    [ arm_l, hinge_knuckle_width(hs), struct_val(hs, "d") ],
    chamfer = bar_chamfer, edges = "X",
    anchor = BOTTOM
) {
    attach(RIGHT) hinge_knuckle(hs, center = true);
    attach(LEFT) hinge_knuckle(hs, center = true);
    attach(TOP) wire_clip(d = wire_d, w = arm_l * 0.8);
}

/************************************************************************
 *
 * Wall mount.
 *
 ************************************************************************/

// Extra space around the wall.
wall_surround = 5;

// Screw info.
wall_shell = 3;

diff() fwd(30) cuboid(
    [
        hinge_knuckle_width(hs) + 2 * wall_surround,
        struct_val(hs, "d") + 2 * wall_surround,
        wall_shell
    ],
    chamfer = bar_chamfer,
    except = BOTTOM
) {
    position(TOP) hinge_knuckle(hs);
    si = screw_info("#8", "flat");
    tag("remove") position(BOTTOM) screw_hole(
        si, counterbore = wall_shell,
        length = 2 * wall_shell + eps,
        hole_oversize = 0.3,
        anchor = "head_bot"
    );
}
