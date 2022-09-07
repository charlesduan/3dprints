include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

// Size of the clip up to the button end
body_dims = [55, 15, 2];

// Outer and inner diameters, and depth, of the button circle
button_dims = [10.5, 8.5, 1.5];

// Outer and inner diameters, and depth, of the screw holes
screw_hole_dims = [4.25, 1.5, 2.5];

// Center-to-center distance of screwholes from each other
screw_hole_dist = 7;

// Center-to-center displacement of the screwholes from the button
screw_hole_button_dist = 8;

// Height of the clip above the surface
clip_height = 2;

// Width, displacement, and extra thickness of the clip prong
prong_dims = [5, 5, 0.5];

eps = 0.01;


// Back of the clip
difference() {
    up(eps) offset_sweep(
        rect(point2d(body_dims), rounding = body_dims.y / 3, anchor = LEFT),
        h = body_dims.z,
        bottom = os_circle(body_dims.z / 2),
        anchor = TOP + LEFT
    );

    // Hole for button
    up(2 * eps) right(body_dims.x - button_dims.x / 2) {
        cyl(
            d = button_dims.y, h = 3 * eps + body_dims.z,
            anchor = TOP, rounding1 = -body_dims.z / 2
        );
    }
}

// Clip prong
right(prong_dims.y) cuboid(
    [prong_dims.x, body_dims.y, clip_height + prong_dims.z + eps],
    anchor = BOTTOM + LEFT,
    rounding = min(prong_dims.x, clip_height + prong_dims.z) / 2,
    edges = TOP
);

right(body_dims.x - button_dims.x / 2) {
    // Button
    tube(
        h = clip_height + button_dims.z + eps,
        od = button_dims.x,
        id = button_dims.y,
        anchor = BOTTOM
    );

    left(screw_hole_button_dist) {
        for (offy = [-1, 1] * screw_hole_dist / 2) {
            fwd(offy) tube(
                od = screw_hole_dims.x,
                id = screw_hole_dims.y,
                h = clip_height + screw_hole_dims.z + eps,
                anchor = BOTTOM
            );
        }
    }
}
