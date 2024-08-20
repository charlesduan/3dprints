include <BOSL2/std.scad>
include <../lib/production.scad>

// Width of the box
width = 160;
// Length of the box
length = 140;

// Difference between top and bottom dimensions of the box
inset = 40;

// Height of the box
height = 30;

// Corner radius of box
corner_rounding = 20;

// Thickness of the box walls
shell = 0.6 * 3;

eps = 0.01;

difference() {
    prismoid(
        size1=[width - inset, length - inset],
        size2=[width, length],
        h=height,
        rounding=corner_rounding
    );

    up(shell) {
        bot_offset = shell * (inset / 2 / height);
        prismoid(
            size1=[width - inset - bot_offset, length - inset - bot_offset],
            size2=[width - 2 * shell, length - 2 * shell],
            h=height - shell + eps,
            rounding=corner_rounding - shell
        );
    }
}


