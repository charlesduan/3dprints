include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

outer_width = 60;
inner_height = 32;
thickness = 4;
rim_width = 5;
center_bar_width = 4;
thickness_rounding = 1.5;
corner_rounding = 6;

slot_thickness = 3;
wraparound_width = 4;
loop_slot_thickness = 5;
loop_cutout = 5;


eps = 0.01;

difference() {
    offset_sweep(
        round_corners(square([outer_width, inner_height + 2 * rim_width],
                anchor = LEFT),
            radius = corner_rounding),
        height = thickness,
        bottom = os_circle(r=thickness_rounding),
        top = os_circle(r=thickness_rounding));

    translate([outer_width - rim_width, 0, -eps]) {
        cuboid(
            [slot_thickness, inner_height, thickness + 2 * eps],
            rounding = min(slot_thickness / 2, corner_rounding - rim_width),
            edges = "Z",
            anchor = BOTTOM + RIGHT
        );
    }

    left_edge = outer_width
        - rim_width
        - slot_thickness
        - wraparound_width;

    path = round_corners(
        square([ loop_slot_thickness, inner_height ], anchor = LEFT),
        radius = corner_rounding - rim_width
    );
    down(eps) offset_sweep(right(left_edge - loop_slot_thickness, path),
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));

    down(eps) offset_sweep(right(rim_width, path),
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));

    down(eps) offset_sweep(
            right(rim_width + loop_slot_thickness + wraparound_width, path),
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));

    translate([ rim_width + loop_slot_thickness - eps, 0, -eps]) cuboid(
        [ wraparound_width + 2 * eps, loop_cutout, thickness + 2 * eps ],
        anchor = BOTTOM + LEFT
    );
}
