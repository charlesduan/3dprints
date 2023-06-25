/*
 * A shim and cover for the front door.
 */

include <BOSL2/std.scad>
include <lib/production.scad>

plate_length = 123.3;
plate_width = 31.4;
plate_gap = 1;

lock_length = 86;
lock_width = 44.3;
lock_back_width = 44.3 - 9.2;

lock_front_depth = 19;
lock_depth = 28;

door_hole_length = 89;
door_hole_width = 32;
door_thickness = 4;

door_perimeter = 7;
door_shell = 1;

shim_thickness = 2.5;
shim_hole_offset = [5.5 + 7.4 / 2, 11.6 + 7.4 / 2];
shim_hole_size = 10;

eps = 0.01;

difference() {

    union() {

        // The shim parts
        linear_extrude(shim_thickness) {
            difference() {
                rect(
                    [plate_length - 2 * plate_gap, plate_width],
                    anchor = FRONT
                );

                translate([
                    plate_length / 2 - shim_hole_offset.x,
                    shim_hole_offset.y
                ]) circle(d = shim_hole_size);
                translate([
                    -plate_length / 2 + shim_hole_offset.x,
                    shim_hole_offset.y
                ]) circle(d = shim_hole_size);
            }
        }

        // Surrounding top and bottom of lock
        lock_front_width = min(
            lock_width,
            lock_back_width + door_thickness + eps
        );
        cuboid(
            [door_hole_length, lock_front_width, lock_front_depth],
            anchor = FRONT + BOTTOM
        );

        cuboid(
            [door_hole_length, lock_back_width + eps, lock_depth],
            anchor = FRONT + BOTTOM
        );

        // Fill in the door hole
        back(lock_back_width - eps) {
            cuboid(
                [door_hole_length, door_thickness + 2 * eps, door_hole_width],
                anchor = FRONT + BOTTOM
            );
        }
        back(lock_back_width) {
            cuboid(
                [
                    door_hole_length,
                    door_shell,
                    door_hole_width + door_perimeter
                ],
                anchor = BACK + BOTTOM
            );
        }
        back(lock_back_width + door_thickness) {
            cuboid(
                [
                    door_hole_length + 2 * door_perimeter,
                    door_shell,
                    door_hole_width + door_perimeter
                ],
                anchor = FRONT + BOTTOM
            );
        }
    }

    // The lock body
    union() {
        cuboid(
            [lock_length, lock_width + eps, lock_front_depth + eps],
            anchor = FRONT + BOTTOM
        );
        up(eps) fwd(eps) cuboid(
            [lock_length, lock_back_width + eps, lock_depth + eps],
            anchor = FRONT + BOTTOM
        );
        up(eps) cuboid(
            [lock_length, lock_width, shim_thickness + eps],
            anchor = FRONT + TOP
        );
    }

}
