include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

outer_width = 50;
inner_height = 32;
thickness = 4;
rim_width = 6;
center_bar_width = 8;
center_bar_offset = 0;
thickness_rounding = 1.5;
corner_rounding = 8;

center_bar_cutout = 5;

eps = 0.01;

module inner_cutout(from, to) {
    path = right(from, round_corners(
        square([to - from, inner_height], anchor = LEFT),
        radius = corner_rounding - rim_width
    ));
    down(eps) offset_sweep(path,
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));
}

difference() {
    offset_sweep(
        round_corners(square([outer_width, inner_height + 2 * rim_width],
                anchor = CENTER),
            radius = corner_rounding),
        height = thickness,
        bottom = os_circle(r=thickness_rounding),
        top = os_circle(r=thickness_rounding));

    half_inner_space = (outer_width - 2 * rim_width - center_bar_width) / 2;

    inner_cutout(
        center_bar_width / 2 + center_bar_offset,
        outer_width / 2 - rim_width
    );

    inner_cutout(
        -outer_width / 2 + rim_width,
        -center_bar_width / 2 + center_bar_offset
    );

    translate([center_bar_offset, 0, -eps]) {
        cube([
            center_bar_width + 2 * eps,
            center_bar_cutout,
            thickness + 2 * eps
        ], anchor = BOTTOM);
    }
}
