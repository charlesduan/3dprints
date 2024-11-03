/*
 * Bracket for a vertical shelving standard, such as an Elfa standard.
 */

include <../lib/production.scad>
include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>


// Spacing between standard slots.
slot_spacing = 10.3;

// Dimensions of the slots. x is the width, y the height, z the thickness of the
// protrusion.
slot_d = [ 3.5, 19.5, 3 ];

// Width of the standard.
rail_out_d = [ 26, 29.5 ];

// Inside dimensions of the rail.
rail_in_d = [ 21, 26 ];

// Distance from the center of a slot to the spacing between slots. x is the top
// distance, y the bottom.
slot_sep = [ 11.5, 14 ];

// Thickness of the frame.
shell = 2;

// Rounding of the shell.
shell_rounding = 1;

// Whether to make a vertical or horizontal flange. This is set in other files.
// horiz_flange = false;

// Flange size. x is the horizontal size, y the vertical.
flange_size = [ 15, 15 ];

// Type of screw to use for the flange.
screw_struct = screw_info("#8", head = "flat");

eps = 0.01;

// Total slot-to-slot distance.
function tot_slot_sep() = slot_sep.x + slot_sep.y;

// Outer portion of the cover. It will be positioned as if the standard is lying
// flat along the Y axis, and the covering portion will be anchored with the Z
// axis where the wall would be and the Y axis at the top of the cover.
diff() cuboid(
    [
        rail_out_d.x + 2 * shell,
        tot_slot_sep() + (horiz_flange ? 0 : shell),
        rail_out_d.y + shell
    ],
    rounding = shell_rounding,
    except = BOT,
    anchor = BACK + BOT
) {

    // Remove the interior of the covering portion.
    position(BACK + BOT) back(eps) down(eps) tag("remove") cuboid(
        [
            rail_out_d.x,
            tot_slot_sep() + eps * (horiz_flange ? 2 : 1),
            rail_out_d.y + eps
        ],
        anchor = BACK + BOT
    );

    // Slot insertions.
    tag("keep") {
        position(BACK + TOP) fwd(slot_sep.x) down(shell - eps) {
            // The flange is a prismoid, with the ``base'' (actually the top)
            // having the slot_d dimensions and the ``top'' being inset at a
            // slope ratio from the top. The y axis difference is equal to
            // subtracting twice the flange thickness to create a 45 degree
            // angle overhang.
            xcopies(slot_spacing) prismoid(
                [ slot_d.x, slot_d.y - 2 * slot_d.z ],
                [ slot_d.x, slot_d.y ],
                h = slot_d.z,
                rounding = slot_d.x / 2 - eps,
                anchor = TOP
            );
        }
    }

    if (horiz_flange) {
        // Flange to the right
        position(RIGHT + BOT) left(shell_rounding) cuboid(
            [ flange_size.x + shell_rounding, tot_slot_sep(), shell ],
            rounding = shell_rounding,
            except = [ BOT, LEFT ],
            anchor = LEFT + BOT
        ) position(TOP) right(shell_rounding / 2) screw_hole(
            screw_struct, length = shell + 10, anchor = "head_top"
        );

        // Flange to the left
        position(LEFT + BOT) right(shell_rounding) cuboid(
            [ flange_size.x + shell_rounding, tot_slot_sep(), shell ],
            rounding = shell_rounding,
            except = [ BOT, RIGHT ],
            anchor = RIGHT + BOT
        ) position(TOP) left(shell_rounding / 2) screw_hole(
            screw_struct, length = shell + 10, anchor = "head_top"
        );

    } else {
        // Flange at bottom
        position(FRONT + BOT) back(shell_rounding) cuboid(
            [ rail_out_d.x + 2 * shell, flange_size.y + shell_rounding, shell ],
            rounding = shell_rounding,
            except = [ BOT, BACK ],
            anchor = BACK + BOT
        ) position (TOP) fwd(shell_rounding / 2) screw_hole(
            screw_struct, length = shell + 10, anchor = "head_top"
        );
    }
}
