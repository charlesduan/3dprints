//include <../lib/production.scad>
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <../lib/morescrews.scad>

// Size of the charger. z axis should be however high the case should go.
charger = [ 66, 38, 60 ];
charger_rounding = 2;

// How much not to cut out of the front. x is the width of the side lip, y the
// rounding radius, z the vertical lip.
front_lip = [ 8, 10, 0 ];

// How large a hole to cut out of the bottom (for a plug).
bottom_cutout_size = [ 28, 23 ];

// Offset of the plug cutout, relative to the back right corner of the charger.
bottom_cutout_offset = [ 3, 7 ];


// Thickness of the casing
shell = 0.6 * 5;

// Screw cutout dimensions, [ shank diam, head diam, head depth ].
screw = [ 5, 9, 4 ];

eps = 0.01;

// The overall holder.
difference() {
    diff() cuboid(
        charger + [2 * shell, 2 * shell, shell],
        rounding = charger_rounding + shell,
        teardrop = true,
        except = TOP,
        anchor = BACK + BOTTOM
    ) {

        // Remove the space for the charger block.
        tag("remove") attach(TOP, overlap = -eps) cuboid(
            charger + [ 0, 0, eps ],
            rounding = charger_rounding,
            except = TOP,
            anchor = TOP
        );

        // Remove the front cutout.
        tag("remove") position(TOP + FRONT) fwd(eps) up(eps) offset_sweep(
            rect(
                [
                    charger.x - 2 * front_lip.x,
                    2 * (charger.z - front_lip.z)
                ],
                rounding = front_lip.y
            ),
            h = shell + charger_rounding + 2 * eps,
            top = os_circle(r = -shell / 2),
            anchor = TOP,
            orient = FRONT
        );

        // Remove the bottom cutout.
        tag("remove") position(BOTTOM + RIGHT + BACK) translate([
            -bottom_cutout_offset.x - shell,
            -bottom_cutout_offset.y - shell,
            -eps
        ]) cuboid(
            point3d(
                bottom_cutout_size, fill = shell + 2 * eps + charger_rounding
            ),
            rounding = -shell / 3,
            anchor = BOTTOM + RIGHT + BACK
        );

    }

    screw_hole(
        screw.x, screw.y, screw.z,
        dir = BACK,
        at = [ 0, -shell, shell + charger.z * 2/3 ]
    );
}
