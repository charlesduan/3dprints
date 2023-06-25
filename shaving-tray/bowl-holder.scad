include <shaving-tray/base.scad>

// The bowl holder.
module bowl_holder() {
    intersection() {

        // The bowl is positioned so that it is centered over the brush but the
        // edge of the bowl hits the edge of the tray. This is generated
        // backwards but because of symmetry across the YZ plane it is okay.
        //
        translate([ brush_x(), -bowl_outer_diam / 2 ]) cyl(
            d = bowl_d.x,
            h = bowl_arm_d.z,
            rounding = min(bowl_arm_d) / 3,
            anchor = BOTTOM
        );
        translate([ brush_x(), -brush_y() ]) {
            for (angle = [ 18 : 72 : 360 ]) {
                cuboid(
                    [ bowl_d.x, bowl_arm_d.x, bowl_arm_d.z ],
                    rounding = min(bowl_arm_d) / 3,
                    edges = "X",
                    spin = angle,
                    anchor = BOTTOM + LEFT
                );
            };
        }
    }
    translate([ brush_x(), -brush_y() ]) {
        linear_sweep(
            region = hexagon(od = outer_stem_diam),
            h = bowl_d.z - stem_base_height,
            anchor = BOTTOM
        ) {
            position(TOP) down(eps) linear_sweep(
                region = hexagon(od = stem_diam),
                h = brush_d.z / 2,
                anchor = BOTTOM
            );
        }
    }
}

