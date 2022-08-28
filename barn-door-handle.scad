include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/morescrews.scad>
include <lib/production.scad>

// Maximum diameter of the handle
handle_width = 160;

// Width of the handle edges
handle_edge_width = 25;

// Thickness of outer handle side
outer_thickness = 5;

// Thickness of the inner handle side
inner_thickness = 5;

// Thickness of the door itself. Default is 3/4"
door_thickness = 18; 

// How far from the door's edge the center of the handle will be.
door_offset = 25;

// Path for the door's profile. It should extend into the positive x direction
// to cut out parts of the door.
door_profile = [ [0, 0], [2, 5], [8, 5], [8, 13], [2, 13], [0, 18] ];


outer_round = 5;
inner_round = 5;

screw_shank = 4;
screw_head = 7;
screw_sink = 3;

eps = 0.01;

function handle_id() = handle_width - 2 * handle_edge_width;

ext_path = hexagon(od = handle_width, rounding = 1, $fn = 50, spin = 90);
int_path = hexagon(od = handle_id(), rounding = 1, $fn = 50, spin = 90);

function screw_point(dir) = let (ddir = select(dir, 0, len(ext_path[0]) - 1)) (
    path_closest_point(path = ext_path, pt = ddir * handle_width / 2)[1]
    + path_closest_point(path = int_path, pt = ddir * handle_width / 2)[1]
) / 2;

difference() {

    // Outer perimiter of door handle
    down(inner_thickness) offset_sweep(
        ext_path,
        outer_thickness + door_thickness + inner_thickness,
        top = os_circle(r = outer_round),
        bottom = os_circle(r = inner_round)
    );

    // Inside door cutout
    down(inner_thickness + eps) offset_sweep(
        int_path,
        outer_thickness + door_thickness + inner_thickness + 2 * eps,
        top = os_circle(r = -outer_round),
        bottom = os_circle(r = 1)
    );

    // Hole for inserting around door
    translate([door_offset, 0, 0]) {
        right(eps) cuboid(
            [handle_width + eps, handle_width + eps, door_thickness + eps],
            anchor = BOTTOM + RIGHT
        );
        xrot(90) linear_extrude(handle_width, center = true) {
            polygon(door_profile);
        }
    }

    // Screw cutouts, outer side
    up(door_thickness + outer_thickness) {
        for (d = [LEFT, BACK, FRONT]) {
            screw_hole(
                screw_shank, screw_head,
                countersink = screw_sink,
                shank_l = door_thickness / 2,
                at = screw_point(d)
            );
        }
    }

    // Screw cutouts, inner side
    down(inner_thickness) {
        for (d = [LEFT + BACK, LEFT + FRONT]) {
            screw_hole(
                screw_shank, screw_head,
                countersink = screw_sink,
                shank_l = door_thickness / 2,
                dir = UP,
                at = screw_point(d)
            );
        }
    }

}
