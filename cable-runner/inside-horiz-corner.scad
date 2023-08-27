include <../lib/production.scad>
include <BOSL2/std.scad>
include <params.scad>

/*
 * Creates a corner element for a cable runner for a horizontal-running cable
 * that traverses an inside corner bend.
 */

// Size of the runner's legs along the x and y axes, respectively.
size = [ 50, 100 ];

// Inside radius of the corner bend of the channel where the cables go
channel_r = 20;

// Cutoff for the wall corner.
wall_chamfer = 5;

// Relative positions of the nail holes, which will be placed along the y axis.
nail_holes = [ 0.3, 0.6 ];

union() {
    cable_path = round_corners(
        [ [ size.x, 0 ], [ 0, 0 ], [ 0, -size.y ] ],
        radius = channel_r + xsec.y,
        closed = false
    );

    diff("hole", keep="triangle") path_sweep(vert_xsec_path(), cable_path) {
        position(FRONT + LEFT + TOP) ycopies(nail_holes * size.y) {
            zrot(90) nail_triangle(d = 7, rounding = outer_round());
        }
    }

    zcopies(xsec.x + shell, 2, sp = 0) diff() cuboid(
        [ channel_r + xsec.y, channel_r + xsec.y, shell ],
        chamfer = wall_chamfer,
        edges = BACK + LEFT,
        anchor = BACK + LEFT + BOTTOM
    ) {
        tag("remove") position(FRONT + RIGHT) cyl(
            r = channel_r + xsec.y / 2,
            h = shell + 2 * eps,
            anchor = CENTER
        );
    }

}
