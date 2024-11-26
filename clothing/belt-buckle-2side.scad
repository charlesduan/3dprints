/*
 * A belt buckle that has a friction-based attachment on both sides.
 */

include <../BOSL2/std.scad>
include <../BOSL2/rounding.scad>
include <../lib/production.scad>

// Overall lateral size of the buckle
outer_width = 60;

// This should equal the width of the strap
inner_height = 32;

// Thickness of the buckle
thickness = 4.5;

// Space between the outer perimeter and any internal features.
rim_width = 5;

// Vertical rounding
thickness_rounding = 1.5;

// Rounding of the outer corners along the XY plane
corner_rounding = 6;

// Thickness of the slots for the strap. This should be just slightly bigger
// than the strap thickness itself.
slot_thickness = 3;

// Width of the bar between slots where a loop of strap goes around.
wraparound_width = 6;


eps = 0.01;

difference() {

    // Outer perimeter. We draw a rectangle with corner_rounding, and then raise
    // it upwards using thickness_rounding.
    offset_sweep(
        round_corners(square([outer_width, inner_height + 2 * rim_width],
                anchor = LEFT),
            radius = corner_rounding),
        height = thickness,
        bottom = os_circle(r=thickness_rounding),
        top = os_circle(r=thickness_rounding)
    );

    // The rightward slot.
    slot_diff = rim_width + slot_thickness / 2;
    slot_wrap_diff = rim_width + 3 * slot_thickness / 2 + wraparound_width;
    xcopies([
            slot_diff, slot_wrap_diff,
            outer_width - slot_wrap_diff, outer_width - slot_diff
    ]) {
        down(eps) cuboid(
            [slot_thickness, inner_height, thickness + 2 * eps],
            rounding = min(slot_thickness / 2, corner_rounding - rim_width),
            edges = "Z",
            anchor = BOTTOM
        );
    }

}
