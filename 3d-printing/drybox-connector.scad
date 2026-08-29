/*
 * A connector between a drybox and a filament tube. The connector is
 * effectively a socket screw with a hole in it, the top of the hole being big
 * enough for the filament conduit and the bottom big enough for the filament
 * itself.
 */

include <../lib/production.scad>
include <../BOSL2/std.scad>
include <../BOSL2/screws.scad>

// Diameter of the conduit
tube_diam = 4.45;

// Diameter of the filament
filament_diam = 3;

// Type of screw
screw_thread = screw_info("M6", head = "socket");

// Length of the screw insertion portion (the part that goes into the drybox)
screw_l = 10;

// Height of the screw head (where the conduit sits)
screw_head_height = 10;

// How much of the screw to leave unthreaded; should be about the thickness of
// the drybox shell
screw_unthread_l = 2;

// How far down, compared to the screw head, the conduit will sit. If zero, it
// will be flush with the screw head. If positive, it will be above the screw
// head. If negative, it will sit within the screw insertion portion. A good
// option is a negative value with absolute value less than screw_unthread_l.
stopper_shell = -1;

eps = 0.01;

echo_struct(screw_thread);

// front_half() // To see the cross-section
diff() screw(
    struct_set(screw_thread, "head_height", screw_head_height),
    l = screw_l,
    thread_len = screw_l - screw_unthread_l,
    anchor = BOTTOM + LEFT
) {
    tag("remove") position(BOTTOM) down(eps) cyl(
        h = screw_l + screw_head_height + 2 * eps,
        d = filament_diam, anchor = BOTTOM
    );
    tag("remove") position(TOP) up(eps) cyl(
        d = tube_diam, h = screw_head_height - stopper_shell + eps,
        anchor = TOP
    );
}

