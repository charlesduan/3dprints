include <BOSL2/std.scad>
include <lib/production.scad>

hook_diam = 4;
hook_width = 8;
hook_length = 12;

hook_thickness = 3;
eps = 0.01;

module hook_d(length, diam) {
    // Inside of hook
    left(eps) {
        square([length + eps, diam],
                anchor = LEFT);
    }

    right(length) circle(d = diam);
}

module hook_u() {
    hook_center = (hook_length + hook_diam) / 2;

    back((hook_diam + hook_thickness) / 2) difference() {
        hook_d(hook_center, hook_diam + 2 * hook_thickness);
        hook_d(hook_center, hook_diam);
    }
}

linear_extrude(hook_width) {
    hook_u();
    rotate(180) hook_u();
}
