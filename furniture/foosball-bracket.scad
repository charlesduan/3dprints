/*
 * Bracket for keeping a desktop foosball table on top of another table.
 */

include <../lib/production.scad>
include <BOSL2/std.scad>

// Difference between the foosball table legs and the underlying table.
bracket_dist = 47;

// Dimensions of the legs. x is the leg width; y the depth; z the thickness of
// the bracket.
leg_d = [ 74, 15, 3 ];

// Thickness of the table flange overhang.
flange_h = 20;

// Thickness of areas around surfaces.
shell = 2.5;

rounding = 0.75;

eps = 0.01;

// The desktop surface portion.
diff() cuboid(
    [ leg_d.x + 2 * shell, shell + bracket_dist + leg_d.y + shell, leg_d.z ],
    chamfer = rounding,
    except = BOTTOM,
    anchor = TOP + FRONT
) {

    tag("remove") position(BACK) fwd(shell) cuboid(
        [ leg_d.x, leg_d.y, leg_d.z + 2 * eps ],
        chamfer = -rounding,
        edges = TOP,
        anchor = BACK
    );

    position(FRONT + BOTTOM) up(eps) cuboid(
        [ leg_d.x + 2 * shell, shell, flange_h + eps ],
        chamfer = rounding,
        except = [ BACK, TOP ],
        anchor = FRONT + TOP
    );

}
