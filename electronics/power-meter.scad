/*
 * Box for a wired power meter.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>


// Size of the hole for the meter.
meter_d = [ 86.5, 46, 24.25 ];

// Corner rounding radius of the meter.
meter_corner_r = 3.5;

right_slot = [ 25.5, 1 ];

left_slot = [ 35.5, 1 ];

// Extra space around the width, height, and depth of the box. The x and y
// values are total (i.e., the border around the meter is half of x and y).
extra_d = [ 25, 25, 10 ];

// Thickness of the box walls.
box_shell = 1.5;

// Rounding of the box.
box_round = 3.5;

// Wire channel dimensions. x is the channel length, y the wire diameter.
wire_channel_d = [ 15, 7 ];

// Shell around the wire channel.
wire_shell = 1.5;

eps = 0.01;
slop = 0.1;

cap_flange_height = 3;

tab_d = [ 10, 1, 5 ];

module tab_piece(width, height, thickness, flange_size) {
    cuboid([ width, thickness, height ], anchor = BOTTOM + BACK) {
        position(TOP + BACK) xcyl(
            h = width, d = flange_size,
            anchor = TOP
        );
    }
}

module tab_hole(
        width, height, flange_size, remove_tag = "remove", slop = 0.1
) {
    tag(remove_tag) up(height - slop) xcyl(
        h = width + slop, d = flange_size + slop
    );
}

// Outside of the box.
function box_boundary_d() = meter_d + extra_d - [ 0, 0, box_shell ];

module box_boundary() {
    cuboid(
        box_boundary_d(),
        rounding = box_round,
        except = BOTTOM,
        anchor = BOTTOM
    ) {
        children();
    }
}

// Draw the outside of the box, then remove elements.
diff() box_boundary() {

    // Remove the interior of the box, other than the wire channel.
    tag_diff("remove", "channel") position(TOP) down(box_shell) cuboid(
        box_boundary_d() - [ 2 * box_shell, 2 * box_shell, box_shell - eps ],
        rounding = box_round - box_shell,
        except = BOTTOM,
        anchor = TOP
    ) {

        // The tab inserts.
        position(BOTTOM + BACK) up(eps) {
            left(box_boundary_d().x / 4) tab_hole(
                tab_d.x, tab_d.z, tab_d.y
            );
            right(box_boundary_d().x / 4) tab_hole(
                tab_d.x, tab_d.z, tab_d.y
            );
        }

        // More tab inserts.
        position(BOTTOM + FRONT) orient(UP, spin = 180) up(eps) {
            left(box_boundary_d().x / 4) tab_hole(
                tab_d.x, tab_d.z, tab_d.y
            );
            right(box_boundary_d().x / 4) tab_hole(
                tab_d.x, tab_d.z, tab_d.y
            );
        }

        // The inside hole of the wire channel; we "keep" it as part of the
        // material to be removed from the interior of the box.
        tag("keep") position(TOP + FRONT + RIGHT) translate([
            box_shell + eps, wire_channel_d.y / 2, -wire_channel_d.y / 2
        ]) xcyl(
            d = wire_channel_d.y, h = wire_channel_d.x + 2 * eps,
            anchor = RIGHT
        ) {
            // The outside of the wire channel. Any excess outside the exterior
            // of the box is irrelevant since we are effectively intersecting
            // this with the box exterior.
            tag("channel") position(CENTER) xcyl(
                d = wire_channel_d.y + 2 * wire_shell, h = wire_channel_d.x,
                anchor = CENTER
            );
        }
    }

    // The opening for the meter.
    tag("remove") position(TOP) up(eps) cuboid(
        meter_d, rounding = meter_corner_r, edges = "Z", anchor = TOP
    ) {

        // The side slots.
        position(TOP + LEFT) right(eps) cuboid(
            [ left_slot.y + eps, left_slot.x, meter_d.z ], anchor = TOP + RIGHT
        );
        position(TOP + RIGHT) left(eps) cuboid(
            [ right_slot.y + eps, right_slot.x, meter_d.z ], anchor = TOP + LEFT
        );
    }
}

// The cap.
// The surface of the cap.
back(1.2 * box_boundary_d().y) cuboid(
    [ box_boundary_d().x, box_boundary_d().y, box_shell ],
    rounding = box_round, edges = "Z",
    anchor = BOTTOM
) {
    // The inner flange of the cap.
    position(TOP) down(eps) diff() cuboid(
        [
            box_boundary_d().x - 2 * box_shell - 2 * slop,
            box_boundary_d().y - 2 * box_shell - 2 * slop,
            cap_flange_height + eps
        ],
        rounding = box_round - box_shell, edges = "Z",
        anchor = BOTTOM
    ) {
        // Tabs.
        position(BACK) {
            left(box_boundary_d().x / 4) tab_piece(
                tab_d.x, tab_d.z, box_shell, tab_d.y
            );
            right(box_boundary_d().x / 4) tab_piece(
                tab_d.x, tab_d.z, box_shell, tab_d.y
            );
        }

        // More tabs.
        position(FRONT) orient(UP, spin=180) {
            left(box_boundary_d().x / 4) tab_piece(
                tab_d.x, tab_d.z, box_shell, tab_d.y
            );
            right(box_boundary_d().x / 4) tab_piece(
                tab_d.x, tab_d.z, box_shell, tab_d.y
            );
        }

        // The interior of the cap flange, to be removed.
        tag("remove") position(BOTTOM) cuboid(
            [
                box_boundary_d().x - 4 * box_shell,
                box_boundary_d().y - 4 * box_shell,
                cap_flange_height + 2 * eps
            ],
            rounding = box_round - box_shell, edges = "Z",
            anchor = BOTTOM
        );
    }
}
