include <../lib/production.scad>
include <BOSL2/std.scad>

/*
 * A frame for making a bike key compatible with a Keysmart holder.
 */

// The dimensions of the key that will be surrounded by the key frame. x is the
// width, y the length to include, and z the thickness.
key_d = [ 6, 14, 2.4 ];

// The inset slot size. Dimensions are in the same direction as the key_d
// values.
slot_d = [ 2.7, 2.7 ];

// Distance of the slot from the back edge of the key.
slot_offset = 1.6;

// Rounding of the slot.
slot_rounding = 0.5;

// Keysmart hole size.
hole_diam = 4.5;

// Horizontal shell around the hole.
hole_shell = 0.6 * 5;

// How much plastic to surround the key with. x is the width around the key, y
// the separation between the hole and the key, and z the vertical shell.
shell = [ 0.6 * 3, 0.6 * 3, 0.25 * 3 ];

// Size of the thumb pull. y is the pull width, x is the pull's total width, and
// z is the offset of the pull's edge from the hole center.
thumb_pull_d = [ 22, 7, 0 ];

// Text for a label on the key thumb pull.
label_text = "J";
// How far to inset the label into the thumb pull.
label_depth = 0.75;
// Font for the label.
label_font = "Helvetica:style=Bold";

eps = 0.01;

// Half the height of the key holder.
function half_height() = key_d.z / 2 + shell.z;

// The edge of the hole, where the key should abut, plus a space of shell.y.
function hole_edge() = hole_diam / 2 + shell.y;

difference() {
    union() {

        // The keysmart holder area
        cyl(
            d = hole_diam + 2 * hole_shell,
            h = half_height(),
            anchor = BOTTOM
        );

        // The key holding area
        cuboid(
            [ key_d.x + 2 * shell.x, key_d.y + hole_edge(), half_height() ],
            anchor = BOTTOM + BACK
        );

        // The thumb pull
        fwd(thumb_pull_d.z) cuboid(
            [ thumb_pull_d.x, thumb_pull_d.y, half_height() ],
            anchor = BOTTOM + BACK,
            rounding = half_height() / 2,
            except = TOP
        );
    }

    // Keysmart hole
    down(eps) cyl(
        d = hole_diam,
        h = half_height() + 2 * eps,
        anchor = BOTTOM
    );

    // Text
    down(eps) linear_extrude(label_depth + eps) {
        font_size = 0.5 * thumb_pull_d.y;

        translate([
            thumb_pull_d.x / 2 - font_size / 2,
            -thumb_pull_d.z - thumb_pull_d.y / 2
        ]) xflip() text(
            label_text,
            font = label_font, size = font_size,
            valign = "center"
        );
    }

    // Space where the key sits
    fwd(hole_edge()) up(shell.z) difference() {

        // The overall key space
        cuboid(key_d + [ 0, eps, 0 ], anchor = BOTTOM + BACK);

        // The cutout in the center of the key.
        fwd(slot_offset) {
            cuboid(
                [ slot_d.x, slot_d.y, half_height() + eps ],
                rounding = slot_rounding,
                edges = "Z",
                anchor = BACK + BOTTOM
            );
        }
    }
}
