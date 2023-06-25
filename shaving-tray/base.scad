
include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

include <params.scad>

eps = 0.01;

// The diameter of the outer rim of the soap holder.
function soap_outer_width() = soap_d.x + soap_d.y * 2;

// The true tray rim, accounting for the sloped portion.
function whole_rim() = point2d(rim) + [ rim.z, rim.z ];

// The true inner dimensions of the tray.
function tray_space() = point2d(tray_d) - 2 * whole_rim();

// The width of the razor stand, including the sidebearings.
function razor_stand_width() = razor_d.x + 2 * razor_margin;

// The razor stand has two constraints to its position:
//
// (1) The width of the razor head must fit on the tray
// (2) The edge of the razor handle must avoid the soap dish
//

// The closest to the x axis that the razor stand's center can go is the soap
// tray's width plus half the razor stand's width.
function min_razor_stand_y() = soap_outer_width() + razor_stand_width() / 2;

// The furthest the razor can go is the total tray size, minus half the razor's
// total width.
function max_razor_stand_y() =
    whole_rim().y
    + tray_space().y
    - razor_total_size.x / 2;

assert(min_razor_stand_y() < max_razor_stand_y());
function razor_stand_y() = (min_razor_stand_y() + max_razor_stand_y()) / 2;


// The minimum and maximum x positions of the brush holder. The minimum is
// defined by the edge of the soap dish; the right is the edge of the tray.
function min_brush_x() = soap_outer_width();
function max_brush_x() = whole_rim().x + tray_space().x;
function brush_x() = (min_brush_x() + max_brush_x()) / 2;

// The brush stand's edge cannot be past the razor's edge. This is an
// approximation but it should be fine.
function brush_y() = razor_stand_y()
    - razor_total_size.x / 2
    - brush_d.x / 2 - brush_d.y;

