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

// --- North Door Parameters (Inches) ---
north_door_from_east    = 53;
north_door_width        = 36;
north_door_height       = 80;
north_door_thickness    = 1.75;
north_door_trim_width   = 4;
north_door_trim_thick   = 0.75;
north_door_swing_angle  = 0; // 0 = closed, 90 = open inward
north_door_hinge_east   = true;
north_door_opens_inward = true; // Opens into the mudroom

// --- South Door Parameters (Inches) ---
south_door_from_east    = 50;
south_door_width        = 36;
south_door_height       = 80;
south_door_thickness    = 1.75;
south_door_trim_width   = 4;
south_door_trim_thick   = 0.75;
south_door_swing_angle  = 90; // Open outward
south_door_hinge_east   = false; // Hinged on the West side
south_door_opens_inward = false; // Swings outward (out of the mudroom)

// --- North Window Parameters (Inches) ---
window_width         = 42;
window_bottom_height = 30;
window_top_height    = 96;
window_height        = window_top_height - window_bottom_height;
window_from_east     = (north_door_from_east - window_width) / 2; // Centered in the 53" gap

// --- Transom Window Parameters (Inches) ---
transom_bottom_height = 82; // 2 inches header gap above the 80" door
transom_top_height    = 96;
transom_height        = transom_top_height - transom_bottom_height;

// --- East Window Parameters (Inches) ---
east_window_width         = 42; // Same size as opposing window
east_window_bottom_height = 30;
east_window_top_height    = 96;
east_window_height        = east_window_top_height - east_window_bottom_height;
east_window_from_north    = 2; // 2 inches away from North wall

// --- Visualization Toggles ---
show_walls       = true;
show_floor       = true;
show_doors       = true;
show_door_swing  = true; // Shows the door's opening path/clearance zone on the floor
show_windows     = true;
show_transom     = true;
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
        
        // North door opening cut
        translate([north_wall_length - north_door_from_east - north_door_width, east_wall_length - 0.5, 0])
            cube([north_door_width, wall_thickness + 1, north_door_height]);
            
        // North window opening cut
        translate([north_wall_length - window_from_east - window_width, east_wall_length - 0.5, window_bottom_height])
            cube([window_width, wall_thickness + 1, window_height]);

        // Transom window opening cut
        translate([north_wall_length - north_door_from_east - north_door_width, east_wall_length - 0.5, transom_bottom_height])
            cube([north_door_width, wall_thickness + 1, transom_height]);
    }

    // South Wall: X from 0 to 108 + thickness, Y from -thickness to 0
    // Cuts the South door opening
    color(color_wall)
    difference() {
        translate([0, -wall_thickness, 0])
            cube([south_wall_length + wall_thickness, wall_thickness, wall_height]);
        
        // South door opening cut
        translate([south_wall_length - south_door_from_east - south_door_width, -wall_thickness - 0.5, 0])
            cube([south_door_width, wall_thickness + 1, south_door_height]);
    }

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

// Reusable Door Component (includes trim, slab, swing path)
module door_unit(wall_y, is_north, door_from_east, width, height, thickness, swing_angle, hinge_east, opens_inward, trim_width, trim_thick, show_slab, show_swing) {
    wall_length = is_north ? north_wall_length : south_wall_length;
    hinge_x = hinge_east ? (wall_length - door_from_east) : (wall_length - door_from_east - width);
    y_dir = is_north ? -1 : 1;
    
    // Determine Y swing direction (swings towards positive Y or negative Y)
    swings_pos_y = (is_north && !opens_inward) || (!is_north && opens_inward);
    
    // 1. Draw Door Trim (inward face)
    color(color_window_frame) {
        trim_y = wall_y + (is_north ? -0.01 : 0.01);
        
        // Left Trim
        translate([wall_length - door_from_east - width - trim_width, trim_y + (is_north ? 0 : -trim_thick), 0])
            cube([trim_width, trim_thick, height + trim_width]);
            
        // Right Trim
        translate([wall_length - door_from_east, trim_y + (is_north ? 0 : -trim_thick), 0])
            cube([trim_width, trim_thick, height + trim_width]);
            
        // Top Trim
        translate([wall_length - door_from_east - width, trim_y + (is_north ? 0 : -trim_thick), height])
            cube([width, trim_thick, trim_width]);
    }
    
    // 2. Draw Door Slab
    if (show_slab) {
        translate([hinge_x, wall_y, 0])
        rotate([0, 0, swing_angle * (hinge_east ? 1 : -1) * (is_north ? 1 : -1) * (opens_inward ? 1 : -1)]) {
            x_offset = hinge_east ? -width : 0;
            y_offset = swings_pos_y ? 0 : -thickness;
            color(color_door)
            translate([x_offset, y_offset, 0])
                cube([width, thickness, height]);
        }
    }
    
    // 3. Draw Swing Path
    if (show_swing) {
        translate([hinge_x, wall_y, 0.01]) {
            box_x = hinge_east ? -width : 0;
            box_y = swings_pos_y ? 0 : -width;
            
            // Clearance Wedge
            color(color_door_swing)
            intersection() {
                cylinder(h = 0.01, r = width, $fn = 60);
                translate([box_x, box_y, 0])
                    cube([width, width, 0.02]);
            }
            
            // Arc Outline
            color([0.5, 0.5, 0.5, 0.6])
            intersection() {
                difference() {
                    cylinder(h = 0.02, r = width, $fn = 60);
                    translate([0, 0, -0.01])
                        cylinder(h = 0.04, r = width - 0.5, $fn = 60);
                }
                translate([box_x, box_y, 0])
                    cube([width, width, 0.03]);
            }
        }
    }
}

module room_windows() {
    // North Window
    if (show_windows) {
        window_x = north_wall_length - window_from_east - window_width;
        window_unit(window_x, east_wall_length, window_bottom_height, window_width, window_height);
    }
    
    // Transom Window
    if (show_transom) {
        transom_x = north_wall_length - north_door_from_east - north_door_width;
        window_unit(transom_x, east_wall_length, transom_bottom_height, north_door_width, transom_height);
    }
    
    // East Window
    if (show_east_window) {
        translate([north_wall_length, 0, 0])
        rotate([0, 0, 90])
            window_unit(east_wall_length - east_window_from_north - east_window_width, -wall_thickness, east_window_bottom_height, east_window_width, east_window_height);
    }
}

// --- Render Room ---
scale(inch) {
    if (show_walls) room_walls();
    if (show_floor) room_floor();
    
    // North Door
    door_unit(
        wall_y          = east_wall_length,
        is_north        = true,
        door_from_east  = north_door_from_east,
        width           = north_door_width,
        height          = north_door_height,
        thickness       = north_door_thickness,
        swing_angle     = north_door_swing_angle,
        hinge_east      = north_door_hinge_east,
        opens_inward    = north_door_opens_inward,
        trim_width      = north_door_trim_width,
        trim_thick      = north_door_trim_thick,
        show_slab       = show_doors,
        show_swing      = show_door_swing
    );
    
    // South Door
    door_unit(
        wall_y          = 0,
        is_north        = false,
        door_from_east  = south_door_from_east,
        width           = south_door_width,
        height          = south_door_height,
        thickness       = south_door_thickness,
        swing_angle     = south_door_swing_angle,
        hinge_east      = south_door_hinge_east,
        opens_inward    = south_door_opens_inward,
        trim_width      = south_door_trim_width,
        trim_thick      = south_door_trim_thick,
        show_slab       = show_doors,
        show_swing      = show_door_swing
    );
    
    room_windows();
}
