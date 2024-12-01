/*
 * An adapter that lets a vacuum function in a crevice accessible through a thin
 * slot. This differs from the blower model by not directing the inlet in any
 * particular direction.
 */
include <../lib/production.scad>
include <../BOSL2/std.scad>

// Hose coupling dimensions, in [ hose outer diameter, coupling length ]
hose_d = [ 32.25, 40 ];

// Slot dimensions. x and y are the opening size, and z is the downward travel.
slot_d = [ 100, 6, 70 ];

// Length of the coupling from the hose opening to the slot.
coupling_length = 30;

// Height of the opening slot for air to come out.
slot_height = 2;

// Shell thickness.
shell = 1.5;

// Hose shell.
hose_shell = 2;

eps = 0.01;

// The slot area.
//
diff() up(eps) cuboid(
    [ slot_d.x, slot_d.y, slot_height + eps ],
    anchor = TOP
) tag("remove") position(FRONT) fwd(eps) cuboid(
    [ slot_d.x - 2 * shell, slot_d.y + 2 * eps, slot_height + 3 * eps ],
    anchor = FRONT
);

module tube_coupling(add, flat_back, diam, flat_x, flat_y) {
    // Height of the trapezoidal tube portion.
    rect_tube_h = slot_d.z - slot_height;

    // If we look directly facing the piece, we ideally want straight diagonal
    // lines going up from the slot to the hose coupling. This means that the
    // rectangular trapezoidal part has a with that linearly interpolates the
    // width between the slot base and the tube coupling.
    tube_frac = rect_tube_h / (rect_tube_h + coupling_length);
    upper_wid = lerp(flat_x, diam, tube_frac);

    bot_rect = rect([ flat_x, flat_y ]);
    mid_rect = rect([ upper_wid, flat_y ]);
    circ = circle(d = diam);
    skin([
        path3d(bot_rect, -add),
        path3d(bot_rect, eps),
        path3d(mid_rect, rect_tube_h),
        path3d(circ, rect_tube_h + coupling_length),
        path3d(circ, rect_tube_h + coupling_length + eps + add)
    ], slices = 10, method = "reindex");
}

difference() {
    // Outside face
    tube_coupling(0, 0, hose_d.x + 2 * hose_shell, slot_d.x, slot_d.y);
    // Remove inside
    tube_coupling(
        eps, shell, hose_d.x, slot_d.x - 2 * shell, slot_d.y - 2 * shell
    );
}

// Top hose tube connector
up(coupling_length + slot_d.z - slot_height) tube(
    h = hose_d.y, id = hose_d.x, od = hose_d.x + 2 * hose_shell,
    anchor = BOT
);

