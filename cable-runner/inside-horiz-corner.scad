//include <../lib/production.scad>
include <BOSL2/std.scad>

/*
 * Creates a corner element for a cable runner for a horizontal-running cable
 * that traverses an inside corner bend.
 */

// x is the length of the cable runner body from wall to end, in both the x and
// y directions. y is the runner channel width (side to side), and z the channel
// height (wall to end).
size = [ 50, 20, 10 ];

// Thickness of the outside cover.
shell = 0.6 * 3;

// Inside radius of the corner bend of the channel where the cables go
channel_r = 20;

// Rounding radius for the wall corner.
wall_rounding = 5;

// Rounding of the inside edges of the runner.
rounding = 5;

eps = 0.01;

/*
 * The runner has its lower corner at the origin, with cable outlets along the
 * positive X and negative Y axes.
 */
diff() cuboid(
    [ size.x, size.x, size.y + 2 * shell ],
    rounding = wall_rounding,
    edges = BACK + LEFT,
    anchor = BACK + BOTTOM + LEFT
) {

    // Shape the outside shell.
    position(BACK + BOTTOM + LEFT) down(eps) tag("remove") {

        cyl_center = size.z + channel_r;
        runner_edge = size.z + shell;
        outer_round = rounding + shell + eps;
        tot_h = size.y + 2 * (shell + eps);

        // Round portion
        translate([cyl_center, -cyl_center]) cyl(
            r = channel_r - shell,
            h = tot_h,
            rounding = -outer_round,
            anchor = BOTTOM
        );

        // Parallel to X axis
        translate([cyl_center, -runner_edge]) cuboid(
            [ size.x, size.x, tot_h ],
            rounding = -outer_round,
            edges = BACK,
            except = "Z",
            anchor = BACK + BOTTOM + LEFT
        );

        // Parallel to Y axis
        translate([runner_edge, -cyl_center]) cuboid(
            [ size.x, size.x, tot_h ],
            rounding = -outer_round,
            edges = LEFT,
            except = "Z",
            anchor = BACK + BOTTOM + LEFT
        );
    }

    // Cut out the inside channel of the runner. Anchor is the center of the
    // back corner.
    position(BACK + LEFT) translate([-eps, eps, 0]) tag("remove") {

        // Parallel to X axis
        cuboid(
            [ size.x + 2 * eps, size.z, size.y ],
            rounding = rounding,
            edges = FRONT,
            except = "Z",
            anchor = BACK + LEFT
        );

        // Parallel to Y axis
        cuboid(
            [ size.z, size.x + 2 * eps, size.y ],
            rounding = rounding,
            edges = RIGHT,
            except = "Z",
            anchor = BACK + LEFT
        );

        cyl_center = size.z + channel_r + eps;
        tag_diff("remove") tag("blah") cuboid(
            [ cyl_center, cyl_center, size.y ],
            anchor = BACK + LEFT
        ) {
            tag("remove") position(FRONT + RIGHT) cyl(
                h = size.y + 2 * eps,
                r = channel_r,
                rounding = -rounding - eps,
                anchor = CENTER
            );
        }
    }
}
