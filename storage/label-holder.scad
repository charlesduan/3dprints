include <BOSL2/std.scad>
include <lib/production.scad>

// Dimensions of the card, in width x height x thickness.
card_dim = [ 5 * 25.4, 1.5 * 25.4, 0.5 ];

// Slop to add around the sides of the card, total for both sides.
card_slop = 1.2;

// Overhang of the holder over the card edges. This is for each side.
overhang = 5;

// Slope of the insertion slot.
slot_slope = 0.75;

// Thickness of the holder.
shell = 1.5;

// Rounding length.
rounding = 1.0;

eps = 0.01;


difference() {

    // Outside of box.
    cuboid(
        card_dim + [card_slop, card_slop, 0] + 2 * [shell, shell, shell],
        rounding = rounding,
        anchor = TOP + RIGHT
    );

    // Card inset.
    down(shell) left(shell) cuboid(
        card_dim + [card_slop, card_slop, 0],
        anchor = TOP + RIGHT
    );

    // Top window.
    up(eps) left(shell + overhang) cuboid(
        card_dim + [-2 * overhang, -2 * overhang, shell],
        rounding = -rounding, edges = TOP,
        anchor = TOP + RIGHT
    );

    slot_width = card_dim.z / slot_slope;

    // Angled insert slot.
    down(shell) left(slot_width) {
        skew(szx = slot_slope) cuboid(
            [slot_width + eps, card_dim.y + card_slop, card_dim.z],
            anchor = TOP + LEFT
        );
        extra_width = shell + 2 * eps - slot_width;
        if (extra_width > 0) {
            right(eps) cube(
                [extra_width, card_dim.y + card_slop, card_dim.z],
                anchor = TOP + RIGHT
            );
        }
    }
}
