/*
 * A scoring tool, in this case for making a tabula scalata.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Size of the card.
card_len = 150;

// Distance between fold ridges.
fold_len = 7;

// Number of folds.
fold_num = 21;

// Dimensions of the protrusion, in point x width x height.
outdent_d = [ 0.6, 1.75, 1 ];

// Dimensions of the receiving indent, in point x width x height.
indent_d = [ 0.6, 2, 1.75 ];

// Additional thickness of the top and bottom plates.
plate_thickness = 4;

// Thickness of the rolling cylinder.
cyl_thickness = 5;

// Inner diameter of the rolling cylinder.
cyl_diam = 22;

// Size of margin at ends. Should be slightly larger than fold_len.
end_cap = 10;

// Reduction of the top dimensions to ensure fit. This is in total reduction,
// not per side.
margin_d = [ 1, 1 ];

// Rims around the corners of the bottom piece, where x is the rim thickness, y
// is the length of each side, and z is the thickness.
rim_d = [ 2, 8, cyl_thickness - 0.5 ];

eps = 0.01;

function dent(dims, up) = [
    [ -dims.y / 2, 0 ],
    [ -dims.x / 2, up * dims.z ],
    [ dims.x / 2, up * dims.z ],
    [ dims.y / 2, 0 ]
];

function outdent(x) = right(x, dent(outdent_d, 1));
function indent(x) = right(x, dent(indent_d, -1));

function dent_line(teeth, space_per_dent, in_first = true) = [
    for (i = [0 : 1 : teeth - 1])
    if ((i % 2 == 0) == in_first) each indent(space_per_dent * i)
    else each outdent(space_per_dent * i)
];

function tot_width() = 2 * end_cap + fold_len * (fold_num - 1);

function max_cyl_r() = cyl_diam / 2 + cyl_thickness + outdent_d.z;

module scoring_cylinder() {
    rotate_extrude() mirror([ 1, -1 ]) polygon(back(cyl_diam / 2, [
        [0, 0], [0, cyl_thickness],
        each back(
            cyl_thickness,
            right(end_cap, dent_line(fold_num, fold_len, true))
        ),
        [tot_width(), cyl_thickness], [tot_width(), 0],
    ]));
}


module base_plate() {
    back(eps) xrot(90) linear_extrude(card_len + eps) polygon([
        [ -rim_d.x, 0 ],
        [ -rim_d.x, plate_thickness + rim_d.z ],
        [ 0, plate_thickness + rim_d.z ],
        [ 0, plate_thickness ],
        each back(
            plate_thickness,
            right(end_cap, dent_line(fold_num, fold_len, false))
        ),
        [ tot_width(), plate_thickness ],
        [ tot_width(), plate_thickness + rim_d.z ],
        [ tot_width() + rim_d.x, plate_thickness + rim_d.z ],
        [ tot_width() + rim_d.x, 0 ],
    ]);
    left(rim_d.x) cuboid([
        tot_width() + 2 * rim_d.x, rim_d.x, plate_thickness + rim_d.z
    ], anchor = FRONT + BOTTOM + LEFT);
}

base_plate();
