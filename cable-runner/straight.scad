include <../lib/production.scad>
include <../lib/nails.scad>
include <BOSL2/std.scad>

// x is the length of the straight run, y and z are the cross-section.
size = [ 100, 20, 10 ];

// The thickness of the runner.
shell = 0.6 * 3;

// The inner rounding radius. The outer rounding radius is computed.
inner_round = 1;

// Relative positions of the nail holes.
nail_holes = [ 0.3, 0.7 ];

eps = 0.01;

/*
 * The runner itself.
 */
diff("remove hole", keep = "triangle") cuboid(
    size + [ 0, 2 * shell, shell ],
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

