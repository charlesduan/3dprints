/*
 * Replacement front plastic piece for Hiplok DX bike lock.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

// Flange into which the piece is inserted. x is the center-to-center distance
// between the flanges, y the diameter, z the depth.
flange_d = [ 76, 12.8, 6.2 ];

// Diameter of the bolt hole. x is the top diameter, y the bottom diameter, z
// the countersink depth.
hole_d = [ 12.5, 6, 4.5 ];

// Shell around the flanges. x is the extra diameter, y is ignored, z the
// thickness.
shell_d = [ 6, 0, 2 ];

eps = 0.01;

function top_d() = hole_d.x + shell_d.x * 2;

difference() {

    union() {
        hull() xcopies(flange_d.x, 2) cyl(
            h = shell_d.z,
            d1 = top_d(),
            d2 = top_d() - 2 * shell_d.z,
            anchor = BOTTOM
        );
        xcopies(flange_d.x, 2) up(eps) cyl(
            h = flange_d.z + eps,
            d = flange_d.y,
            anchor = TOP
        );
    }
    xcopies(flange_d.x, 2) up(shell_d.z + eps) {
        cyl(
            h = shell_d.z + flange_d.z + 2 * eps,
            d = hole_d.y,
            anchor = TOP
        );
        cyl(
            h = hole_d.z + eps,
            d1 = hole_d.y,
            d2 = hole_d.x + 2 * eps,
            anchor = TOP
        );
    }
}

