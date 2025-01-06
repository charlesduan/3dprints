base_z = 2;
base_x = 90;
base_y = 50;

pillar_x = 20;
pillar_y = 30;
pillar_z = 80;

pillar_dish = 2;
pillar_wall = 5;
pillar_support = 5;

arm_z = 10;
arm_wall = 5;

eps = 0.001;

module centered_cube(x, y, z, z_height) {
    translate([0, 0, z_height + z / 2]) cube([x, y, z], center = true);
}


// Base
centered_cube(base_x, base_y, base_z, -base_z);
translate([0, 0, -base_z/2]) cube([base_x, base_y, base_z], center = true);

// Pillar
difference() {

    // Outer perimeter
    centered_cube(pillar_x, pillar_y, pillar_z + pillar_dish + eps, -eps);

    // Inner cutout
    cylinder_center_z = pillar_z - pillar_x / 2;
    centered_cube(pillar_x - 2 * pillar_wall, pillar_y + 2 * eps,
            cylinder_center_z, -eps);
    translate([0, 0, cylinder_center_z]) {
        rotate([90, 0, 0]) {
            cylinder(h = pillar_y + 2 * eps,
                    r = pillar_x / 2 - pillar_wall, center = true);
        }
    }

    // Dish
    inner_width = (pillar_x - 2 * arm_wall) / 2;
    dish_radius = (pillar_dish * pillar_dish + inner_width * inner_width) / (2 * pillar_dish);
    translate([0, 0, pillar_z + dish_radius]) rotate([90, 0, 0]) {
        cylinder(h = pillar_y + 2 * eps,
                r = dish_radius,
                center = true);
    }
}

// Pillar supports
module pillar_support(left = false) {
    translate([0, left ? (-pillar_y / 2) : (pillar_y / 2), 0]) {
        rotate([90, 0, left ? 180 : 0]) {
            linear_extrude(pillar_y) {
                polygon([ [-eps, -eps],
                        [pillar_support + eps, -eps],
                        [-eps, pillar_support + eps]]);
            }
        }
    }
}
translate([pillar_x / 2, 0, 0]) pillar_support();
translate([pillar_x / 2 - pillar_wall, 0, 0]) pillar_support(left = true);
translate([-pillar_x / 2, 0, 0]) pillar_support(left = true);
translate([-pillar_x / 2 + pillar_wall, 0, 0]) pillar_support();

// Arms
translate([(pillar_x - arm_wall) / 2, 0, pillar_z + pillar_dish]) {
    multmatrix([[1,0,1,0],[0,1,0,0],[0,0,1,0]]) {
        centered_cube(arm_wall, pillar_y, arm_z + eps, -eps);
    }
}
translate([-(pillar_x - arm_wall) / 2, 0, pillar_z + pillar_dish]) {
    multmatrix([[1,0,-1,0],[0,1,0,0],[0,0,1,0]]) {
        centered_cube(arm_wall, pillar_y, arm_z + eps, -eps);
    }
}
