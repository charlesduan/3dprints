/*
 * Tessellates the XY plane with a given shape. The parameters are:
 *
 * - width/length: the bounding rectangle of the tessellation. The tessellation
 *   will go beyond this range so it will be necessary to use an intersection()
 *   to contain the tessellation to the proper range.
 *
 * - size: the size of the tessellation element
 *
 * The children of the module are the shapes to be tessellated. They are assumed
 * to be centered at the origin such that the bottom and left edges of the
 * tessellation range will be half cut off.
 */

module hex_tessellate(width, length, size) {
    sr3o2 = size * sqrt(3) / 2;
    sr3o4 = size * sqrt(3) / 4;
    for (x = [0 : size * 3 / 2 : width + size]) {
        for (y = [ 0 : sr3o2 : length + sr3o2 ]) {
            translate([x, y]) children();
            translate([x + size * 3 / 4, y + sr3o4]) children();
        }
    }
}

