include <BOSL2/std.scad>
include <lib/production.scad>

od = 14;
id = 9.6;
flange_d = 11.6;
thickness = 0.5;
flange_h = 0.5;

eps = 0.01;

difference() {
    union() {
        cylinder(d = od, h = thickness, anchor = BOTTOM);
        cylinder(d = flange_d, h = thickness + flange_h, anchor = BOTTOM);
    }
    down(eps) cylinder(
        d = id,
        h = flange_h + thickness + 2 * eps,
        anchor = BOTTOM
    );
}
