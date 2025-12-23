include <../BOSL2/std.scad>
include <../lib/production.scad>


// Height and width of the crow's foot. z is the 3d part thickness
size = [ 35, 50, 0.5 ];

// Angle of the loops
foot_angle = 40;

// Ratio of the top loop compared to the horizontal loops
top_ratio = 1.4;

// Stroke thickness
stroke_thickness = 1.5;

// Separation between upper and lower feet
stroke_sep = 4;

// Computes the circular radius of a horizontal crow's foot. w is the total
// width of the desired foot.
function circ_radius(w) = w / (1 + 1 / sin(foot_angle / 2));

// Constructs a circular arc for a crow's foot.
// point: the junction point of the crow's foot.
// w: the total width of the foot.
// angle: the rotation angle of the foot (0 means it points rightward).
function foot_arc(point, w, angle) = let (
    r = circ_radius(w)
) arc(
    angle = [ angle - foot_angle / 2 - 90, angle + foot_angle / 2 + 90],
    r = r,
    cp = point + zrot(angle, [ (w - r), 0 ])
);

// Computes the junction point for the top crow's feet loops.
function top_point() = [ size.x / 2, size.y - size.x / 2 * top_ratio ];

function mid_point() = top_point() - [
    0, 2 * circ_radius(size.x / 2) + stroke_thickness + stroke_sep
];


linear_extrude(size.z) {
    stroke(concat(
        [ [ size.x / 2, 0 ], top_point() ],
        foot_arc(top_point(), size.x / 2 * top_ratio, 90),
        [ top_point() ]
    ), width = stroke_thickness);

    stroke(concat(
        foot_arc(top_point(), size.x / 2, 0),
        reverse(foot_arc(top_point(), size.x / 2, 180)),
    ), closed = true, width = stroke_thickness);
    stroke(concat(
        foot_arc(mid_point(), size.x / 2, 0),
        reverse(foot_arc(mid_point(), size.x / 2, 180)),
    ), closed = true, width = stroke_thickness);
}
