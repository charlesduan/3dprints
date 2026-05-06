/*
 * A jig for drilling dowel holes. This is meant for installing dowels on the
 * sides of pieces of wood.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Width of the wood.
wood_width = 0.75 * 25.4;

// Dimensions of the jig. x is the width; y is ignored; z is the height of the
// jig's base plate.
jig_d = [ 70, 0, 10 ];

// Hole diameter.
hole_diam = 8.3;

// Dimensions of any additional ring above the jig's base plate. x is additional
// thickness of the ring; y is ignored; z is the height above the base plate.
ring_d = [ 2, 0, 10 ];

// Side plate depth.
side_depth = 20;
