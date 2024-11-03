/*
 * A pin for an Elfa solid shelf bracket, that fits into the bracket slot and
 * screws into the shelf from the underside.
 */

include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>
include <../lib/production.scad>

// Width of the inner channel of the bracket
channel_width = 9.5;

// Thickness of the sheet metal forming the bracket
steel_thickness = 1.2;

// Size of the slot for the bracket pin in [undef, depth, height]
pin_d = [ 0, 3.4, 3.7 ];

// Body dimensions. x is extension past the side of the bracket, y the depth
// parallel to the bracket, and z the height of the body.
body_d = [ 11, 11, 3 ];

// Rounding for body
body_round = 1;

// Details for screw to be inserted into the body.
screw_struct = screw_info("#8", "flat");

eps = 0.01;

function tot_x() = channel_width + 2 * steel_thickness + 2 * body_d.x;

function mp_to_mp_x() = channel_width + 2 * steel_thickness + body_d.x;

module screw_mount(anchor) {
    cuboid(
        body_d,
        rounding = body_round,
        except = BOT,
        anchor = anchor
    ) {
        position(TOP) screw_hole(
            screw_struct, l = body_d.z + 10,
            counterbore = pin_d.z,
            anchor = "head_top"
        );
    }
}

// Pin for bracket slot
diff() cuboid(
    [ mp_to_mp_x(), pin_d.y, pin_d.z - pin_d.y / 2 ],
    anchor = BOT
) {
    // Rounded part of bracket slot
    position(TOP) xcyl(h = mp_to_mp_x(), d = pin_d.y);

    position(BOT + LEFT) screw_mount(BOT);

    position(BOT + RIGHT) screw_mount(BOT);
}
