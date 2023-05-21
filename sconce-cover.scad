include <BOSL2/std.scad>
include <lib/production.scad>

outer_diam = 118;
sconce_thickness = 4;

bot_shell = 0.75;
side_shell = 0.6 * 3;
outside_flange_h = 10;
inside_flange_h = 5;

eps = 0.01;

difference() {
    down(bot_shell) cyl(
        d = outer_diam + 2 * side_shell,
        h = bot_shell + outside_flange_h,
        anchor = BOTTOM
    );

    cyl(
        d = outer_diam,
        h = outside_flange_h + eps,
        anchor = BOTTOM
    );
}

down(eps) difference() {
    cyl(
        d = outer_diam - 2 * sconce_thickness,
        h = inside_flange_h + eps,
        anchor = BOTTOM
    );

    cyl(
        d = outer_diam - 2 * sconce_thickness - 2 * side_shell,
        h = inside_flange_h + 2 * eps,
        anchor = BOTTOM
    );
}

