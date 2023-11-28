include <BOSL2/std.scad>
include <BOSL2/screws.scad>

module thread_mask(name, thickness, thread="coarse", oversize=0,
        tolerance=undef, anchor=BOTTOM,spin=0,orient=UP) {
    assert(is_num(thickness) && thickness > 0);
    spec = screw_info(name, thread=thread, oversize=oversize);
    threadspec = thread_specification(spec, internal=true, tolerance=tolerance);

    threaded_rod(
        d = [mean(struct_val(threadspec, "d_minor")), 
            mean(struct_val(threadspec, "d_pitch")), 
            mean(struct_val(threadspec, "d_major"))],
        l = thickness,
        pitch = struct_val(threadspec, "pitch"),     
        internal = true,
        anchor = anchor, spin = spin, orient = orient);
}

/*
 * Generates a mask for a hole into which a screw can be set. The top of the
 * screw head is set at the origin, with the screw pointing downwards.
 * Parameters are:
 *
 * shank_d:     Diameter of the screw shank
 * head_d:      Diameter of the head
 * countersink: If nonzero, the length of the countersink (the frustrum shape
 *              from the shank to the head). Default 0
 * shank_l:     Length from the end of the countersink to the end of the screw.
 *              Default 100
 * head_l:      Length from the end of the head to the end of the screw head
 *              mask. Default 100
 * dir:         Rotate the screw to point toward a vector dir.
 */
module old_screw_hole(
    shank_d, head_d, countersink = 0, shank_l = 100, head_l = 100,
    dir = DOWN, at = [0, 0, 0]
) {
    shank_r = shank_d / 2;
    head_r = head_d / 2;
    translate(at) rot(from = DOWN, to = dir) rotate_extrude(angle=360) polygon([
        [ 0, head_l ],
        [ head_r, head_l ],
        [ head_r, 0 ],
        [ shank_r, -countersink ],
        [ shank_r, -countersink - shank_l ],
        [ 0, -countersink - shank_l ]
    ]);
}


