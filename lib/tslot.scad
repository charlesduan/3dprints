include <BOSL2/std.scad>

/*
 * A slot for a T-style sliding joint. The T will point in the positive x axis
 * direction, with dims being a three-element vector of the dimensions and
 * thickness defining the width of the arms. Along the main body of the T,
 * length extra will be added (a way of cutting out excess beyond the slot
 * itself).
 *
 * The length (dims.x) specifies the distance to the center of the T arms, not
 * the end. This way, a corresponding slot and insert can be made by altering
 * just the thickness values to account for printing slop.
 */
module t_slot(dims, thickness, extra = 0.01, insert = true) {
    right(extra) {
        cuboid([dims.x + extra, thickness, dims.z], anchor = BOTTOM + RIGHT);
    }
    left(dims.x) {
        cuboid([thickness, dims.y + thickness, dims.z],
                anchor = BOTTOM, chamfer = thickness / 4,
                edges = [ "Z" ]);
    }

}

/*
 * Creates test objects for measuring T slots. Parameters are the same as t_slot
 * other than slop, which defines the difference between the insert and the
 * slot.
 */
module t_slot_test(x, y, thickness, slop, height = 4, margin = 2) {

    outer_x = x + (thickness + max(slop)) / 2 + margin;
    outer_y = y + (thickness + max(slop)) + 2 * margin;
    eps = 0.01;

    // Regular insert
    union() {
        t_slot([ x, y, height ], thickness);
        cube([thickness / 2, outer_y, height], anchor = BOTTOM + LEFT);
    }

    // Vertical insert

    translate([0, outer_y / 2 + margin + height / 2, (y + thickness) / 2]) {
        rotate([90, 0, 0]) union() {
            t_slot([ x, y, height ], thickness);
            cube([thickness / 2, y + thickness, height],
                    anchor = BOTTOM + LEFT);
        }
    }

    // Regular slot
    for (s = [0 : len(slop) - 1]) {
        translate([outer_x + margin, s * (outer_y + margin)] ) difference() {
            cube([outer_x, outer_y, height], anchor = BOTTOM + RIGHT);
            down(eps) {
                t_slot([x, y, height + 2 * eps], thickness + slop[s]);
            }
        }
    }

}

