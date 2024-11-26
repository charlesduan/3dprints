include <lib/production.scad>
include <BOSL2/std.scad>

plate = [ 150, 25, 1.5 ];

rod = [ 5, 20, 30 ];

num_rods = 5;

cuboid(
    plate,
    rounding = plate.z / 2,
    except = BOTTOM,
    anchor = BOTTOM + LEFT
);

for (i = [ 1:num_rods ]) {
    right(plate.x * (i - 0.5) / num_rods) {
        skew(syz = rod.y / rod.z) {
            cyl(
                d = rod.x,
                h = rod.z,
                rounding2 = rod.x / 2.5,
                anchor = BOTTOM
            );
        }
    }
}

