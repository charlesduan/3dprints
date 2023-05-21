include <lib/production.scad>
include <BOSL2/std.scad>

/*
 * A box is constructed with 3D printed corners that hold faces made of solid
 * thin material. This program constructs the corner device. The bottom face
 * will be on the XY plane in the positive direction. The other faces will run
 * through the X and Y axes, respectively, at angles defined with respect to the
 * XY face.
 */

// Thickness of the face material
face_thickness = 0.5;

// Thickness of the corner on each side of the face material
shell = 2;

// Angle of the plane running through the X axis.
x_angle = 100;

// Angle of the plane running through the Y axis.
y_angle = 100;


