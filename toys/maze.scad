include <tunnel.scad>
include <../BOSL2/std.scad>
include <../lib/production.scad>

// Diameter of the ball
ball_d = 8.5;

// Gap between tracks
gap = 1.5;

// Maximum coordinates of maze
maze_dim = [10, 10];

// Openings for the maze
openings = [ [0, 0], [9, 9] ];

// Top and bottom shell thickness
vert_shell = 1;

eps = 0.01;

maze = [
    [
        [0, 0],
        [4, 0],
        [4, 6],
        [7, 6]
    ],
    [
        [1, 0],
        [1, 3],
        [2, 3],
        [2, 1],
        [3, 1],
        [3, 6],
        [1, 6],
        [1, 9]
    ],
    [
        [0, 1],
        [0, 9],
        [4, 9]
    ],
    [ [0, 4], [2, 4] ],
    [ [0, 5], [2, 5] ],
    [
        [1, 8],
        [5, 8],
        [5, 9],
        [8, 9],
        [8, 4],
        [5, 4],
        [5, 0],
        [9, 0],
        [9, 9]
    ],
    [ [8, 7], [2, 7] ],
    [ [6, 7], [6, 8] ],
    [ [7, 7], [7, 8] ],
    [ [8, 5], [5, 5] ],
    [ [6, 4], [6, 3], [8, 3], [8, 2] ],
    [ [5, 1], [8, 1] ],
    [ [6, 1], [6, 2], [7, 2] ]
];

function maze_factor() = ball_d + gap;

difference() {
    translate([
        -ball_d / 2 - gap,
        -ball_d / 2 - gap,
        -vert_shell
    ]) cuboid(
        point3d(
            maze_dim * maze_factor() + [ gap, gap ],
            // Vertical height is two shells plus the ball diameter
            ball_d + 2 * vert_shell
        ),
        anchor = BOT + LEFT + FRONT
    );

    // Maze tracks
    for (maze_run = maze) {
        seq_hull(maze_run * maze_factor()) {
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

    // Openings
    for (opening = openings) {
        seq_hull([
            point3d(opening * maze_factor(), 0),
            point3d(opening * maze_factor(), ball_d + gap)
        ]) {
            // Ball itself
            spheroid(d = ball_d, anchor = BOT);
        }
    }

}
