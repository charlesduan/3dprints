/*
 * A holder for a sliding door, mounted on a surface parallel to the door. This
 * is intended as part of an enclosure for a 3d printer, where the printer sits
 * on a shelf and acrylic sheets are used to surround the printer on the shelf.
 * The other component is described in sheet-mount.scad.
 */

include <../BOSL2/std.scad>
include <../lib/production.scad>
include <../BOSL2/screws.scad>

// The thickness of the material being held.
sheet_thickness = 2;

// The depth into which the material will be inserted.
insert_depth = 20;

// The thickness of the flange.
shell = 2;

// Width of the track, in the direction perpendicular to the door motion.
track_width = 20;

// Length of the track.
length = 150;

// Positions of screw holes in the material.
hole_pos = [ 15, 75, 135 ];

// Screw to be used in the holes.
screw_type = screw_info("#6", "flat");

eps = 0.01;

difference() {
    cuboid(
        [ length, track_width + insert_depth, sheet_thickness + shell ],
        anchor = TOP + FRONT + LEFT
    );
    down(shell) fwd(eps) left(eps) cuboid(
        [ length + 2 * eps, insert_depth + eps, sheet_thickness + eps ],
        anchor = TOP + FRONT + LEFT
    );
    xcopies(hole_pos) {
        back(insert_depth + track_width / 2) {
            screw_hole(
                screw_type, counterbore = (sheet_thickness + shell) * 5,
                length = 10 * (sheet_thickness + shell),
                hole_oversize = 0.3,
                anchor = "head_top"
            );
        }
    }
}
