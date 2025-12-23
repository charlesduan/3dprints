include <../BOSL2/std.scad>
include <../lib/production.scad>

// Diameter of the ball
ball_d = 18;

// Gap between tracks
gap = 1.5;

// Number of revolutions of rings
rings = 2;

// Top and bottom shell thickness
vert_shell = 1;

eps = 0.01;

// Constructs the points for the rings.
function ring_points() = [
    [ 0, 0, -vert_shell - eps ],
    [ 0, 0 ],
    for (i = [ 1 : 1 : rings ]) each (gap + ball_d) * [
        [ i - 1, -i ], [ -i, -i ], [ -i, i ], [ i, i ]
    ],
    (gap + ball_d) * [ rings, -rings ],
    point3d((gap + ball_d) * [ rings, -rings ], -vert_shell - eps)
];


difference() {
    down(vert_shell) cuboid(
        point3d(
            // For n rings, there will be 2n + 1 ball tracks and 2n + 2 walls
            ((2 * rings + 2) * (gap + ball_d) - ball_d) * [ 1, 1 ],
            // Vertical height is two shells plus the ball diameter
            ball_d + 2 * vert_shell
        ),
        anchor = BOT
    );
    seq_hull(ring_points()) {
        // Top opening
        up(ball_d / 2) cyl(
            d = ball_d / sqrt(2), h = ball_d / 2 + vert_shell + eps,
            anchor = BOT
        );

        // Ball itself
        spheroid(d = ball_d, anchor = BOT);

        // Keep the bottom flat
        cyl(d = ball_d, h = ball_d / 2, anchor = BOT);
    }
}
