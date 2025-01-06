/*
 * A paper cutter. There are two plates, a blade plate and a receiver plate with
 * a gap corresponding to the blade.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Size of the paper.
paper_d = [ 20, 20 ];

// Blade dimensions, in [ max thickness, min thickness, height ].
blade_d = [ 0.8, 0.2, 2 ];

// Extra space for the blade receiver slot.
slot_extra = [ 0.5, undef, 1 ];

// Blade plate thickness.
blade_plate = 1.5;

// The blade's path.
blade_path = circle(d = paper_d.x * 0.8);

// The receiver plate has a wall into which the blade plate will fit. The
// dimensions are [ wall lateral thickness, extra lateral gap, extra height].
receiver_wall = [ 1, 0.5, 2 ];

// Extra thickness at the bottom of the receiver plate.
receiver_extra = 1;

eps = 0.01;

/*
 * The blade plate.
 */

blade_shape = [
    [ -blade_d.x / 2, -eps ],
    [ -blade_d.x / 2, 0 ],
    [ -blade_d.y / 2, blade_d.z ],
    [ blade_d.y / 2, blade_d.z ],
    [ blade_d.x / 2, 0 ],
    [ blade_d.x / 2, -eps ]
];

cuboid([ paper_d.x, paper_d.y, blade_plate ], anchor = BOTTOM);
up(blade_plate) path_sweep(blade_shape, blade_path, closed = true);

/*
 * The receiver plate.
 */
left(paper_d.x + 20) difference() {
    plate_z = slot_extra.z + blade_d.z + receiver_extra;
    cuboid([
        paper_d.x + 2 * (receiver_wall.x + receiver_wall.y),
        paper_d.y + 2 * (receiver_wall.x + receiver_wall.y),
        plate_z + receiver_wall.z
    ], anchor = BOTTOM);

    up(plate_z) cuboid([
            paper_d.x + 2 * receiver_wall.y,
            paper_d.y + 2 * receiver_wall.y,
            receiver_wall.z + eps
    ], anchor = BOTTOM);

    slot_shape = [
        [ (blade_d.x + slot_extra.x) / 2, plate_z + eps ],
        [ (blade_d.x + slot_extra.x) / 2, plate_z ],
        [ (blade_d.y + slot_extra.x) / 2, slot_extra.z ],
        [ (blade_d.y + slot_extra.x) / 2, -eps ]
    ];


    path_sweep(
        concat(slot_shape, reverse(xflip(slot_shape))),
        xflip(blade_path),
        closed = true
    );
}
