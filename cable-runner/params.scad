include <../lib/production.scad>
include <../lib/nails.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// The cross-section of the cable runner. x is the side-to-side width, y the
// outcropping from the wall.
xsec = [ 20, 10 ];

// The thickness of the runner.
shell = 0.6 * 3;

// Function for the outer cross-section.
function out_xsec() = xsec + [ 2 * shell, shell ];

// The inner rounding radius along the length of the runner.
inner_round = 1;

// The outer rounding radius is computed.
function outer_round() = inner_round + shell;

eps = 0.01;

// A path of the cross-section of the cable runner.
function xsec_path() = round_corners(
    path2d(unrounded_xsec_path_with_rounding()),
    radius = [ for (p = unrounded_xsec_path_with_rounding()) p.z ]
);
function unrounded_xsec_path_with_rounding() = [
    [ 0, 0, 0 ],
    [ 0, out_xsec().y, outer_round() ],
    [ out_xsec().x, out_xsec().y, outer_round() ],
    [ out_xsec().x, 0, 0 ],
    [ xsec.x + shell, 0, 0 ],
    [ xsec.x + shell, xsec.y, inner_round ],
    [ shell, xsec.y, inner_round ],
    [ shell, 0, 0 ]
];

// Cross-section path for vertically constructed pieces.
function vert_xsec_path() = [
    for (v = xsec_path()) [ v.y, v.x ]
];
