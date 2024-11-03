include <../BOSL2/std.scad>
include <../BOSL2/rounding.scad>
include <../lib/production.scad>

/*
 * A box for holding booklets on a bookshelf.
 */

// The maximum booklet size.
booklet = [ 150, 218 ];

// Width of books to hold.
width = 50;

// Length of flat zone on the sides (toward the spine and outer edges of the
// booklets).
flat_length = 20;

// Front and back height, as fractions of booklet height.
height_fracs = [ 0.8, 3 * 25.4 ];

// Side shell.
side_shell = 0.6 * 3;

// Bottom shell.
bot_shell = 1.5;

// Rounding for the diagonal top corners of the holder. Must be less than the
// flat_length.
corner_round = 20;

// Rounding of all other edges.
edge_round = 1;

// Amount from the box sides (where the fronts and backs of the books will abut)
// that will not be removed by cutout.
margin = 25;

// Thickness of a label going in the front edge.
label_thickness = 1;

// Shell in front of label.
label_shell = 0.6 * 2;

// Margin around edge of label.
label_margin = 10;

eps = 0.01;

// Calculates the side height based on an index to height_fracs.
function side_height(idx) = bot_shell + (
    height_fracs[idx] >= 1 ? height_fracs[idx] : height_fracs[idx] * booklet.y
);

// Calculates the total side length.
function side_length() = booklet.x + 2 * side_shell
    + label_thickness + label_shell;

// Calculates the two top points defining the diagonal edge of the box.
function top_points() = [
    [ flat_length, side_height(0) ],
    [ booklet.x + 2 * side_shell - flat_length, side_height(1) ]
];

// Construct a path for the side of the box.
function side_path() = let(p = top_points()) round_corners(
    [
        [ 0, 0 ], [ 0, p[0].y ], p[0], p[1],
        [ side_length(), p[1].y ], [ side_length(), 0 ]
    ],
    r = [
        edge_round, edge_round, corner_round,
        corner_round, edge_round, edge_round
    ]
);

// Simplified polygon for the inside of the box.
function inside_polygon() = let(
    p = top_points(),

    // Box width ignoring label cutout
    right_x = booklet.x + 2 * side_shell,

    // We extend the diagonal top edge to the side of the box (ignoring the
    // label area).
    right_point = line_intersection(p, [ [ right_x, 0 ], [ right_x, 1 ] ]),
    right_line = right_point.y >= 0 ? [ right_point, [ right_point.x, 0 ] ]
        : [ line_intersection(p, [ [ 0, 0 ], [ 1, 0 ] ]) ]

) concat(
    [ [ 0, 0 ], [ 0, p[0].y ], p[0] ], right_line
);

difference() {
    offset_sweep(
        side_path(), h = width + 2 * side_shell, r = edge_round,
        orient = FRONT
    );

    translate([ side_shell, -side_shell, bot_shell ]) cuboid(
        [ booklet.x, width, booklet.y ],
        anchor = BACK + LEFT + BOTTOM
    );
    back(eps) xrot(90) linear_extrude(width + 2 * side_shell + 2 * eps) {
        offset(-margin) polygon(inside_polygon());
    }

    // Label insert area
    translate([ side_length() - label_shell, -side_shell, bot_shell ]) cuboid(
        [ label_thickness, width, side_height(1) + eps ],
        anchor = BOTTOM + BACK + RIGHT
    );

    // Label window
    translate([
        side_length() + eps,
        -side_shell - label_margin,
        bot_shell + label_margin
    ]) cuboid(
        [
            label_shell + 2 * eps,
            width - 2 * label_margin,
            side_height(1) - bot_shell - 2 * label_margin,
        ],
        anchor = BOTTOM + BACK + RIGHT
    );

}
