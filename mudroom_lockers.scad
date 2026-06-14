// Parameters for Mudroom Organizer
// All primary dimensions are in inches.

// --- Unit Conversion ---
inch = 25.4; // 1 inch = 25.4 mm (OpenSCAD default unit is mm)

// --- Room Dimensions (Inches) ---
north_wall_length = 108;
south_wall_length = 108;
east_wall_length  = 71;
wall_height       = 96;
wall_thickness    = 4.5;
floor_thickness   = 0.75;

// --- Visualization Toggles ---
show_walls = true;
show_floor = true;

// --- Colors ---
color_wall  = [0.93, 0.93, 0.90, 1.0]; // Warm off-white
color_floor = [0.45, 0.35, 0.25, 1.0]; // Warm wood tone

module room_walls() {
    // North Wall: X from 0 to 108 + thickness, Y from 71 to 71 + thickness
    color(color_wall)
    translate([0, east_wall_length, 0])
        cube([north_wall_length + wall_thickness, wall_thickness, wall_height]);

    // South Wall: X from 0 to 108 + thickness, Y from -thickness to 0
    color(color_wall)
    translate([0, -wall_thickness, 0])
        cube([south_wall_length + wall_thickness, wall_thickness, wall_height]);

    // East Wall: X from 108 to 108 + thickness, Y from 0 to 71
    color(color_wall)
    translate([north_wall_length, 0, 0])
        cube([wall_thickness, east_wall_length, wall_height]);
}

module room_floor() {
    // Floor area covers the interior and underneath the walls
    color(color_floor)
    translate([0, -wall_thickness, -floor_thickness])
        cube([north_wall_length + wall_thickness, east_wall_length + 2 * wall_thickness, floor_thickness]);
}

// --- Render Room ---
scale(inch) {
    if (show_walls) room_walls();
    if (show_floor) room_floor();
}
