/*
 * Stand for Remarkable 2 with USB charging.
 */
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Remarkable dimensions. x and y should include additional margin. z is the
// insertion height.
device_d = [ 189, 5, 25 ];

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
flange_d = [ 11.1, 4.7, 1.6 ];

// Horizontal offset of the port from the edge of the plug. Note that this is
// the *right* edge of the port, while port_gap above is the *left* edge of the
// port (when looking at the device face-on).
port_plug_gap = 1.2;

// Additional size around the base. x and y are added to the device's x and y
// dimensions. z is any extra on the bottom, beyond the minimum to allow the
// plug.
base_d = [ 5, 60, 3 ];

// Rounding of base edges.
base_round = 5;

// Additional size around the top.
top_d = [ 5, 5 ];

// Minimum shell between the dovetail and the bottom.
dovetail_shell = 0.75;

// Reduction in size for the dovetail insert.
dovetail_slop = 0.5;

eps = 0.01;
layer = 0.25;

function base_h() = plug_gap + plug_d.z + base_d.z;

// Overall body.
module body() {
    prismoid(
        size1 = point2d(base_d) + point2d(device_d),
        size2 = top_d + point2d(device_d),
        h = device_d.z + base_h(),
        rounding = base_round,
        anchor = BOTTOM
    );
}

// Dovetail trapezoidal prism.
module dovetail(basic_size) {
    dovetail_h = base_d.z - dovetail_shell;
    prismoid(
        size2 = basic_size,
        size1 = basic_size + [ 0, 2 * dovetail_h ],
        h = dovetail_h,
        anchor = BOTTOM + RIGHT
    );
}

difference() {
    body();

    // Device slot.
    up(base_h() + device_d.z + eps) cuboid(
        device_d + [ 0, 0, eps ],
        rounding = 0.5,
        edges = "Z",
        anchor = TOP
    );

    // Plug body.
    left(device_d.x / 2 - port_gap - flange_d.x - port_plug_gap) down(eps) {
        cuboid(
            plug_d + [ 0, 0, base_d.z + eps ],
            rounding = plug_round,
            edges = "X",
            except = BOTTOM,
            anchor = BOTTOM + RIGHT
        );

        // Dovetail for base holder.
        if (base_d.z > dovetail_shell) {
            up(eps + dovetail_shell) {
                dovetail(point2d(plug_d));
            }
        }
    }

    // Port.
    left(device_d.x / 2 - port_gap) up(base_h() - plug_gap - eps) {
        cuboid(
            [ flange_d.x, flange_d.y, 2 * eps + plug_gap ],
            anchor = BOTTOM + LEFT
        );
        // 3d printing of holes.
        cuboid(
            [ flange_d.x, plug_d.y, eps + layer ],
            anchor = BOTTOM + LEFT
        );
    }

}


if (base_d.z > dovetail_shell) {
    left(plug_d.x + 5) {
        intersection() {
            body();
            base_size = [ plug_d.x, plug_d.y - 2 * dovetail_slop ];
            left(device_d.x / 2 - port_gap - flange_d.x - port_plug_gap) union() {
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
