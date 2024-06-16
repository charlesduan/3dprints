include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*
 * A frame for a circular puzzle, with a small retaining rim.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>

diam = 158;
thickness = 5;

horiz_shell = 1.5;
vert_shell = 1;

// x is the extra overhang distance, y ignored, z the extra height of the
// overhang
overhang = [ 2, 0, 0.5 ];

rounding = 1;
in_rounding = 0.5;

function out_rad() = diam / 2 + horiz_shell;
function top_h() = vert_shell + thickness + overhang.x + overhang.z;

path_with_rounding = [
    [ 0, 0, 0 ],
    [ out_rad(), 0, rounding ],
    [ out_rad(), top_h(), rounding ],
    [ diam / 2 - overhang.x, top_h(), in_rounding ],
    [ diam / 2 - overhang.x, top_h() - overhang.z, 0 ],
    [ diam / 2, vert_shell + thickness, 0 ],
    [ diam / 2, vert_shell, 0 ],
    [ 0, vert_shell, 0 ]
];

path = round_corners(
    path2d(path_with_rounding),
    radius = [ for (p = path_with_rounding) p.z ]
);

rotate_sweep(path);
