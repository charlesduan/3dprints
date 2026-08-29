/*
 * A T shaped bracket for attaching acrylic or other sheets at a right angle to
 * a surface. This is intended as part of an enclosure for a 3d printer, where
 * the printer sits on a shelf and acrylic sheets are used to surround the
 * printer on the shelf.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>
include <../BOSL2/screws.scad>

// The thickness of the material being held. If the material is to be held
// tightly, then this number should be exactly the material thickness or
// slightly more. If the material is to slide through this bracket as in a
// sliding door, then the value should be substantially more than the material
// thickness.
sheet_thickness = 1.1;

// Depth into which the material will be inserted into the bracket.
insert_depth = 10;

// Amount by which the flange will pinch the material.
pinch = 0.15;

// Thickness of the flange arms.
shell = 1;

// Thickness of the top edge.
top_shell = 0.4;

// Dimensions of the base. x is the width perpendicular to the material held; y
// is the thickness.
base_d = [ 24, 1.5 ];

// Length of the bracket.
length = 150;

// Positions of screw holes in the material.
hole_pos = [ 15, 75, 135 ];

// Screw to be used in the holes.
screw_type = screw_info("#6", "flat");

function xsect_half() = [
    [ sheet_thickness / 2, 0 ],
    [ (sheet_thickness - pinch) / 2, 0.8 * insert_depth ],
    [ sheet_thickness / 2 + shell - top_shell, insert_depth ],
    [ sheet_thickness / 2 + shell, insert_depth ],
    [ sheet_thickness / 2 + shell, 0 ],
    [ base_d.x / 2, 0 ],
    [ base_d.x / 2, -base_d.y ]
];

function xsect() = concat(xsect_half(), reverse(xflip(xsect_half())));

difference() {
    yrot(90) zrot(90) linear_extrude(length) polygon(xsect());
    xcopies(hole_pos) {
        ycopies([
            (base_d.x + 2 * shell + sheet_thickness) / 4,
            -(base_d.x + 2 * shell + sheet_thickness) / 4
        ]) {
            down(base_d.y) screw_hole(
                screw_type, counterbore = base_d.y,
                length = 10 * base_d.y,
                hole_oversize = 0.3,
                anchor = "head_bot"
            );
        }
    }
}
