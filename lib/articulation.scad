include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/structs.scad>

/*
 * Constructs a struct of specifications for a default hinge knuckle set. The
 * specification is generally suited for a Logitech C270 camera. The values can
 * be modified as desired to make different hinges.
 */
function hinge_struct() = struct_set([], [
    "spec", "M3",               // Screw specification
    "gap", 7.8,                 // Space between knuckles
    "d", 8.1,                   // Hinge cylinder diameter
    "extra_h", 0.5,             // Extra height above XY plane
    "shell", 2,                 // Extra knuckle length
    "min_diam_shell", 0.5,      // Minimum extra diameter around nut/bolt holes
    "chamfer", 0.2,             // Chamfer around parts
    "head_slop", 0.1,           // Extra space around nut/screw head
    "gap_slop", 0.1,            // Extra space between center and side knuckles
    "shank_slop", 0.5,          // Extra space arount screw thread
    "eps", 0.01
]);

/*
 * Makes a knuckle for a hinge. The hinge is positioned upwards above the XY
 * plane, with the holes oriented along the X axis.
 *
 * center: Whether to make the center knuckle or the sides.
 */
module hinge_knuckle(struct = hinge_struct(), center = false, anchor = CENTER) {
    spec = struct_val(struct, "spec");
    screw_spec = screw_info(spec, head = "socket");
    nut_spec = nut_info(spec);
    nut_d = struct_val(nut_spec, "width") * 2 / sqrt(3);

    min_diam_shell = struct_val(struct, "min_diam_shell");
    d = struct_val(struct, "d");
    head_slop = struct_val(struct, "head_slop");
    assert(nut_d + min_diam_shell + head_slop <= d);
    assert(
        struct_val(screw_spec, "head_size") + min_diam_shell + head_slop <= d
    );

    head_len = struct_val(screw_spec, "head_height");
    nut_len = struct_val(nut_spec, "thickness");
    knuckle_len = max(head_len, nut_len) + struct_val(struct, "shell");

    gap = struct_val(struct, "gap");
    tot_len = 2 * knuckle_len + gap;

    // To make the knuckle, we construct an invisible rectangle at the bottom,
    // and then attach all the parts to it.
    tag_diff("knuckle") hide("rect") tag("rect") rect(
        [ tot_len, d ], anchor = anchor
    ) tag("knuckle") {
        if (center) {
            // Center knuckle support
            knuckle_part(
                gap - 2 * struct_val(struct, "gap_slop"), CENTER, struct
            );
        } else {
            // Left knuckle support
            knuckle_part(knuckle_len, LEFT, struct);
            // Right knuckle support
            knuckle_part(knuckle_len, RIGHT, struct);
        }

        eps = struct_val(struct, "eps");

        // The screw cutout
        tag("remove") position(RIGHT) up(
            struct_val(struct, "extra_h") + d / 2
        ) rot(from=UP, to=LEFT) down(eps) nut_trap_inline(
            // Nut part
            length = struct_val(nut_spec, "thickness") + eps,
            spec = nut_spec,
            $slop = head_slop,
            anchor = BOTTOM
        ) position(BOTTOM) screw_hole(
            // Screw hole and screw head hole
            length = tot_len + 2 * eps - head_len,
            spec = screw_spec,
            hole_oversize = struct_val(struct, "shank_slop"),
            head_oversize = head_slop,
            anchor = BOTTOM
        );
    }
}

// Constructs one segment of a hinge knuckle.
module knuckle_part(w, pos, struct) {
    d = struct_val(struct, "d");
    eps = struct_val(struct, "eps");
    chamfer = struct_val(struct, "chamfer");
    position(pos) down(eps) cuboid(
        [ w, d, struct_val(struct, "extra_h") + d / 2 + eps ],
        chamfer = chamfer,
        edges = "Z",
        anchor = BOTTOM + pos
    ) position(TOP + pos) xcyl(
        h = w, d = d,
        chamfer = chamfer,
        anchor = pos
    );
}

/*
 * Computes the width of the hinge knuckle constructed by hinge_knuckle().
 */
function hinge_knuckle_width(struct = hinge_struct()) = let (
    spec = struct_val(struct, "spec"),
    screw_spec = screw_info(spec, head = "socket"),
    nut_spec = nut_info(spec),
    head_len = struct_val(screw_spec, "head_height"),
    nut_len = struct_val(nut_spec, "thickness"),
    knuckle_len = max(head_len, nut_len) + struct_val(struct, "shell")
) 2 * knuckle_len + struct_val(struct, "gap");



/*
 * Makes a clip for retaining a wire. The wire is assumed to travel along the X
 * axis above the XY plane.
 */
module wire_clip(
    d,
    w,
    shell = 1,
    ret_angle = 35,
    extra_h = 0.5,
    anchor = CENTER,
    chamfer = 0.2,
    eps = 0.01
) {
    out_d = d + 2 * shell;
    down(eps) tag_diff("holder") cuboid(
        // Bottom rectangular portion
        [ w, out_d, extra_h + d / 2 + eps ],
        chamfer = chamfer, edges = "Z",
        anchor = anchor + BOTTOM
    ) position(TOP) xcyl(
        // Upper cylinder
        d = out_d, h = w, chamfer = chamfer,
        anchor = CENTER
    ) tag("remove") {
        position(CENTER) xcyl(
            d = d, h = w + 2 * eps, chamfer = -chamfer,
            anchor = CENTER
        );
        if (extra_h < shell) {
            position(BOTTOM) down(eps) cuboid(
                [ w + 2 * eps, out_d + 2 * eps, shell - extra_h ],
                anchor = BOTTOM
            );
        }

        position(TOP) up(eps) cuboid(
            [ w + 2 * eps, out_d + 2 * eps, (out_d - d * sin(ret_angle)) / 2 ],
            anchor = TOP
        );
        gap_angle = 180 - 2 * ret_angle + 2;
        position(RIGHT) right(eps) orient(LEFT) pie_slice(
                ang = gap_angle, r = out_d, h = w + 2 * eps,
                spin = 90 - gap_angle / 2                  
            );                                             

    }
}

