include <BOSL2/std.scad>
include <lib/production.scad>

/*
 * Makes a picture frame capable of holding a card.
 */

// Dimensions of the object to be framed. The x and y coordinates are the size;
// the z coordinate is the thickness of the space to provide the object.
object_d = [ 90, 160, 1.5 ];

// Dimensions of the frame's outer shell.
shell_d = [ 2, 2, 2 ];

// How much the front of the frame should overlap the card.
window_overlap_d = [ 5, 5 ];

// How much to chamber the outer corners of the frame.
corner_chamfer = 2;

// How much to chamfer the window, in terms of a horizontal distance.
window_chamfer = shell_d.z;

// Dimensions of the corner stays.
corner_stay_d = [ 15, 15, 1 ];

// Additional space underneath the corner stays inside the frame.
extra_thickness = 5;

// Dimensions of the diagonal stay for hanging the frame.
hanger_d = [ 40, 3, 3 ];

eps = 0.01;

module four_corners(w, l) {
    translate([-w / 2, -l / 2]) children();
    translate([-w / 2, l / 2]) rotate([0, 0, -90]) children();
    translate([w / 2, l / 2]) rotate([0, 0, 180]) children();
    translate([w / 2, -l / 2]) rotate([0, 0, 90]) children();
}


// The height of the inside cavity of the frame.
function frame_cavity_z() = object_d.z + corner_stay_d.z + extra_thickness;

assert(hanger_d.z + object_d.z < frame_cavity_z());

difference() {

    // Outer surface
    down(shell_d.z) {
        cuboid(
            [
                object_d.x + 2 * shell_d.x,
                object_d.y + 2 * shell_d.y,
                frame_cavity_z() + shell_d.z
            ],
            anchor = BOTTOM,
            chamfer = corner_chamfer,
            except = TOP
        );
    }

    // Where the object itself goes
    cuboid([object_d.x, object_d.y, frame_cavity_z() + eps],
            anchor = BOTTOM);

    // Frame window
    window_size = point2d(object_d) - 2 * window_overlap_d;
    up(eps) {
        prismoid(
            size2 = window_size,
            size1 = window_size + 2 * window_chamfer * [ 1, 1 ],
            h = shell_d.z + 2 * eps,
            anchor = TOP
        );
    }

}

// Corners
four_corners(object_d.x + 2 * eps, object_d.y + 2 * eps) {
    up(object_d.z) {
        linear_extrude(corner_stay_d.z) {
            polygon([ [0, 0], [corner_stay_d.x + eps, 0],
                    [0, corner_stay_d.y + eps] ]);
        }
    }
}

// Hanger
translate([0, object_d.y / 2 + eps, frame_cavity_z()]) {
    rotate([0, 90, 0]) {
        linear_extrude(hanger_d.x, center = true) {
            polygon([ [0, 0], [hanger_d.z + eps, 0],
                    [0, -hanger_d.y - eps] ]);
        }
    }
}
