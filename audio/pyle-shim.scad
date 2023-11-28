include <../lib/production.scad>
include <../lib/morescrews.scad>
include <BOSL2/std.scad>

// Hex nut dimensions. x is the outer diameter, y unused, z the thickness.
nut_d = [ 6.35, 0, 2.4 ];

// Diameter of the mounting screws.
mount_shank_d = 3.2;

// Size of the mounting screw flange.
mount_flange_d = 4.2;

// Thickness of the flanges.
flange_thickness = 2;

// Distance between the offset holes. y is the offset from the flange.
offset_pos = [ 23.3, 4.7 ];

// Diameter of the offset holes.
offset_d = 3.8;

// Thickness of the mounting shim, at its thinnest point.
min_shell = 0.75;

// Extra space around the edge.
perimeter = 3.1;

eps = 0.01;

module circles() {
    left(offset_pos.x / 2) circle(d = offset_d);
    left(-offset_pos.x / 2) circle(d = offset_d);
}

difference() {
    union() {

        // Overall body
        down(nut_d.z + min_shell) linear_extrude(nut_d.z + min_shell) {
            offset(r = perimeter) hull() {
                circles();
                back(offset_pos.y) circle(d = mount_flange_d);
            }
        }

        // Flanges
        down(eps) linear_extrude(flange_thickness + eps) circles();
    }

    back(offset_pos.y) {

        // Screw hole
        up(flange_thickness + eps) cyl(
            d = mount_shank_d,
            h = flange_thickness + nut_d.z + min_shell,
            anchor = TOP
        );

        // Nut holder
        down(min_shell + nut_d.z + eps) {
            linear_extrude(nut_d.z + eps) hexagon(od = nut_d.x);
        }
    }
}
