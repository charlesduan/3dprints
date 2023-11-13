/*
 * Bracket for Dell monitor VESA inset, allowing the VESA screws to attach to a
 * bracket larger than the inset.
 */
include <../lib/production.scad>
include <BOSL2/std.scad>

// Width of the inset area from side to side.
inset_width = 121.7;

// Depth of inset area.
inset_depth = 9;

// Offset distance from edge of inset to screw hole center.
hole_offset = 10.5;

// Diameter of screw hole.
hole_diam = 6;

// Extra distance beyond the hole to make the insert.
extra_width = 7;

// Minimum width of the insert.
min_width = 5;

// Rounding of the corners of the bracket.
corner_round = 5;

eps = 0.01;

difference() {
    // Body
    cuboid(
        [ inset_width, hole_offset + extra_width, inset_depth ],
        rounding = corner_round,
        edges = "Z",
        anchor = BACK
    );

    // Cut out middle
    cutout_width = hole_offset + extra_width - min_width;
    cuboid(
        [
            // Ensure that the cutout is at least min_width from the hole edge
            inset_width - 2 * hole_offset - hole_diam - 2 * min_width,
            // Double the cutout width for removal
            2 * cutout_width,
            inset_depth + 2 * eps
        ],
        rounding = cutout_width / 2,
        edges = "Z"
    );


    // Screw holes
    for (xoff = [ -1, 1 ]) {
        right(xoff * (inset_width / 2 - hole_offset)) fwd(extra_width) {
            cyl(d = hole_diam, h = inset_depth + 2 * eps);
        }
    }
}

