include <BOSL2/std.scad>
include <lib/production.scad>

lower_outer_diam = 63;
lower_inner_diam = 54;
lower_flange = 21;

lower_shell = 5;

lower_height = 12;
lower_rim_height = 1;

upper_outer_diam = 59;
upper_inner_diam = 57;

upper_shell = 0.6 * 4;

upper_height = 12;
upper_rim_height = 1;

funnel_slope = 2.5;

eps = 0.01;

function angled_funnel_height() =
        funnel_slope * abs(upper_outer_diam - upper_inner_diam);

difference() {

    // Outside of funnel.
    union() {
        // Dosing cup
        cylinder(d = upper_outer_diam + 2 * upper_shell, h = upper_height + eps,
                anchor = BOTTOM);

        up(upper_height) {

            // Angle
            cylinder(d1 = upper_outer_diam + 2 * upper_shell,
                    d2 = lower_outer_diam + 2 * lower_shell,
                    h = angled_funnel_height(), anchor = BOTTOM);

            // Portafilter
            up(angled_funnel_height() - eps) {
                cylinder(d = lower_outer_diam + 2 * lower_shell,
                        h = lower_height + eps, anchor = BOTTOM);
            }
        }
    }

    // Inside of funnel

    // Dosing cup rim
    down(eps) cylinder(d = upper_inner_diam, h = upper_height + 2 * eps,
            anchor = BOTTOM);

    // Dosing cup insert
    down(eps) cylinder(d = upper_outer_diam,
            h = upper_height - upper_rim_height + eps, anchor = BOTTOM);

    // Dosing cup rim support
    up(upper_height - upper_rim_height) {
        cylinder(d1 = upper_outer_diam, d2 = upper_inner_diam,
                h = upper_outer_diam - upper_inner_diam);
    }

    // Angle
    up(upper_height) {
        cylinder(d1 = upper_inner_diam, d2 = lower_inner_diam,
                h = angled_funnel_height() + eps, anchor = BOTTOM);

        up(angled_funnel_height()) {
            // Portafilter rim
            cylinder(d = lower_inner_diam, h = lower_height + eps,
                    anchor = BOTTOM);

            up(lower_rim_height) {

                // Lower insert height with epsilon
                lih = lower_height - lower_rim_height + eps;

                // Portafilter insert
                cylinder(d = lower_outer_diam, h = lih, anchor = BOTTOM);

                // Cutouts
                for (i = [1 : 3]) {
                    rotate(120 * i) cube([lower_outer_diam + eps, lower_flange,
                            lih], anchor = BOTTOM + LEFT);
                }
            }
        }

    }

}

