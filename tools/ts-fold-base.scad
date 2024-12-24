include <../BOSL2/std.scad>
include <../lib/production.scad>


// Size of the card.
card_d = [ 150, 142 ];

// Distance between fold ridges.
fold_len = 5;

// Additional thickness of the top and bottom plates.
plate_thickness = 1;

// Fold angle.
fold_angle = 60;

// Additional side bearings, in [ thickness, extra height ].
side_d = [ 1.5, 5 ];

// Offset of the first valley.
first_offset = 1;

eps = 0.01;

difference() {

    horiz_factor = sin(fold_angle / 2);
    fold_height = fold_len * cos(fold_angle / 2) + side_d.y;

    down(plate_thickness) cuboid(
        [
            card_d.x * horiz_factor + first_offset,
            card_d.y + 2 * side_d.x,
            plate_thickness + fold_height
        ],
        anchor = BOTTOM + LEFT
    );

    xcopies(
        spacing = 2 * fold_len * horiz_factor,
        sp = first_offset,
        n = ceil(card_d.x / fold_len)
    ) prismoid(
        size1 = [ 0, card_d.y ],
        h = fold_height + eps,
        xang = 90 + fold_angle / 2,
        yang = 90,
        anchor = BOTTOM
    );

}
