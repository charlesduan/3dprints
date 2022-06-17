include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

outer_width = 50;
inner_height = 32;
thickness = 4;
rim_width = 5;
center_bar_width = 8;
center_bar_offset = -4;
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

    half_inner_space = (outer_width - 2 * rim_width - center_bar_width) / 2;

    right_path = right(center_bar_width / 2 + center_bar_offset, round_corners(
        square(
            [ half_inner_space - center_bar_offset, inner_height ],
            anchor = LEFT
        ),
        radius = corner_rounding - rim_width
    ));

    down(eps) offset_sweep(right_path,
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));

    left_path = left(center_bar_width / 2 - center_bar_offset, round_corners(
        square(
            [ half_inner_space + center_bar_offset, inner_height ],
            anchor = RIGHT
        ),
        radius = corner_rounding - rim_width
    ));

    down(eps) offset_sweep(left_path,
            height = thickness + 2 * eps,
            bottom = os_circle(r=-thickness_rounding),
            top = os_circle(r=-thickness_rounding));
}
