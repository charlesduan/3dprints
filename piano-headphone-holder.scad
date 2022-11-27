include <lib/production.scad>
include <lib/morescrews.scad>
include <BOSL2/std.scad>

// Dimensions of the headphone band
headphone_thickness = 45;
headphone_radius = 80;

// Screw hole dimensions
hole_distance = 38;
hole_diam = 5.5;

// Mount dimensions
mount_dim = [60, 30, 3];

// Back dimensions
back_dim = [ 50, 3, 50 ];

// Hanger dimensions
hanger_width = 60;
hanger_thickness = 7;
hanger_lip_height = 3;
hanger_lip_width = 5;

eps = 0.01;

// The mount

difference() {
    cuboid(
        mount_dim,
        rounding = mount_dim.z / 2,
        except = TOP,
        anchor = TOP + BACK
    );
    screw_hole(
        hole_diam, 10, dir = UP,
        at = [ hole_distance / 2, -mount_dim.y / 2, -mount_dim.z - eps ]
    );
    screw_hole(
        hole_diam, 10, dir = UP,
        at = [ -hole_distance / 2, -mount_dim.y / 2, -mount_dim.z - eps ]
    );
}

// The back

difference() {
    cuboid(
        back_dim + [0, 0, headphone_radius],
        rounding = back_dim.y / 2,
        edges = "Z",
        anchor = TOP + BACK
    );
    down(headphone_radius + back_dim.z) cyl(
        r = headphone_radius - hanger_thickness / 2,
        h = hanger_y(),
        orient = FRONT,
        anchor = BOTTOM
    );
}

// The hanger

function hanger_y() = headphone_thickness + hanger_lip_width;

down(back_dim.z) intersection() {
    translate([0, -eps, hanger_lip_height + eps]) cuboid(
        [
            hanger_width,
            hanger_y() + 2 * eps,
            headphone_radius + hanger_lip_height + eps
        ],
        anchor = TOP + BACK,
        rounding = hanger_lip_width / 2,
        edges = "Z"
    );

    down(headphone_radius) difference() {
        union() {
            // Main hanger body
            cyl(
                r = headphone_radius,
                h = hanger_y(),
                orient = FRONT,
                anchor = BOTTOM,
                rounding1 = hanger_lip_width / 2
            );
            // Lip
            fwd(hanger_y()) cyl(
                r = headphone_radius + hanger_lip_height,
                h = hanger_lip_width + hanger_lip_height,
                orient = FRONT,
                anchor = TOP,
                rounding2 = hanger_lip_width / 2,
                chamfer1 = hanger_lip_height
            );
        }
        back(eps) cyl(
            r = headphone_radius - hanger_thickness,
            h = hanger_y() + 2 * eps,
            orient = FRONT,
            anchor = BOTTOM,
            rounding = -hanger_lip_width / 2
        );
    }

}
