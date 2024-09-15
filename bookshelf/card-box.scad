include <BOSL2/std.scad>
include <lib/production.scad>
include <lib/tessellate.scad>

deck_thickness = 45;
card_height = 105;
card_width = 105;

thumb_width = 20;
thumb_height = 20;

bottom_rim = 7;

shell = 1.2;

eps = 0.01;

hex_size = 10;
hex_thickness = 3;

module hexagons() {
    w = card_width - 2 * bottom_rim;
    l = card_height - 2 * bottom_rim - thumb_height;
    for (i = [-1, 1]) {
        translate([-w / 2, i * (deck_thickness + shell) / 2, bottom_rim]) {
            rotate([90, 0, 0]) {
                down(shell / 2 + eps) linear_extrude(shell + 2 * eps) {
                    intersection() {
                        square([w, l], center = false);
                        hex_tessellate(w, l, hex_size) {
                            hexagon(d = hex_size - hex_thickness);
                        }
                    }
                }
            }
        }
    }
}

difference() {
    cuboid([card_width + 2 * shell, deck_thickness + 2 * shell,
            card_height + shell],
            chamfer = shell * 3 / 4, except = TOP,
            anchor = BOTTOM);

    // Inside cutout
    up(shell) cuboid([card_width, deck_thickness, card_height + eps],
            anchor = BOTTOM);

    // Bottom cutout
    down(eps) cuboid([card_width - 2 * bottom_rim,
            deck_thickness - 2 * bottom_rim,
            shell + 2 * eps],
            rounding = (min(card_width, deck_thickness) - 2 * bottom_rim) / 2,
            edges = "Z",
            anchor = BOTTOM);

    // Thumb holes
    ydim = deck_thickness + 2 * shell + 2 * eps;
    up(card_height - thumb_height + thumb_width / 2 + shell) {
        rotate([90, 0, 0]) cylinder(d = thumb_width, h = ydim, center = true);
    }
    up(card_height + shell + eps) {
        cuboid([thumb_width, ydim, thumb_height - thumb_width / 2 + eps],
                rounding = -3, edges = TOP, except = "X",
                anchor = TOP);
    }

    hexagons();
}

