include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <lib/production.scad>

train_width = 8;
train_length = 25.5;
train_height = 9.5;

min_stem_depth = 2.5;
stem_depth = 2.7;
stem_width = 2.6;
max_stem_width = 2.8;
stem_length = 4.2;
stem_sep = 4;

flange_width = 6.1;
flange_stem_max_depth = 5;
flange_stem_depth = 4.2;


cuboid(
    [train_length, train_width, train_height],
    rounding = 1,
    anchor = BOTTOM
);

path = round_corners([
    [0, 0],
    [stem_length, stem_width / 2],
    [stem_length, -stem_width / 2],
], radius = 0.5);

circ_path = circle(d = flange_width, anchor = LEFT);
angle_depth = min(
    flange_stem_max_depth - min_stem_depth,
    (flange_width - stem_length) / 2
);

module flange() {
    skin([
        path3d(path, 0),
        path3d(path, -min_stem_depth),
        path3d(circ_path, -min_stem_depth - angle_depth),
    ], slices = 10, method = "reindex");
    if (min_stem_depth + angle_depth <= flange_stem_depth) {
        down(angle_depth + min_stem_depth - 0.01) cyl(
            d = flange_width,
            h = flange_stem_depth - angle_depth - min_stem_depth,
            anchor = TOP + LEFT
        );
    }
}
right(stem_sep / 2) flange();

left(stem_sep / 2) rotate(180) flange();

