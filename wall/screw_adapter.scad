include <../lib/production.scad>
include <../lib/morescrews.scad>
include <BOSL2/std.scad>

/*
 * An adapter plate for wall fixtures that otherwise take wall screws, like
 * surge protectors. You screw the plate into the wall and then hang the fixture
 * onto the plate. It is assumed that the plate has two screw hangers, and that
 * the plate will be attached to the wall in the center.
 */

// Dimensions of the fixture's screw parts.
fixture_shank_width = 3;
fixture_head_width = 7.5;

// Height of fixture shank
fixture_shank_height = 3.2;

// Center-to-center distance between fixture's screws.
fixture_screw_distance = 32;

// Screw cutout dimensions, [ shank diam, head diam, head depth ].
screw = [ 5, 9, 4 ];

// Dimensions of the plate. z is the thickness, which must be at least the screw
// head depth. x and y are the size of the plate overall; the fixture mounts
// will be in the x direction.
plate_d = [ 42, 15, 3 ];


// The plate must be thick enough for the screw head.
// assert(plate_d.z >= screw.z);

// The plate must be wide enough for the fixture mounts.
assert(plate_d.x >= fixture_screw_distance + fixture_shank_width);

// The plate must be long enough for the screws. Ideally it should be somewhat
// larger to minimize rotation.
assert(plate_d.y >= fixture_shank_width);

function fixture_head_height() = (fixture_head_width - fixture_shank_width) / 2;

difference() {
    union() {
        cuboid(
            plate_d,
            rounding = plate_d.z / 2,
            edges = "Z",
            anchor = BOTTOM
        );

        for (i = [ 1, -1 ]) {
            right(i * fixture_screw_distance / 2) cyl(
                h = fixture_shank_height + plate_d.z + fixture_head_height(),
                d = fixture_shank_width,
                anchor = BOTTOM
            ) {
                position(TOP) cyl(
                    h = fixture_head_height(),
                    d1 = fixture_shank_width,
                    d2 = fixture_head_width,
                    anchor = TOP
                );
            }
        }
    }
    screw_hole(
        screw.x, screw.y, screw.z,
        dir = DOWN,
        at = [ 0, 0, plate_d.z ]
    );

}



