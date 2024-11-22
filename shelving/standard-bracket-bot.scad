/*
 * Bracket for a vertical shelving standard, such as an Elfa standard. This
 * bracket goes on the inside bottom of the standard.
 */

include <../lib/production.scad>
include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

// Width of the standard.
rail_out_d = [ 26, 25.5 ];

// Inside dimensions of the rail.
rail_in_d = [ 21, 22 ];

// Thickness of the frame.
shell = 2;

// Rounding of the shell.
shell_rounding = 1;

// Amount of protrusion into the standard.
protrusion = 5;

// Screw flange width.
flange = 15;

// Flange thickness.
flange_shell = 3;

// Amount to raise the flange from flush bottom.
flange_offset = 0;

// Angle of the flange bottom.
flange_angle = 30;

// Type of screw to use for the flange.
screw_struct = screw_info("#8", head = "flat");

eps = 0.01;


diff() cuboid(
    [ rail_in_d.x, shell, rail_out_d.y + shell ],
    rounding = shell_rounding, except = [ BACK, BOT ],
    anchor = BACK + BOT
) {

    // The screw flange
    position(BOT) up(flange_offset) {
        if (flange_angle == 0) {
            cuboid(
                [ rail_in_d.x, flange + shell / 2, flange_shell ],
                rounding = shell_rounding, except = [ BACK, BOT ],
                anchor = BACK + BOT
            ) position (TOP) fwd(shell / 4) screw_hole(
                screw_struct, length = shell + 10, anchor = "head_top"
            );
        } else {
            flange_rise = flange * tan(flange_angle);
            prismoid(
                [ rail_in_d.x, shell / 2 ], [ rail_in_d.x, shell / 2 + flange ],
                h = flange_rise,
                shift = [ 0, -flange / 2 ],
                rounding = [ 0, 0, shell_rounding, shell_rounding ],
                anchor = BACK + BOT
            ) position (TOP) fwd(shell / 4) screw_hole(
                screw_struct, length = shell + 10, anchor = "head_top"
            );
        }
    }

    // The top protrusion
    position(TOP) cuboid(
        [ rail_in_d.x, protrusion + shell / 2, shell ],
        rounding = shell_rounding, except = BOT,
        anchor = FRONT + TOP
    );

    // The inside protrusion
    position(BOT) up(rail_in_d.y) cuboid(
        [ rail_in_d.x, protrusion + shell / 2, shell ],
        anchor = TOP + FRONT
    );

    // The bottom protrusion
    position(BOT) cuboid(
        [ rail_in_d.x, protrusion + shell / 2, shell ],
        anchor = BOT + FRONT
    );

    // The side protrusion
    position(BOT + LEFT) cuboid(
        [ shell, protrusion + shell / 2, rail_in_d.y ],
        anchor = BOT + LEFT + FRONT
    );


}
