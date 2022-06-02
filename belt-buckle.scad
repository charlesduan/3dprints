include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

outer_width = 50;
inner_height = 32;
thickness = 6;
rim_width = 5;
center_bar_width = 8;
thickness_rounding = 1.5;
corner_rounding = 6;

eps = 0.01;

difference() {
    offset_sweep(
        round_corners(square([outer_width, inner_height + 2 * rim_width],
                anchor = CENTER),
            radius = corner_rounding),
        height = thickness,
        bottom = os_circle(r=thickness_rounding),
        top = os_circle(r=thickness_rounding));

    path = right(center_bar_width / 2, round_corners(
            square([(outer_width - 2 * rim_width - center_bar_width) / 2,
                inner_height], anchor = LEFT),
            radius = corner_rounding - rim_width));

    down(eps) offset_sweep(path,
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));
    down(eps) offset_sweep(xflip(path),
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));
}
