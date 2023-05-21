include <BOSL2/std.scad>
include <lib/production.scad>
include <lib/morescrews.scad>

opening = [ 60, 8, 40 ];

margin = 8;

side_shell = 5 * 0.6;

bottom_shell = 2;

rounding = side_shell / 2;

screw = [ 5, 9, 4 ];

eps = 0.01;

difference() {
    cuboid(
        opening + [ side_shell * 2, side_shell * 2, bottom_shell ],
        rounding = rounding,
        except = BACK,
        teardrop = true,
        anchor = BOTTOM + BACK
    );

    up(bottom_shell) fwd(opening.y + side_shell) {
        cuboid(
            opening + [ 0, 0, eps ],
            rounding = -rounding,
            edges = TOP,
            anchor = BOTTOM + FRONT
        ) {
            position(BACK) {
                up(opening.z / 4) screw_hole(
                    screw.x, screw.y, screw.z,
                    dir = BACK
                );
                down(opening.z / 4) screw_hole(
                    screw.x, screw.y, screw.z,
                    dir = BACK
                );
            }
        }
        back(eps) up(rounding) rotate([-90, 0, 0]) cuboid(
            [ opening.x - 2 * margin, opening.z + eps, side_shell + 2 * eps ],
            rounding = -rounding,
            except = "Z",
            anchor = TOP + BACK
        );


    }

}
