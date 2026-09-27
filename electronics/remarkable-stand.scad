/*
 * Stand for Remarkable 2 with USB charging.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Remarkable dimensions. x and y should include additional margin. z is the
// insertion height.
device_d = [ 188.5, 5, 25 ];

// Size of feet.
foot_d = [ 7, 0.7 ];

// Positions of feet, relative to center.
foot_pos = [ device_d.x, -device_d.x ] / 2 - [ 11, -22 ];

// Vertical distance between top of plug and bottom of device.
plug_gap = 2;

// Dimensions of the USB-C plug body.
plug_d = [ 25.5, 12.5, 7.5 ];

// Horizontal offset of the port from the edge of the device. This is based on
// the "port" which includes any surrounding flange.
port_gap = 1.4;

// Rounding of the plug in the long (x) direction.
plug_round = 3.5;

// Size of the USB-C port, including any surrounding flange.
flange_d = [ 11.1, device_d.y, 1.6 ];

// Horizontal offset of the port from the edge of the plug. Note that this is
// the *right* edge of the port, while port_gap above is the *left* edge of the
// port (when looking at the device face-on).
port_plug_gap = 1.2;

// Additional size around the base. x and y are added to the device's x and y
// dimensions. z is any extra on the bottom, beyond the minimum to allow the
// plug.
base_d = [ 5, 60, 3 ];

// Width of the base legs.
base_leg_width = 20;

// Rounding of base edges.
base_round = 5;

// Additional size around the top.
top_d = [ 5, 5 ];

// Minimum shell between the dovetail and the bottom.
dovetail_shell = 0.75;

// Reduction in size for the dovetail insert.
dovetail_slop = 0.5;

// Shell thickness of any perimeters.
shell = 2.5;

eps = 0.01;
layer = 0.25;

// Height at which the base of the device will sit.
function base_h() = plug_gap + plug_d.z + base_d.z;

// The amount of inset from the left edge of the device to the right edge of the
// plug.
function plug_inset() = port_gap + flange_d.x + port_plug_gap;

// The full dimensions of the plug, accounting for the inset.
function plug_inset_d() = [ plug_inset() + shell, plug_d.y, plug_d.z ];

// Right edge of the plug (which is on the left of the device).
function plug_right() = device_d.x / 2 - plug_inset();

// Overall body.
module body() {
    union() {
        // Main body.
        cuboid(
            device_d + [ 2 * shell, 2 * shell, base_h() ],
            rounding = shell,
            edges = "Z",
            anchor = BOTTOM
        );

        // Plug surround shell.
        left(plug_right() - shell) {
            cuboid(
                plug_inset_d() + [ shell, 2 * shell, base_d.z + shell],
                rounding = plug_round + shell,
                edges = "X",
                except = BOTTOM,
                anchor = BOTTOM + RIGHT
            );

            // Dovetail.
            if (base_d.z > dovetail_shell) {
                dovetail(
                    point2d(plug_inset_d()) + [ shell, 2 * shell ],
                    base_d.z
                );
            }
        }

    }
}

// Dovetail trapezoidal prism.
module dovetail(basic_size, dovetail_h = base_d.z - dovetail_shell) {
    prismoid(
        size2 = basic_size,
        size1 = basic_size + [ 0, 2 * dovetail_h ],
        h = dovetail_h,
        anchor = BOTTOM + RIGHT
    );
}

xflip_copy(device_d.x / 2 + shell - base_d.y / 2) {
    yflip_copy(device_d.y / 2 + shell - eps) {
        cuboid(
            [ base_leg_width, base_d.y / 2 + eps, shell ],
            rounding = shell / 2,
            except = [ FRONT, BOTTOM ],
            anchor = FRONT + RIGHT + BOTTOM
        );

        difference() {
            radius = base_d.y / 4;
            cuboid(
                [ base_leg_width, radius + eps, radius + shell ],
                anchor = FRONT + RIGHT + BOTTOM
            );
            up(shell + radius) back(radius) right(eps) xcyl(
                r = radius, l = base_leg_width + 2 * eps,
                rounding = -shell / 2,
                anchor = RIGHT
            );
        }
    }
}

difference() {
    body();

    // Internal waste portion of base.
    right(device_d.x / 2) down(eps) cuboid(
        [ device_d.x - plug_inset() - shell, device_d.y, base_h() - shell ],
        rounding = 0.5,
        edges = "Z",
        anchor = BOTTOM + RIGHT
    );

    up(base_h() + device_d.z + eps) {
        // Device slot.
        cuboid(
            device_d + [ 0, 0, eps ],
            rounding = 0.5,
            edges = "Z",
            anchor = TOP
        );
        // Slots for feet.
        back(device_d.y / 2 - eps) xcopies(foot_pos) cuboid(
            [ foot_d.x, foot_d.y + eps, device_d.z + eps ],
            anchor = TOP + FRONT
        );
    }


    // Plug body.
    left(plug_right()) down(eps) {
        cuboid(
            plug_inset_d() + [ eps, 0, base_d.z + eps ],
            rounding = plug_round,
            edges = "X",
            except = BOTTOM,
            anchor = BOTTOM + RIGHT
        );

        // Dovetail for base holder.
        if (base_d.z > dovetail_shell) {
            up(eps + dovetail_shell) {
                dovetail(point2d(plug_inset_d()) + [ eps, 0 ]);
            }
        }
    }

    // Port.
    left(device_d.x / 2 - port_gap) up(base_h() - plug_gap - eps) {
        cuboid(
            [ flange_d.x, flange_d.y, 2 * eps + plug_gap ],
            anchor = BOTTOM + LEFT
        );
    }

}


if (base_d.z > dovetail_shell) {
    left(plug_inset_d().x + 5) {
        intersection() {
            body();
            base_size = point2d(plug_inset_d()) + [ 0, -2 * dovetail_slop ];
            left(plug_right()) union() {
                up(dovetail_shell) {
                    dovetail(base_size);
                }
                down(eps) {
                    cuboid(
                        point3d(base_size, base_d.z + eps),
                        anchor = BOTTOM + RIGHT
                    );
                }
            }
        }
    }
}
