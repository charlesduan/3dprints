/*
 * A simple wall mount for a lightweight VESA monitor.
 */
include <../lib/production.scad>
include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

// Center-to-center positions of the VESA screws.
vesa_pos = [ 75, 75 ];

// Outside dimensions of the VESA bracket. The thickness is determined by the
// flange.
vesa_d = [ 100, 100 ];

// How far from the top edge to stop the bracket cutout. Note that this does not
// include the flange.
vesa_top = 7;

// The screw struct for VESA screws.
vesa_screw_info = struct_set(screw_info("M4", "socket"), [
    "head_height", 3,
    "head_size", 12
]);

// The part that attaches to the wall. x and y are coplanar with the wall; z is
// thickness extending outward. This does not include any attachment flange.
wall_bracket_d = [ 30, 190, 10 ];

// The screw struct for wall screws.
wall_screw_info = screw_info("1/4", "pan");

// The positions of the wall screws, relative to the top of the wall mount.
wall_screw_pos = [ 8, 8 + 83 * 2 ];

// Dimensions of the flange. x is the lateral extension, y the upward extension,
// z the thickness of the flange.
flange_d = [ 7, 7, wall_bracket_d.z / 2 ];

// Slop for the flange dimensions (added to the receiving space on the VESA
// side).
slop_d = [ 0.5, 0.5, 0.5 ];


eps = 0.01;

function flange_tot_d() = wall_bracket_d + [
    flange_d.x * 2, flange_d.y, flange_d.z - wall_bracket_d.z
];

// The wall side.
diff() left(10) cuboid(wall_bracket_d, anchor = BOTTOM + RIGHT) {
    position(BOTTOM + FRONT) {
        cuboid(
            flange_tot_d(),
            anchor = BOTTOM + FRONT
        );
    }
    tag("remove") position(BOTTOM + BACK) ycopies(wall_screw_pos * -1) screw_hole(
        wall_screw_info,
        l = wall_bracket_d.z,
        orient = DOWN,
        anchor = TOP
    ) {
        attach("head_bot") up(eps) cuboid([
            struct_val($screw_spec, "diameter"),
            struct_val($screw_spec, "head_size"), 0.25
        ], anchor = TOP);
    }
}

// The VESA mount side.
diff() right(10) cuboid(
    point3d(vesa_d, wall_bracket_d.z),
    anchor = BOTTOM + LEFT
) {
    tag("remove") {
        position(TOP + BACK) up(eps) fwd(vesa_top) {
            cuboid(
                wall_bracket_d + [ 2 * slop_d.x, 0, 2 * eps ],
                anchor = TOP + BACK
            ) position (BOTTOM + FRONT) {
                cuboid(
                    flange_tot_d() + [ 2 * slop_d.x, slop_d.y, slop_d.z + eps ],
                    anchor = BOTTOM + FRONT
                );
            }
        }
        attach(TOP) grid_copies(n = 2, spacing = vesa_pos) screw_hole(
            vesa_screw_info,
            l = wall_bracket_d.z, counterbore = true,
            anchor = TOP
        );
    }
}
