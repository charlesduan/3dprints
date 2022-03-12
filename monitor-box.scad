$fa = 1;
$fs = 0.4;

shell = 2;
port_tol = 0.2;
size_tol = 0.15;
extra_height = 14;
ridge_radius = 0.6;
ridge_offset = 0.5;
ridge_port_gap = 10;

outer_width = 121.1;
outer_length = 78;
outer_height = 7.8;

margin_left = 3.6;
margin_right = 3.5;
margin_top = 3.1;
margin_bot = 8;

hdmi_left = 45.4;
hdmi_width = 15.2;
hdmi_height = 6.4;
usb_right = 43.2;
usb_width = 8;
usb_height = 2.9;

eps = 0.01;

module rectangle(x, y, width, length) {
    translate([x, y]) square([width, length]);
}

module ridge(length) {
    linear_extrude(length) intersection() {
        circle(ridge_radius);
        translate([-eps, -2 * ridge_radius]) {
            square(4 * ridge_radius);
        }
    }
}

// Origin is the bottom left corner, where the monitor sits.

difference() {
    // Outer shell
    translate([0, 0, -shell]) {
        linear_extrude(outer_height + shell + extra_height) {
            difference() {
                rectangle(
                    -shell - size_tol,
                    -shell - size_tol,
                    outer_width + 2 * (shell + size_tol),
                    outer_length + 2 * (shell + size_tol)
                );
                // Window for screen
                rectangle(
                    margin_left, margin_bot,
                    outer_width - margin_left - margin_right,
                    outer_length - margin_top - margin_bot
                );
            }
        }
    }
    // Inner cavity for monitor
    translate([-size_tol, -size_tol, 0]) cube([
        outer_width + 2 * size_tol,
        outer_length + 2 * size_tol,
        outer_height + extra_height + eps
    ]);
    
    // HDMI port
    translate([
        outer_width - hdmi_left - hdmi_width - port_tol,
        outer_length + size_tol - eps,
        outer_height - port_tol
    ]) cube([
        hdmi_width + 2 * port_tol,
        shell + 2 * eps,
        hdmi_height + 2 * port_tol
    ]);
    
    // USB port
    translate([
        usb_right - port_tol,
        outer_length + size_tol - eps,
        outer_height - port_tol
    ]) cube([
        usb_width + 2 * port_tol,
        shell + 2 * eps,
        usb_height + 2 * port_tol
    ]);
}

// Back ridge
translate([
    -size_tol, -size_tol, outer_height + ridge_offset
]) {
    rotate([90, 0, 90]) ridge(outer_width + 2 * size_tol);
}

// USB-side ridge
translate([
    -size_tol - eps, outer_length + size_tol,
    outer_height + ridge_offset
]) {
    rotate([-90, 0, -90]) ridge(
        usb_right - port_tol - ridge_port_gap + size_tol
    );
}
translate([
    outer_width + size_tol + eps, outer_length + size_tol,
    outer_height + ridge_offset
]) {
    rotate([90, 0, -90]) ridge(
        hdmi_left - port_tol - ridge_port_gap + size_tol
    );
}