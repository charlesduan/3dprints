include <../BOSL2/std.scad>
include <../lib/production.scad>

// Size of the card to be held.
opening = [ 64, 8, 40 ];

// Size of flanges on the front left and right.
margin = 8;

// Thickness of sides.
side_shell = 3 * 0.6;

// Thickness of bottom.
bottom_shell = 2;

// Rounding on all edges.
rounding = side_shell / 2;

eps = 0.01;

// The overall body
diff() cuboid(
    opening + [ side_shell * 2, side_shell * 2, bottom_shell ],
    rounding = rounding,
    except = BACK,
    teardrop = true,
    anchor = BOTTOM + BACK
) tag("remove") {

    // Remove the inside
    position(TOP) up(eps) cuboid(
        opening + [ 0, 0, eps ],
        rounding = -rounding,
        edges = TOP,
        anchor = TOP
    ) {

        /* For screw holes
        attach(BACK, TOP) ycopies(opening.z / 2) screw_hole(
            "#6,10", head = "flat"
        );
        */
    }

    // The front opening.
    position(TOP + FRONT) fwd(eps) orient(FRONT) cuboid(
        [ opening.x - 2 * margin, opening.z + eps, side_shell + 2 * eps ],
        rounding = -rounding,
        except = "Z",
        anchor = TOP + BACK
    );


}

