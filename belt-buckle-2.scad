include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

outer_width = 50;
inner_height = 32;
thickness = 4;
rim_width = 5;
center_bar_width = 4;
thickness_rounding = 1.5;
corner_rounding = 6;

slot_thickness = 3;

eps = 0.01;

difference() {
    offset_sweep(
        round_corners(square([outer_width, inner_height + 2 * rim_width],
                anchor = LEFT),
            radius = corner_rounding),
        height = thickness,
        bottom = os_circle(r=thickness_rounding),
        top = os_circle(r=thickness_rounding));

    translate([outer_width - rim_width, 0, thickness]) rotate([0, 45, 0]) {
        cuboid(
            [slot_thickness, inner_height, 20 * thickness],
            rounding = min(slot_thickness / 2, corner_rounding - rim_width),
            edges = "Z",
            anchor = RIGHT
        );
    }

    left_edge = outer_width
        - rim_width
        - sqrt(2) * (slot_thickness)
        - thickness
        - center_bar_width;

    path = right(rim_width, round_corners(
        square([ left_edge - rim_width, inner_height ], anchor = LEFT),
        radius = corner_rounding - rim_width
    ));
    down(eps) offset_sweep(path,
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));


}
