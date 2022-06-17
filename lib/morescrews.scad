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
