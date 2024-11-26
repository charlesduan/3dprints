/*
 * An adapter that lets a vacuum (or an air blower) function in a crevice
 * accessible through a thin slot.
 */
include <../lib/production.scad>
include <../BOSL2/std.scad>

// Hose coupling dimensions, in [ hose outer diameter, coupling length ]
hose_d = [ 32.5, 30 ];

// Slot dimensions. x and y are the opening size, and z is the downward travel.
slot_d = [ 150, 7, 60 ];

// Length of the coupling from the hose opening to the slot.
coupling_length = 50;

// Height of the opening slot for air to come out.
slot_height = 20;

// Shell thickness.
shell = 1;

// Hose shell.
hose_shell = 2;

eps = 3;


/*
 * The curved slot opening area. The XY plane will cut across the top of the
 * slot opening, so the curvature area is lowered accordingly.
 */
down(slot_height - slot_d.y) difference() {
    intersection() {
        // Outer cylinder
        xcyl(h = slot_d.x, r = slot_d.y);
        // Limited to the back bottom quadrant, plus an eps extension above.
        up(eps) cuboid(
            [ slot_d.x + 2 * eps, slot_d.y + eps, slot_d.z + 2 * eps ],
            anchor = TOP + FRONT
        );
    }
    // The inner cylinder for removal.
    xcyl(h = slot_d.x - 2 * shell, r = slot_d.y - shell);
    // Remove a cuboid above the bottom half of the cylinder, to erase the small
    // extrusion above the bottom half of the cylinder that the removal cylinder
    // failed to cut out.
    cuboid(
        [ slot_d.x - 2 * shell, slot_d.y - shell, 2 * eps ],
        anchor = BOT + FRONT
    );
}

// The remainder of the opening area.
up(eps) difference() {
    rect_h = slot_height - slot_d.y;
    // The outer rectangular portion.
    cuboid(
        [ slot_d.x, slot_d.y, rect_h + eps ],
        anchor = TOP + FRONT
    );
    // The inside portion.
    up(eps) fwd(eps) cuboid(
        [ slot_d.x - 2 * shell, slot_d.y - shell + eps, rect_h + 3 * eps ],
        anchor = TOP + FRONT
    );
}

module tube_coupling(add, flat_back, diam, flat_x, flat_y) {
    // Height of the trapezoidal tube portion.
    rect_tube_h = slot_d.z - slot_height;

    // If we look directly facing the piece, we ideally want straight diagonal
    // lines going up from the slot to the hose coupling. This means that the
    // rectangular trapezoidal part has a with that linearly interpolates the
    // width between the slot base and the tube coupling.
    tube_frac = rect_tube_h / (rect_tube_h + coupling_length);
    upper_wid = lerp(flat_x, diam, tube_frac);

    bot_rect = back(flat_back, rect([ flat_x, flat_y ], anchor = FRONT));
    mid_rect = back(flat_back, rect([ upper_wid, flat_y ], anchor = FRONT));
    circ = back(slot_d.y / 2, circle(d = diam));
    skin([
        path3d(bot_rect, -add),
        path3d(bot_rect, eps),
        path3d(mid_rect, rect_tube_h),
        path3d(circ, rect_tube_h + coupling_length),
        path3d(circ, rect_tube_h + coupling_length + eps + add)
    ], slices = 10, method = "reindex");
}

difference() {
    tube_coupling(0, 0, hose_d.x + 2 * hose_shell, slot_d.x, slot_d.y);
    tube_coupling(
        eps, shell, hose_d.x, slot_d.x - 2 * shell, slot_d.y - 2 * shell
    );
}

up(coupling_length + slot_d.z - slot_height) back(slot_d.y / 2) tube(
    h = hose_d.y, id = hose_d.x, od = hose_d.x + 2 * hose_shell,
    anchor = BOT
);

