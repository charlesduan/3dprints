/*
 * Folds paper into an accordion shape.
 */

include <../lib/production.scad>
include <../BOSL2/std.scad>

// Distance between fold ridges.
fold_length = 5;

// Size of the card.
card_d = [ 150, 142 ];

// Number of gear points.
gear_points = 16;

// Angle of the tips of the gear.
gear_angle = 60;

// Shell thickness for gear.
gear_shell = 2;

// Thickness of gear struts.
gear_strut_shell = 1;

// Inner strut count within gear (does not include top and bottom).
gear_struts = 4;

// Inner hole.
hole_d = 22;

eps = 0.01;

module gear_star() {
    circ_angle = 360 / gear_points;

    inner_r = fold_length * sin(gear_angle / 2) / sin(circ_angle / 2);
    outer_r = fold_length * cos(gear_angle / 2) + inner_r * cos(circ_angle / 2);

    difference() {
        linear_sweep(
            star(n = gear_points, or = outer_r, ir = inner_r),
            h = card_d.y,
            anchor = BOTTOM
        );

        /*
        gap_space = (card_d.y - gear_strut_shell) / (gear_struts + 1);
        zcopies(
            n = gear_struts + 1, spacing = gap_space, sp = gear_strut_shell
        ) {
            tube(
                or = inner_r - gear_shell,
                id = hole_d + 2 * gear_shell,
                h = gap_space - gear_strut_shell,
                anchor = BOTTOM
            );
        }
        */

        down(eps) cylinder(d = hole_d, h = card_d.y + 2 * eps, anchor = BOT);

    }
}

//back_half(3 * card_d.y) {
    gear_star();
//}
