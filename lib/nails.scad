
// Make a single nail hole.
module nail_hole(entry_point, zrot, vert = true, nail_diam = 2.5, eps = 0.01) {
    translate(entry_point) rotate([45, 0, zrot]) up(eps) {
        cylinder(h = whole_height() * sqrt(2) + eps, d = nail_diam,
                anchor = TOP + (vert ? BACK : FRONT));
    }
}

//
// Makes a nail hole positioned at the origin, as if the XZ plane were the wall
// into which the nail will go.
//
module nail_mask(
    nail_diam = 2.5,
    head_diam = 4,
    min_length = 100,
) {
    cyl(
        h = 2 * min_length,
        d = nail_diam,
        anchor = CENTER,
        orient = BACK + BOT
    );
    cyl(
        h = min_length,
        d = head_diam,
        anchor = BOT,
        orient = FRONT + TOP
    );
}

// Given a corner and a distance from that corner, constructs a triangular
// flange to support a nail hole looking like this from a cross-section:
//
//         d     Corner
// \ \-----------
// x\ \xxxxxxxxx|
//  x\ \xxxxxxxx|
//   x\ \xxxxxxx|
//    x\ \xxxxxx|
//     x\ \xxxxx| d
//      x\ \xxxx|
//       x\ \xxx|
//        x\ \xx|
//         x\ \x|
//          x\ \|
//           x\ 
//            x\
//             x|
//
// The regions marked "x" will be filled with material, and a nail hole will be
// cut into it.
//
// The triangle itself is tagged "triangle," and the hole is tagged "hole" for
// diff() purposes.
//
module nail_triangle(
    // Whether the entry of the nail is against a horizontal or vertical face
    vert = false,
    // Side length of the triangle
    d = 10,
    // Thickness of material around the nail hole
    shell = 1.2,
    // Nail hole diameter
    nail_diam = 2.5,
    // Nail head diameter
    head_diam = 4,
    // Rounding of the exit corner of the nail hole.
    rounding = 0
) {
    width = nail_diam + 2 * shell;

    tag_diff("triangle") prismoid(
        size1 = [ width, 0 ],
        size2 = [ width, d ],
        h = d,
        shift = [ 0, -d / 2 ],
        anchor = TOP + BACK
    ) {
        position(TOP + BACK) intersect() {
            cyl_mask = vert
                ? [ width, d, 2 * d ]
                : [width, 2 * d, 2 * d ];
            cuboid(cyl_mask, anchor = TOP + BACK) {
                tag("intersect") position(BACK) cyl(
                    d = width,
                    h = 4 * d,
                    anchor = CENTER,
                    orient = FRONT + UP
                );
            }
        }
        position(TOP + FRONT) tag("remove") {
            nail_mask(
                nail_diam = nail_diam,
                head_diam = head_diam
            );
        }
        if (rounding > 0) {
            tag("remove") fwd(vert ? 0 : sqrt(2) * (shell + nail_diam / 2)) {
                edge_mask(FRONT + TOP) {
                    rounding_edge_mask(l = width + 0.1, r = rounding);
                }
            }
        }
    }
    tag("hole") fwd(d) nail_mask(
        nail_diam = nail_diam,
        head_diam = head_diam
    );
}

