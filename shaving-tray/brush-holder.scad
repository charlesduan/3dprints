// Brush holder.
//
include <base.scad>

function brush_arm_total_thickness() = brush_arm_cutout + brush_arm_thickness;
function brush_arm_total_width() = brush_d.x + 2 * brush_arm_thickness;

module brush_holder() {
    translate([ brush_x(), -brush_y() ]) diff() {
        brush_round = brush_arm_thickness / 5;

        // Round part of the holder
        cyl(
            h = brush_arm_total_thickness(),
            d = brush_arm_total_width(),
            chamfer = brush_round,
            anchor = BOTTOM + BACK
        ) {

            // Straight arms of the holder
            position(BOTTOM) cuboid(
                [
                    brush_arm_total_width(),
                    brush_d.y,
                    brush_arm_total_thickness()
                ],
                chamfer = brush_round,
                except = BACK,
                anchor = BOTTOM + BACK
            );

            tag("remove") position(BOTTOM) down(eps) {
                // Subtract the area between the arms
                cyl(
                    h = brush_arm_total_thickness() + 2 * eps,
                    d = brush_d.x,
                    chamfer = -brush_round,
                    anchor = BOTTOM
                );

                // Subtract the area inside the circle
                cuboid(
                    [
                        brush_d.x,
                        brush_d.y + eps,
                        brush_arm_total_thickness() + 2 * eps
                    ],
                    chamfer = -brush_round,
                    anchor = BOTTOM + BACK
                );

                cutout_rect = [
                    brush_arm_total_width() + 2 * eps,
                    brush_d.y - brush_stop
                ];

                // Subtract the cutout portion
                prismoid(
                    h = brush_arm_cutout + eps,
                    size1 = cutout_rect,
                    size2 = cutout_rect - [ 0, brush_arm_cutout ],
                    anchor = BOTTOM + BACK
                );
            }

            // The stem attachment
            stem_height = brush_d.z - stem_base_height + brush_arm_cutout;
            position(BOTTOM + BACK) fwd(brush_arm_thickness) linear_sweep(
                region = hexagon(od = outer_stem_diam),
                h = stem_height,
                anchor = FRONT + BOTTOM
            ) {
                tag("remove") position(BOTTOM) down(eps) linear_sweep(
                    region = hexagon(od = stem_diam + stem_slop),
                    h = stem_height + 2 * eps,
                    anchor = BOTTOM
                );
            }
        }

    }
}

brush_holder();
