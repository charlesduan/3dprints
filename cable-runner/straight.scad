include <params.scad>

// The length of the cable runner.
length = 100;

// Relative positions of the nail holes.
nail_holes = [ 0.3, 0.7 ];

eps = 0.01;

/*
 * The runner itself.
 */
diff("remove hole", keep = "triangle") cuboid(
    [ length, xsec.x + 2 * shell, xsec.y + shell ],
    rounding = inner_round + shell,
    edges = "X",
    except = BOTTOM,
    anchor = BOTTOM
) {

    tag("remove") position(BOTTOM) down(eps) cuboid(
        size + [ 2 * eps, 0, eps],
        rounding = inner_round,
        edges = "X",
        except = BOTTOM,
        anchor = BOTTOM
    );

    for (x = nail_holes) {
        position(BOTTOM + BACK + LEFT) right(x * size.x) {
            xrot(-90) nail_triangle(
                d = 7, rounding = inner_round + shell
            );
        }
    }
}

