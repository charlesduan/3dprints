include <../lib/production.scad>
include <BOSL2/std.scad>
include <params.scad>

/*
 * Creates a corner element for a cable runner for a horizontal-running cable
 * that traverses an outside corner bend.
 */

// Size of the runner's legs along the x and y axes, respectively.
size = [ 30, 30 ];

// Inside radius of the corner bend of the channel where the cables go.
channel_r = 8;

// Relative positions of the nail holes, which will be placed along the y axis.
nail_holes = [ 0.5 ];


assert(channel_r <= xsec.y);

function out_size() = size + [ out_xsec().y, out_xsec().y ];

cable_path = round_corners(
    [ [ out_size().x, 0 ], [ 0, 0 ], [ 0, -out_size().y ] ],
    radius = channel_r + shell,
    closed = false
);

diff("hole", keep = "triangle") path_sweep2d(
    xflip(left(out_xsec().y, vert_xsec_path())), cable_path
) {
    translate([
        out_xsec().y, -out_size().y, out_xsec().x
    ]) ycopies(nail_holes * size.y) {
        zrot(-90) nail_triangle(d = 7, rounding = outer_round());
    }

}

