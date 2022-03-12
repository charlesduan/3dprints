include <BOSL2/std.scad>

$fa = 1;
$fs = 0.4;

phone_length = 73.3;
phone_width = 147.3;
phone_height = 10.8;
phone_corner_rad = 12;
phone_corner_gap = 0.5;
phone_slop = 1;

charger_length = 80.5;
charger_width = 81.1;
charger_slop = 1;
charger_barrel_rad = 8 / 2;
charger_light_width = 14;
charger_light_height = 1.5;
charger_height = 13.3;
charger_foot_height = 1.2;
charger_foot_width = 9;
charger_foot_dims = [ 60, 63.5 ];
charger_base_gap = 0.1;

bot_shell = 2;
side_shell = 1.2;
phone_corner_size = 15;

eps = 0.01;

function outer_length(shell) = 2 * shell +
        max(phone_length + phone_slop, charger_length + charger_slop);

function charger_base_height() = charger_height * (1 - charger_base_gap);

module charger_shell(shell) {
    cw = charger_width + charger_slop;
    cl = outer_length(0);
    s2 = shell * 2;
    difference() {
        cube([cw + s2, cl + s2,
                charger_base_height()], anchor = BOTTOM);
        cuboid([cw, cl, charger_height],
                rounding = charger_height / 2 - eps, edges = "Y",
                except = TOP,
                anchor = BOTTOM);
        cube([cw - charger_height, cl, 2 * eps],
                anchor = CENTER);

        // Light hole
        translate([0, -cl / 2 + eps, charger_height / 2]) {
            rotate([90, 0, 0]) {
                prismoid([charger_light_width, charger_light_height],
                        [charger_light_width + 2 * shell,
                        charger_light_height + 2 * shell],
                        h = shell + 2 * eps,
                        rounding = charger_light_height / 2 - eps,
                        anchor = BOTTOM);
            }
        }

        // Charger barrel hole
        translate([0, cl / 2 - eps, charger_height / 2]) {
            rotate([-90, 0, 0]) {
                cylinder(shell + 2 * eps, r = charger_barrel_rad);
            }
            if (charger_base_height() / 2 - charger_barrel_rad < 2) {
                cube([2 * charger_barrel_rad, shell + 2 * eps,
                        charger_base_height() / 2 + eps],
                        anchor = BOTTOM + FRONT);
            }
        }
    }
    charger_feet_rings();
}

module charger_shell_mask(shell) {
    cw = charger_width + charger_slop;
    cl = charger_length + charger_slop;
    s2 = shell * 2;
    cube([cw + s2 - eps, outer_length(shell) + 2 * eps,
            charger_height + eps], anchor = BOTTOM);
}

module four_corners(w, l) {
    translate([-w / 2, -l / 2]) children();
    translate([-w / 2, l / 2]) rotate([0, 0, -90]) children();
    translate([w / 2, l / 2]) rotate([0, 0, 180]) children();
    translate([w / 2, -l / 2]) rotate([0, 0, 90]) children();
}

module charger_feet_mask(height) {
    up(height + eps) four_corners(charger_foot_dims.x, charger_foot_dims.y) {
        cylinder(h = height + 2 * eps, d = charger_foot_width,
                anchor = TOP);
    }
}

module charger_feet_rings() {
    down(bot_shell) linear_extrude(bot_shell) {
        four_corners(charger_foot_dims.x, charger_foot_dims.y) {
            difference() {
                circle(d = charger_foot_width + 2 * side_shell);
                circle(d = charger_foot_width);
            }
        }
    }
}


module phone_shell(shell, height) {
    pw = phone_width + phone_slop;
    pl = phone_length + phone_slop;
    difference() {
        cuboid([pw + 2 * shell, outer_length(shell), height],
                rounding = phone_corner_rad + shell,
                anchor = BOTTOM, edges = "Z");
        down(eps) intersection() {
            cuboid([pw, pl, height + 2 * eps],
                    rounding = phone_corner_rad,
                    anchor = BOTTOM, edges = "Z");
            if ($children > 0) {
                linear_extrude(height + 2 * eps) children();
            }
        }
    }
}


module phone_corners(shell, width, height) {
    pws = phone_width + phone_slop + 2 * shell;
    box_min_width = 2 * (phone_corner_rad + shell) + eps;
    box_width = max(width, box_min_width);
    difference() {
        phone_shell(shell, height);
        down(eps) union() {
            cube([pws + 2 * eps, outer_length(shell) - 2 * width,
                    height + 2 * eps], anchor = BOTTOM);
            cube([pws - 2 * width, outer_length(shell) + 2 * eps,
                    height + 2 * eps], anchor = BOTTOM);
        }
    }
}

module phone_base(shell, height) {
    pw = phone_width + phone_slop;
    pl = phone_length + phone_slop;
    circ_diam = 10;
    shell_min_thickness = 1;
    difference() {
        phone_shell(shell, height + bot_shell) {
            for (x = [-pw/2 : circ_diam * sqrt(3) : pw/2 + circ_diam]) {
                for (y = [-pl/2 : circ_diam : pl/2 + circ_diam]) {
                    translate([x, y]) {
                        circle(d = circ_diam - shell_min_thickness, $fn = 6);
                    }
                    translate([x + circ_diam * sqrt(3/4), y + circ_diam / 2]) {
                        circle(d = circ_diam - shell_min_thickness, $fn = 6);
                    }
                }
            }
        }
        up(bot_shell) charger_shell_mask(shell);
        charger_feet_mask(bot_shell);
    }
}

phone_base(side_shell, charger_base_height());
up(bot_shell) charger_shell(side_shell);
up(bot_shell + charger_base_height() - eps) {
    phone_corners(side_shell, phone_corner_size,
            phone_height * phone_corner_gap + charger_height -
            charger_base_height() + eps);
}
