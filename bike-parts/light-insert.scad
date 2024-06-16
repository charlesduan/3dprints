/*
 * Insert for a Cygolite Hotshot light.
 */

include <BOSL2/std.scad>
include <../lib/production.scad>

outer_diam = 24;
inner_diam = 19.5;
ring_thickness = 1.5;

top_thickness = 0.5;
flange_d = [ 5, 0.5, 0.5 ];
inner_shell = 0.8;

eps = 0.01;

difference() {
    union() {
        cyl(d = outer_diam, h = top_thickness, anchor = BOTTOM);

        up(eps) cyl(
            d = inner_diam, h = ring_thickness + flange_d.z + eps, anchor = TOP
        );

        down(ring_thickness + flange_d.z) intersection() {
            cyl(
                d = inner_diam + 2 * flange_d.y, h = 2 * flange_d.z,
                anchor = CENTER,
                chamfer = flange_d.z
            );
            cuboid(
                [
                    flange_d.x, inner_diam + 2 * flange_d.y + 2 * eps,
                    flange_d.z + eps
                ],
                anchor = BOTTOM
            );
        }
    }

    cyl(
        d = inner_diam - 2 * inner_shell,
        h = ring_thickness + flange_d.z + eps,
        anchor = TOP
    );
}
