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
door_swing_angle = 0; // 0 = closed, 90 = fully open inward
door_hinge_east  = true; // true = hinge on the east side, false = west side

// --- Window Parameters (Inches) ---
window_width         = 42;
window_bottom_height = 30;
window_top_height    = 96;
window_height        = window_top_height - window_bottom_height;
window_from_east     = (door_from_east - window_width) / 2; // Centered in the 53" gap

// --- Transom Window Parameters (Inches) ---
transom_bottom_height = 82; // 2 inches header gap above the 80" door
transom_top_height    = 96;
transom_height        = transom_top_height - transom_bottom_height;

// --- East Window Parameters (Inches) ---
east_window_width         = 41;
east_window_bottom_height = 30;
east_window_top_height    = 96;
east_window_height        = east_window_top_height - east_window_bottom_height;
east_window_from_north    = 0; // Ends/starts near North wall

// --- Visualization Toggles ---
show_walls       = true;
show_floor       = true;
show_door        = true;
show_window      = true;
show_transom     = true;
show_door_swing  = true; // Shows the door's opening path/clearance zone on the floor
show_east_window = true;

// --- Colors ---
color_wall         = [0.93, 0.93, 0.90, 1.0]; // Warm off-white
color_floor        = [0.45, 0.35, 0.25, 1.0]; // Warm wood tone
color_door         = [0.75, 0.55, 0.40, 0.8]; // Semi-transparent wood tone
color_door_swing   = [0.95, 0.45, 0.45, 0.2]; // Semi-transparent red clearance zone
color_window_glass = [0.65, 0.85, 0.95, 0.4]; // Semi-transparent glass blue
color_window_frame = [0.95, 0.95, 0.95, 1.0]; // White window trim

module room_walls() {
    // North Wall: X from 0 to 108 + thickness, Y from 71 to 71 + thickness
    // Cuts the back entrance door, main window, and transom window openings
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

        // Transom window opening cut
        translate([north_wall_length - door_from_east - door_width, east_wall_length - 0.5, transom_bottom_height])
            cube([door_width, wall_thickness + 1, transom_height]);
    }

    // South Wall: X from 0 to 108 + thickness, Y from -thickness to 0
    color(color_wall)
    translate([0, -wall_thickness, 0])
        cube([south_wall_length + wall_thickness, wall_thickness, wall_height]);

    // East Wall: X from 108 to 108 + thickness, Y from 0 to 71
    // Cuts the East window opening
    color(color_wall)
    difference() {
        translate([north_wall_length, 0, 0])
            cube([wall_thickness, east_wall_length, wall_height]);
        
        // East window opening cut
        translate([north_wall_length - 0.5, east_wall_length - east_window_from_north - east_window_width, east_window_bottom_height])
            cube([wall_thickness + 1, east_window_width, east_window_height]);
    }
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

module room_door_swing() {
    hinge_x = door_hinge_east ? (north_wall_length - door_from_east) : (north_wall_length - door_from_east - door_width);
    
    // Position at the floor level (slightly elevated to prevent Z-fighting)
    translate([hinge_x, east_wall_length, 0.01]) {
        // 1. Semi-transparent clearance wedge
        color(color_door_swing)
        intersection() {
            cylinder(h = 0.01, r = door_width, $fn = 60);
            if (door_hinge_east) {
                translate([-door_width, -door_width, 0])
                    cube([door_width, door_width, 0.02]);
            } else {
                translate([0, -door_width, 0])
                    cube([door_width, door_width, 0.02]);
            }
        }
        
        // 2. Arc outline
        color([0.5, 0.5, 0.5, 0.6])
        intersection() {
            difference() {
                cylinder(h = 0.02, r = door_width, $fn = 60);
                translate([0, 0, -0.01])
                    cylinder(h = 0.04, r = door_width - 0.5, $fn = 60); // 0.5" thickness
            }
            if (door_hinge_east) {
                translate([-door_width, -door_width, 0])
                    cube([door_width, door_width, 0.03]);
            } else {
                translate([0, -door_width, 0])
                    cube([door_width, door_width, 0.03]);
            }
        }
    }
}

// Reusable Window Component
module window_unit(w_x, w_y, w_z, w_width, w_height) {
    // Draw Glass
    color(color_window_glass)
    translate([w_x, w_y + (wall_thickness - 0.25)/2, w_z])
        cube([w_width, 0.25, w_height]);
        
    // Draw simple frame/trim
    color(color_window_frame)
    difference() {
        // Outer frame
        translate([w_x - 1, w_y - 0.1, w_z - 1])
            cube([w_width + 2, wall_thickness + 0.2, w_height + 2]);
        // Inner cutout (glass size)
        translate([w_x, w_y - 0.2, w_z])
            cube([w_width, wall_thickness + 0.4, w_height]);
    }
}

module room_window() {
    window_x = north_wall_length - window_from_east - window_width;
    window_unit(window_x, east_wall_length, window_bottom_height, window_width, window_height);
}

module room_transom() {
    transom_x = north_wall_length - door_from_east - door_width;
    window_unit(transom_x, east_wall_length, transom_bottom_height, door_width, transom_height);
}

module room_east_window() {
    // East wall is at X = 108. Translate and rotate to align local axes
    translate([north_wall_length, 0, 0])
    rotate([0, 0, 90])
        window_unit(east_wall_length - east_window_from_north - east_window_width, -wall_thickness, east_window_bottom_height, east_window_width, east_window_height);
}

// --- Render Room ---
scale(inch) {
    if (show_walls)       room_walls();
    if (show_floor)       room_floor();
    if (show_door)        room_door();
    if (show_door_swing)  room_door_swing();
    if (show_window)      room_window();
    if (show_transom)     room_transom();
    if (show_east_window) room_east_window();
}

