/*
 * General parameters for frame components. Make frame-corner.stl and
 * frame-edge.stl for the actual parts.
 */

include <BOSL2/std.scad>
include <lib/production.scad>
include <lib/nails.scad>


// Size of outer edge of the corner
side = 50;

// Width of an edge piece
edge_width = 80;


// Shell thickness of sides, front, and back holder
shell = 1.8;

// Thickness of the material to be held
media_thickness = 5;

// Shell thickness of side on wall
wall_shell = 5;

// Extra space between the media and the wall shell. This should be large
// enough to accommodate a nail head.
extra_space = 10;

// Overhang on media. This is the inside width; the outside width will be this
// plus shell.
rabbet_width = 5;

eps = 0.01;

// Total height of the frame part.
function whole_height() = (
        wall_shell + extra_space + 2 * shell + media_thickness
);

/*
 * Make the cutouts from the frame. The cutouts will be larger than width x
 * length, and anchored at the origin.
 */
module cutouts(width, length, anchor) {
    // Frame window
    translate([-rabbet_width * anchor.x, -rabbet_width * anchor.y, 0]) {
        cube([width + 2 * eps, length + 2 * eps, whole_height()],
                anchor = anchor);
    }
    // Extra space
    cube([width + 2 * eps, length + 2 * eps, extra_space],
            anchor = anchor);

    // Media body
    up(extra_space + shell) {
        cube([width + 2 * eps, length + 2 * eps, media_thickness],
                anchor = anchor);
    }
}

