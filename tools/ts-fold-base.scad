include <../BOSL2/std.scad>
include <../lib/production.scad>


// Size of the card.
//card_d = [ 154, 95 ];
card_height = 100;

// Distance between fold ridges.
fold_len = 7.4;

// Additional thickness of the top and bottom plates.
plate_thickness = 1.5;

// Fold angle.
fold_angle = 120;

// Number of folds.
fold_count = 20;

// Additional side bearings, in [ thickness, extra height ].
side_d = [ 1, 10 ];

eps = 0.01;

function fold_y() = fold_len * cos(fold_angle / 2);
function fold_x() = fold_len * sin(fold_angle / 2);
function tot_length() = fold_count * fold_x();

function zigzag() = [
    for (i = [ 0 : 1 : fold_count ])
    [ fold_x() * i, i % 2 == 0 ? 0 : fold_y() ]
];

back(eps) xrot(90) linear_extrude(card_height + eps) polygon(
    concat(back(plate_thickness, zigzag()), reverse(zigzag()))
);

ycopies(
    [ -card_height ]
) back(side_d.x) xrot(90) linear_extrude(side_d.x) polygon(
    concat(back(plate_thickness / 2, zigzag()), [[tot_length(), 0], [0, 0]])
);

cuboid(
    [ tot_length(), side_d.x, side_d.y + fold_y() ],
    anchor = FRONT + LEFT + BOTTOM
);
