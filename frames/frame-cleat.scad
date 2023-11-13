include <../lib/production.scad>
include <BOSL2/std.scad>
include <../lib/nails.scad>

/*
 * A cleat for holding a picture frame, where the frame has a horizontal slot
 * parallel to the frame border into which the cleat may be inserted.
 */


// List of points defining the side profile of the cleat. The x coordinate is
// distance from the wall, and the y coordinate is vertical height. The origin
// represents the wall edge where the cleat should start, and should be the
// first point of the list. The last point should have a y coordinate of 0.

cross_sec = [
    // These are for the white frames with a notch in them
    [ 0, 0 ], [ 2.8, 0 ], [ 2.8, 3 ], [ 5.6, 3 ], [ 5.6, 0 ], [ 7, 0 ]

    // This is for the frame.scad frame with a French cleat
    // [0, 0], [3, 3], [4, 3], [4, 0]
];

// Dimensions of the body, ignoring the side profile. x is the width of the
// cleat parallel to the top edge, y the thickness of the cleat (should be equal
// to the maximum x value of the cross-section), and z the height of the cleat
// body.
//
// The y coordinate is typically the last x coordinate of cross_sec.
cleat_d = [ 30, cross_sec[len(cross_sec) - 1].x, 14 ];

// Positions of the nail holes. Values should be between -0.5 and 0.5, and are
// relative to cleat_d.x.
nail_holes = [ 0 ];

// y is how far from the wall to place the nail hole; z is how far down from the
// top corner.
nail_offset = [0, cleat_d.y - 2, 2];

eps = 0.01;

diff("hole", keep = "triangle") linear_sweep(
    concat(
        [ [ 0, -cleat_d.z ] ],
        cross_sec,
        [ [ cleat_d.y, -cleat_d.z ] ]
    ),
    h = cleat_d.x,
    center = true,
    orient = LEFT,
    spin = -90
) {
    tag("hole") xrot(-90) zrot(90) {
        // TODO parametrize these 5mm values. The problem is that the nail hole
        // should be fully inset inside the body of the cleat.
        down(nail_offset.z) nail_triangle(
            vert = true, d = nail_offset.y, shell = eps
        );
    }
}
