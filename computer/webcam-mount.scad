include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

//$fs = 0.2;

/*
 * Measured variables
 */


// Monitor back dimensions. z is the distance to go down (not including any
// stop), y is the distance to go back (0 if the monitor is straight
// vertical), and x is ignored.
back_d = [ 0, 10, 20 ];

// Thickness of the top of the monitor.
monitor_top_y = 15.5;

// Back stop size. Only y and z are relevant.
back_stop_d = [ 0, 3.5, 3.5 ];

// Size of the camera's hinge knuckle (the part that the screw goes into). The
// camera is held facing forward in the positive x direction; y is irrelevant
// since it is assumed to be sufficient to permit rotation about the x axis.
camera_knuckle_d = [ 7.8, 0, 8.1 ];

// Screw dimensions. x is the shank diameter, y the head diameter, z the head
// thickness.
screw_d = [ 3.0, 5.5, 3.0 ];

// Hex nut dimensions. x is the outer diameter, y unused, z the thickness.
nut_d = [ 6.35, 0, 2.4 ];


/*
 * Discretionary variables
 */

// x is the width of the holder body, y the thickness of the back portion.
holder_d = [ 10, 3 ];

// Front stop size for holding against the front of the monitor. y is the
// thickness of the stop, z the downward drop distance, x is ignored.
front_stop_d = [ 0, 3, 3.5 ];

// Extra distance that the stand should extend beyond the front of the monitor.
extra_y = 5;

// Extra distance that the hinge should protrude.
hinge_extra_y = 0;

// Radius of rounding.
round_radius = 1;

// Whether the camera should be mounted vertically rather than horizontally.
vertical_mount = true;



// The thickness of the top part of the mount, which needs to be equal to the
// width of the knuckle (based on vertical or horizontal mounting).
function top_thickness() = vertical_mount
    ? camera_knuckle_d.x + 4 + screw_d.z + nut_d.z
    : camera_knuckle_d.z;


/*
 * Define the side profile of the camera stand in the Y-Z plane. The origin is
 * the back top edge of the monitor.
 */

function tot_back_z() = back_d.z + back_stop_d.z;
function tot_front_y() = monitor_top_y + front_stop_d.y + extra_y;
function back_line_point(zcoord, radius) = point3d(line_intersection(
    [ [ holder_d.y, 0 ], [ holder_d.y + back_d.y, -back_d.z ] ],
    [ [ 0, zcoord ], [ 1, zcoord ] ]
), fill = radius);

/*
 * Polygon for the cross-section of the stand's overall profile. The z
 * coordinate is the rounding radius.
 */
function stand_profile_with_radii() = [
    [ 0, 0, 0 ],
    [ back_d.y, -back_d.z, 0 ],
    [ back_d.y - back_stop_d.y, -back_d.z, back_stop_d.z ],
    [ back_d.y - back_stop_d.y, -tot_back_z(), back_stop_d.z ],
    back_line_point(-tot_back_z(), back_stop_d.z),
    back_line_point(top_thickness(), top_thickness()),
    [ -tot_front_y(), top_thickness(), top_thickness() ],
    [ -tot_front_y(), 0, top_thickness() ],
    [ -tot_front_y() + extra_y, 0, 0 ],
    [ -tot_front_y() + extra_y, -front_stop_d.z, front_stop_d.y ],
    [ -monitor_top_y, -front_stop_d.z, front_stop_d.y ],
    [ -monitor_top_y, 0, 0 ]
];

/*
 * The cross-section of the stand, with corners rounded.
 */
function stand_profile(round_func) = round_corners(
    path2d(stand_profile_with_radii()),
    r = [ for (p = stand_profile_with_radii()) round_func(p.z) ]
);


/*
 * Extrude the stand based on its cross-section.
 */
left(holder_d.x / 2) offset_sweep(
    stand_profile(function(x) min([ x / 2, round_radius ])),
    h = holder_d.x,
    bottom = os_circle(round_radius),
    top = os_circle(round_radius),
    spin = 90,
    orient = RIGHT
);


/*
 * The hinge insertion point.
 */
module hinge_knuckle(
    gap_h,              // Gap into which the camera hinge knuckle fits
    d,                  // Diameter of the camera's hinge knuckle
    extra_length,       // How far out this hinge knuckle extends
    shank_d,            // Bolt dimensions
    head_d,
    head_h,
    nut_d,              // Nut dimensions
    nut_h,
    shell,              // Thickness between camera knuckle and nut/bolt
    rounding = 0,
    anchor,
    spin = 0,
    orient = UP
) {
    eps = 0.01;
    // Total width of the hinge.
    width = gap_h + 2 * shell + head_h + nut_h;
    diff() xcyl(
        h = width, d = d,
        rounding = rounding,
        anchor = anchor, spin = spin, orient = orient
    ) {
        position(CENTER) cuboid(
            [ width, extra_length + d / 2, d ],
            rounding = rounding,
            edges = "Y",
            anchor = FRONT
        );
        tag("remove") position(LEFT) right(nut_h + shell) {
            xcyl(h = gap_h, d = d, anchor = LEFT);
        }
        tag("remove") position(LEFT + BACK) right(nut_h + shell) fwd(d / 6) {
            cuboid([ gap_h, d, d + 2 * eps ], anchor = BACK + LEFT);
        }
        tag("remove") attach(RIGHT, overlap = -eps) {
            cyl(h = head_h + eps, d = head_d, anchor = TOP);
            cyl(h = width + 2 * eps, d = shank_d, anchor = TOP);
        }
        tag("remove") attach(LEFT, overlap = -eps) {
            linear_sweep(
                region = hexagon(od = nut_d),
                h = nut_h + eps,
                anchor = TOP
            );
        }
    }
}

fwd(tot_front_y() + hinge_extra_y + camera_knuckle_d.z / 2) {
    knuckle_anchor = vertical_mount ? RIGHT : BOTTOM;
    knuckle_orient = vertical_mount ? RIGHT : UP;
    knuckle_up = vertical_mount ? top_thickness() : 0;
    hinge_knuckle(
        gap_h = camera_knuckle_d.x,
        d = camera_knuckle_d.z,
        extra_length = hinge_extra_y + round_radius,
        shank_d = screw_d.x,
        head_d = screw_d.y,
        head_h = screw_d.z,
        nut_d = nut_d.x,
        nut_h = nut_d.z,
        shell = 2,
        rounding = round_radius,
        anchor = knuckle_anchor,
        orient = knuckle_orient
    );
}
