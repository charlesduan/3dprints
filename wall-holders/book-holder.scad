include <../lib/production.scad>
include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

/*
 * A shelf for holding books on the wall. This model isn't great because it
 * tends to flex too much; a better design would probably have struts or
 * something.
 */

// Dimensions of the book to be held
book_size = [ 150, 30, 220 ];

// How far the bottom of the book is to be from the wall
book_offset = 30;

// Minimum thickness of the holder
shell = 0.6 * 5;

// Height of holder up from the bottom of the book
lip_height = 25;

// Height of the back
back_height = 25;

// Top screw surrounding width
screw_surround = 15;

// Screw type
screw_type = "#8";

chamfer = shell / 3;

eps = 0.01;

difference() {
    union() {
        // Back
        down(shell) cuboid(
            [book_size.x, shell, back_height + shell],
            chamfer = chamfer,
            except = BACK,
            anchor = BOTTOM + FRONT
        );

        // Bottom
        back(shell) cuboid(
            [book_size.x, book_size.y + book_offset + 2 * shell, shell ],
            chamfer = chamfer,
            anchor = TOP + BACK
        );

        // Front
        fwd(book_size.y + book_offset) down(shell) cuboid(
            [book_size.x, shell, lip_height + shell], 
            chamfer = chamfer,
            anchor = BOTTOM + BACK
        );

        // Top screw area
        up(back_height) cyl(
            r = screw_surround, h = shell,
            chamfer = chamfer,
            orient = FRONT,
            anchor = TOP + FRONT
        );
        cuboid(
            [2 * screw_surround, shell, back_height + screw_surround],
            chamfer = chamfer,
            edges = "Z",
            anchor = BOTTOM + FRONT
        );
    }
    zcopies([ back_height / 2, back_height + screw_surround ]) {
        screw_hole(
            screw_type, head = "flat", length = 10,
            orient = FRONT,
            anchor = TOP
        );
    }
    /*
    screw_hole(
        screw.x, screw.y, screw.z,
        dir = BACK,
        at = [0, 0, back_height / 2]
    );
    screw_hole(
        screw.x, screw.y, screw.z,
        dir = BACK,
        at = [0, 0, back_height + screw_surround]
    );
    */

}
