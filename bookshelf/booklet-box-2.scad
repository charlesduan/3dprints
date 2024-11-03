include <../lib/production.scad>
include <../BOSL2/std.scad>

/*
 * A box for holding booklets on a bookshelf. This one has no diagonal strut so
 * it is simpler to print.
 */

// The maximum booklet size.
booklet = [ 150, 218 ];

// Width of books to hold.
width = 50;

// Front and back height, as fractions of booklet height.
height_fracs = [ 0.8, 3 * 25.4 ];

// Side shell.
side_shell = 0.6 * 3;

// Bottom shell.
bot_shell = 1.5;

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

// Calculates the total side length
function side_length() = (
    booklet.x + 2 * side_shell + label_thickness + label_shell
);

// Calculates total width including shell
function tot_width() = width + 2 * side_shell;


// Base and lower side
diff() cuboid(
    [ side_length(), tot_width(), bot_shell + margin ],
    rounding = edge_round,
    anchor = BOTTOM
) {
    // Length of each side
    short_side_length = margin + side_shell + label_thickness + label_shell;
    tall_side_length = margin + side_shell;
    position(BOTTOM + RIGHT) cuboid(
        [ short_side_length, tot_width(), side_height(1) ],
        rounding = edge_round,
        anchor = BOTTOM + RIGHT
    ) tag("remove") position(RIGHT + TOP) {
        right(eps) down(label_margin) cuboid(
            [
                label_shell + 2 * eps,
                width - 2 * label_margin,
                side_height(1) - bot_shell - 2 * label_margin
            ],
            anchor = TOP + RIGHT
        );
        up(eps) left(label_shell) cuboid(
            [ label_thickness, width, side_height(1) + eps ],
            anchor = TOP + RIGHT
        );
    }
    position(BOTTOM + LEFT) {
        cuboid(
            [ tall_side_length, tot_width(), side_height(0) ],
            rounding = edge_round,
            anchor = BOTTOM + LEFT
        );
        up(bot_shell) right(side_shell) tag("remove") cuboid(
            [ booklet.x, width, booklet.y ],
            anchor = BOTTOM + LEFT
        );
    }

}
