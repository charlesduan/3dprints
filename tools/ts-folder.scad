/*
 * Folds paper into an accordion shape.
 */

include <../lib/production.scad>
include <../BOSL2/std.scad>

// Distance between fold ridges.
fold_length = 7.4;

// Size of the card.
card_height = 100;

// Number of gear points.
gear_points = 10;

// Shift of the angle per point.
angle_shift = 10;

// Angle of the indents of the gear.
gear_angle = 120;

// Shell thickness for gear.
gear_shell = 10;

eps = 0.01;

function indent(coord, rot) = let(
    phi = 90 - gear_angle / 2
) move(coord, zrot(rot,
    [
        [0, 0],
        fold_length * [cos(phi), sin(phi)],
        [fold_length * 2 * cos(phi), 0]
    ]
));

function gear_arc() = [
    for (
        i = 0, pts = indent([0, 0], 0);
        i < gear_points;
        i = i + 1, pts = indent(pts[2], i * angle_shift)
    ) each pts
];

function add_base(pts, length) = let(
    last_pt = pts[len(pts) - 1],
    dir = zrot(90, unit(last_pt - pts[0]))
) [ pts[0] + length * dir, each pts, last_pt + length * dir ];

linear_extrude(card_height) polygon(add_base(gear_arc(), gear_shell));

