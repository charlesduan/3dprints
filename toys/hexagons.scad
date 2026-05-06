include <../BOSL2/std.scad>
include <../lib/production.scad>

long_diam = 48.4;
thickness = 5;

module hex() {
    linear_extrude(thickness) hexagon(od = long_diam);
}

module shift(x, y) {
    translate((long_diam + 3) * [ x, y ]) children();
}

hex();

shift(0, 1) front_half() hex();
shift(1, 1) left_half() front_half() hex();
shift(1, 0) linear_extrude(thickness) regular_ngon(n = 3, side = long_diam / 2);
shift(2, 0) linear_extrude(thickness) {
    w = long_diam / 2;
    h = long_diam * sqrt(3) / 4;
    polygon([ [0, 0], [w, 0], [w / 2, h], [-w / 2, h] ]);
}
