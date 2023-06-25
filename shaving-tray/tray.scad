include <shaving-tray/base.scad>

module tray {
    // The tray itself.
    up(rim.z + eps) diff() cuboid(
        tray_d + rim.z * UP,
        rounding = tray_d.z / 3,
        anchor = TOP + LEFT + BACK
    ) {
        tag("remove") attach(TOP, overlap = -eps) prismoid(
            h = rim.z + eps,
            size2 = point2d(tray_d - 2 * rim),
            size1 = point2d(tray_d - 2 * rim) - 2 * [ rim.z, rim.z ],
            anchor = TOP
        );

        // Remove the inside of the soap dish in case some of the tray border
        // overlaps
        tag("remove") position(TOP + LEFT) back(
            (tray_d.y - soap_outer_width()) / 2
        ) right(soap_d.y) cyl(
            d = soap_d.x,
            h = soap_d.z + eps,
            anchor = TOP + LEFT
        ) {
            tag("remove") position(BOTTOM) up(eps) cyl(
                d = soap_d.x - 2 * soap_inner_rim,
                h = tray_d.z + 2 * eps,
                rounding2 = -tray_d.z / 3,
                anchor = TOP
            );
        }

    }

    // Soap dish holder.
    fwd(soap_outer_width() / 2) diff() tube(
        od = soap_outer_width(),
        id = soap_d.x,
        h = soap_d.z,
        anchor = BOTTOM + LEFT
    ) {
        tag("remove") position(TOP) rounding_cylinder_mask(
            d = soap_outer_width(), rounding = soap_d.y / 3
        );
        tag("remove") position(TOP) rounding_hole_mask(
            d = soap_d.x, rounding = soap_d.y / 3
        );
    }


    // The razor stand. The overall shape is a prismoid, the head of the razor
    // resting on the wider side.
    translate([
        whole_rim().x + (tray_space().x - razor_total_size.y) / 2,
        -razor_stand_y(),
        -eps
    ]) diff() prismoid(
        size1 = [ razor_stand_width(), razor_d.x / 2 + eps ],
        size2 = [
            razor_stand_width(), razor_d.x / 2 + razor_d.z + eps
        ],
        h = razor_d.y,
        shift = [ 0, razor_d.z / 2 ],
        orient = RIGHT,
        spin = 90,
        anchor = FRONT + BOTTOM
    ) {

        // Remove a cutout for the razor itself.
        tag("remove") attach(BACK) cyl(
            d = razor_d.x,
            h = razor_d.y * 3,
            orient = FRONT
        );

        // Remove the middle portion, leaving a front and back stand region.
        tag("remove") attach(FRONT) up(eps) cuboid(
            [
                razor_stand_width() + 2 * eps,
                razor_d.y - razor_holder_thickness * 2,
                razor_d.x / 2 + razor_d.z + 2 * eps,
            ],
            anchor = TOP
        );
    }

    // Brush and bowl stem
    translate([ brush_x(), -brush_y() ]) {
        linear_sweep(
            region = hexagon(od = stem_diam),
            length = brush_d.z / 2,
            anchor = BOTTOM
        ) {
            position(BOTTOM) linear_sweep(
                region = hexagon(od = outer_stem_diam),
                length = stem_base_height,
                anchor = BOTTOM
            );
        }
    }
}

