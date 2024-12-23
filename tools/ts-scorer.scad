/*
 * A scoring tool, in this case for making a tabula scalata.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Size of the card.
card_d = [ 150, 142 ];

// Distance between fold ridges.
fold_d = 5;

// Dimensions of the protrusion, in width x height.
outdent_d = [ 1.75, 1 ];

// Dimensions of the receiving indent, in width x height.
indent_d = [ 2, 1.75 ];

// Additional thickness of the top and bottom plates.
plate_thickness = 3;

// Reduction of the top dimensions to ensure fit. This is in total reduction,
// not per side.
margin_d = [ 1, 1 ];

// Rims around the corners of the bottom piece, where x is the rim thickness, y
// is the length of each side, and z is the thickness.
rim_d = [ 2, 8, 3 ];

eps = 0.01;

module outdent_shape(length) {
    down(eps) prismoid(
        size1 = [ outdent_d.x, length ],
        size2 = [ 0, length ],
        h = outdent_d.y + eps,
        anchor = BOTTOM
    );
}

module indent_shape(length) {
    tag("remove") up(eps) prismoid(
        size1 = [ 0, length ],
        size2 = [ indent_d.x, length + 2 * eps ],
        h = indent_d.y + eps,
        anchor = TOP
    );
}

// Top piece.
diff() {
    top_d = card_d - margin_d;
    cuboid(point3d(top_d, plate_thickness), anchor = BOTTOM) {

        // Align everything to the theoretical top left edge of the plate
        position(TOP + LEFT) left(margin_d.x / 2) {

            // Outdents
            xcopies(
                sp = fold_d, spacing = 2 * fold_d,
                l = top_d.x - fold_d
            ) outdent_shape(top_d.y);

            // Indents
            xcopies(
                sp = 2 * fold_d, spacing = 2 * fold_d,
                l = top_d.x - 2 * fold_d
            ) indent_shape(top_d.y + 2 * eps);
        }
        // Alignment handle on the left edge.
        handle_y = card_d.y - 2 * rim_d.y - margin_d.y;
        position(LEFT) right(eps) cuboid(
            [ margin_d.x + 2 * eps, handle_y, plate_thickness ],
            anchor = RIGHT
        ) position(BOTTOM + LEFT) right(eps) cuboid(
            [ rim_d.x, handle_y, plate_thickness + rim_d.z ],
            anchor = BOTTOM + RIGHT
        );

    }
}


// Bottom piece.
left(card_d.x + 20) diff() {
    tot_d = card_d + [ rim_d.x, 2 * rim_d.x ];
    tot_h = plate_thickness + rim_d.z;

    cuboid(point3d(tot_d, tot_h), anchor = BOTTOM) {

        // Relative to the top left corner of the card area
        position(TOP + LEFT) right(rim_d.x) down(rim_d.z) {
            tag("keep") xcopies(
                sp = 2 * fold_d, spacing = 2 * fold_d,
                l = card_d.x - 2 * fold_d - margin_d.x
            ) outdent_shape(card_d.y + 2 * eps);

            xcopies(
                sp = fold_d, spacing = 2 * fold_d,
                l = card_d.x - fold_d - margin_d.x
            ) indent_shape(card_d.y);
        }

        tag("remove") {
            // Card space
            position(TOP + RIGHT) up(eps) right(eps) cuboid(
                point3d(card_d + [ eps, 0 ], rim_d.z + eps),
                anchor = TOP + RIGHT
            );

            // Left slot; needs to be cleared two ways
            position(TOP + LEFT) up(eps) left(eps) {
                handle_y = card_d.y - 2 * rim_d.y;
                cuboid(
                    [ rim_d.x + eps, handle_y, tot_h + 2 * eps ],
                    anchor = TOP + LEFT
                );
                cuboid(
                    [ rim_d.x + 2 * eps, handle_y, rim_d.z + eps ],
                    anchor = TOP + LEFT
                );
            }

        }
    }
}
