/*
 * Shim for music stand.
 */
include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <../lib/production.scad>

// Degrees of elevation.
angle = 5;

// Dimensions of the shim. x is the lateral width, y the depth, and z the extra
// height over any necessary angle.
shim_d = [ 160, 30, 2 ];

// Rounding of corners.
rounding = 1;

eps = 0.01;

xrot(90) difference() {

    shim_top = shim_d.z + adj_ang_to_opp(shim_d.y, angle);
    xsec = round_corners([
        [ shim_d.y, 0 ],
        [ shim_d.y, shim_d.z ],
        [ 0, shim_top ]
    ], radius = rounding, closed = false);

    linear_sweep(concat(xsec, [[0,0]]), shim_d.x);
    up(shim_d.x) zflip() path_sweep(
        mask2d_roundover(rounding),
        concat([[shim_d.y, -5]], xsec, [[-5, shim_top]]),
        uniform=false
    );
    /*
    path_sweep(
        mask2d_roundover(rounding),
        concat([[shim_d.y, -5]], xsec, [[-5, shim_top]]),
        uniform=false
    );
    */
}
