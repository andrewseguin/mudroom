// Parameters for Mudroom Organizer
// All primary dimensions are in inches.

// --- Unit Conversion ---
inch = 25.4; // 1 inch = 25.4 mm (OpenSCAD default unit is mm)

// --- Room Dimensions (Inches) ---
north_wall_length = 108;
south_wall_length = 108;
east_wall_length  = 71;
wall_height       = 108; // 9 feet
wall_thickness    = 4.5;
floor_thickness   = 0.75;

// --- Door Parameters (Inches) ---
door_from_east   = 53;
door_width       = 36;
door_height      = 80;
door_thickness   = 1.75;
door_swing_angle = 90; // 0 = closed, 90 = fully open inward
door_hinge_east  = true; // true = hinge on the east side, false = west side

// --- Window Parameters (Inches) ---
window_width         = 42;
window_bottom_height = 30;
window_top_height    = 96;
window_height        = window_top_height - window_bottom_height;
window_from_east     = (door_from_east - window_width) / 2; // Centered in the 53" gap

// --- Visualization Toggles ---
show_walls  = true;
show_floor  = true;
show_door   = true;
show_window = true;

// --- Colors ---
color_wall         = [0.93, 0.93, 0.90, 1.0]; // Warm off-white
color_floor        = [0.45, 0.35, 0.25, 1.0]; // Warm wood tone
color_door         = [0.75, 0.55, 0.40, 0.8]; // Semi-transparent wood tone
color_window_glass = [0.65, 0.85, 0.95, 0.4]; // Semi-transparent glass blue
color_window_frame = [0.95, 0.95, 0.95, 1.0]; // White window trim

module room_walls() {
    // North Wall: X from 0 to 108 + thickness, Y from 71 to 71 + thickness
    // Cuts the back entrance door and window openings
    color(color_wall)
    difference() {
        translate([0, east_wall_length, 0])
            cube([north_wall_length + wall_thickness, wall_thickness, wall_height]);
        
        // Door opening cut
        translate([north_wall_length - door_from_east - door_width, east_wall_length - 0.5, 0])
            cube([door_width, wall_thickness + 1, door_height]);
            
        // Window opening cut
        translate([north_wall_length - window_from_east - window_width, east_wall_length - 0.5, window_bottom_height])
            cube([window_width, wall_thickness + 1, window_height]);
    }

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

module room_door() {
    hinge_x = door_hinge_east ? (north_wall_length - door_from_east) : (north_wall_length - door_from_east - door_width);
    
    // Position at hinge and rotate door slab
    translate([hinge_x, east_wall_length, 0])
    rotate([0, 0, door_hinge_east ? door_swing_angle : -door_swing_angle]) {
        // If hinge is East, door extends to the West when closed (direction -X).
        // If hinge is West, door extends to the East when closed (direction +X).
        x_offset = door_hinge_east ? -door_width : 0;
        
        color(color_door)
        translate([x_offset, -door_thickness, 0])
            cube([door_width, door_thickness, door_height]);
    }
}

module room_window() {
    window_x = north_wall_length - window_from_east - window_width;
    
    // Draw Glass
    color(color_window_glass)
    translate([window_x, east_wall_length + (wall_thickness - 0.25)/2, window_bottom_height])
        cube([window_width, 0.25, window_height]);
        
    // Draw simple frame/trim
    color(color_window_frame)
    difference() {
        // Outer frame
        translate([window_x - 1, east_wall_length - 0.1, window_bottom_height - 1])
            cube([window_width + 2, wall_thickness + 0.2, window_height + 2]);
        // Inner cutout (glass size)
        translate([window_x, east_wall_length - 0.2, window_bottom_height])
            cube([window_width, wall_thickness + 0.4, window_height]);
    }
}

// --- Render Room ---
scale(inch) {
    if (show_walls)  room_walls();
    if (show_floor)  room_floor();
    if (show_door)   room_door();
    if (show_window) room_window();
}

