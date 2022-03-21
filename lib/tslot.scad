/*
 * A slot for a T-style sliding joint. The T will point in the positive x axis
 * direction, with dims being a three-element vector of the dimensions and
 * thickness defining the width of the arms. Along the main body of the T,
 * length extra will be added (a way of cutting out excess beyond the slot
 * itself).
 *
 * The length (dims.x) specifies the distance to the center of the T arms, not
 * the end. This way, a corresponding slot and insert can be made by altering
 * just the thickness values to account for printing slop.
 */
module t_slot(dims, thickness, extra = 0.01, insert = true) {
    cuboid([dims.x + extra, thickness, dims.z], anchor = BOTTOM + RIGHT);
    left(dims.x) {
        cuboid([thickness, dims.y + thickness, dims.z],
                anchor = BOTTOM, chamfer = thickness / 4,
                edges = [ "Z" ]);
    }

}


