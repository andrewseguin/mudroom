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

// --- Materials (Inches) ---
plywood_thickness   = 0.75; // Standard cabinet carcass material
bench_top_thickness = 1.5;  // Premium thick wood top for benches

// --- Base Platform / Toe Kick Parameters (Inches) ---
base_platform_height = 3.5; // Nominally 2x4 height
toe_kick_recess      = 2.5; // Recession from the cabinet front face

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

// --- Locker Parameters (Inches) ---
locker_num_bays     = 3;
locker_bay_width    = 15;   // Interior width of each bay
locker_depth        = 18;
locker_height       = 90;   // 6 inches below window trim (96")
locker_bench_height = 18;
locker_upper_height = 12;   // Height of top cubby bins (12" from the top)

// --- Bench Parameters (Inches) ---
bench_depth  = 18;
bench_height = 18;

// --- Visualization Toggles ---
show_walls       = true;
show_floor       = true;
show_doors       = true;
show_door_swing  = true; // Shows the door's opening path/clearance zone on the floor
show_windows     = true;
show_transom     = true;
show_east_window = true;
show_lockers     = true; // Renders the South wall locker cabinet unit
show_benches     = true; // Renders the North & East wall L-shaped benches
show_platforms   = true; // Renders the 2x4 base platforms
show_glass       = false; // Set to false to hide glass panes if preview transparency blocks your view

// --- Colors ---
color_wall         = [0.93, 0.93, 0.90, 1.0]; // Warm off-white
color_floor        = [0.45, 0.35, 0.25, 1.0]; // Warm wood tone (also used for bench tops)
color_door         = [0.75, 0.55, 0.40, 0.8]; // Semi-transparent wood tone
color_door_swing   = [0.95, 0.45, 0.45, 0.2]; // Semi-transparent red clearance zone
color_window_glass = [0.65, 0.85, 0.95, 0.4]; // Semi-transparent glass blue
color_window_frame = [0.95, 0.95, 0.95, 1.0]; // White window trim
color_cabinet      = [0.90, 0.90, 0.90, 1.0]; // Light grey painted cabinet finish
color_hook         = [0.20, 0.20, 0.20, 1.0]; // Oil rubbed bronze hooks
color_platform     = [0.22, 0.22, 0.22, 1.0]; // Charcoal/dark slate toe kick wrapper

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
    if (show_glass) {
        color(color_window_glass)
        translate([w_x, w_y + (wall_thickness - 0.25)/2, w_z])
            cube([w_width, 0.25, w_height]);
    }
        
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

// Visual helper for double coat hooks
module draw_hook() {
    color(color_hook) {
        // Base plate
        translate([-0.4, 0, 0.5]) cube([0.8, 0.25, 2]);
        // Upper hook arm
        translate([0, 0.25, 2]) {
            rotate([30, 0, 0]) cube([0.2, 1.2, 0.2], center=true);
            translate([0, 0.6, 0.3]) sphere(r=0.25, $fn=10);
        }
        // Lower hook arm
        translate([0, 0.25, 1]) {
            rotate([-15, 0, 0]) cube([0.2, 0.9, 0.2], center=true);
            translate([0, 0.45, -0.15]) sphere(r=0.25, $fn=10);
        }
    }
}

module room_base_platforms() {
    total_locker_width = locker_num_bays * locker_bay_width + (locker_num_bays + 1) * plywood_thickness;

    // 1. Locker Platform (South-East corner, recessed from front Y=18)
    color(color_platform)
    translate([north_wall_length - total_locker_width, 0, 0])
        cube([total_locker_width, locker_depth - toe_kick_recess, base_platform_height]);

    // 2. North Bench Platform (North-East wall, recessed from front Y=53)
    color(color_platform)
    translate([59, east_wall_length - bench_depth + toe_kick_recess, 0])
        cube([49, bench_depth - toe_kick_recess, base_platform_height]);

    // 3. East Bench Platform (East wall, recessed from front X=90)
    color(color_platform)
    translate([north_wall_length - bench_depth + toe_kick_recess, 18, 0])
        cube([bench_depth - toe_kick_recess, 35, base_platform_height]);
}

module mudroom_lockers() {
    total_locker_width = locker_num_bays * locker_bay_width + (locker_num_bays + 1) * plywood_thickness;
    
    // Positioned in the South-East corner (rests on base platform at Z = base_platform_height)
    translate([north_wall_length - total_locker_width, 0, base_platform_height]) {
        // 1. Vertical upright side panels and middle dividers (resting on platform)
        for (i = [0 : locker_num_bays]) {
            x_pos = i * (locker_bay_width + plywood_thickness);
            color(color_cabinet)
            translate([x_pos, 0, 0])
                cube([plywood_thickness, locker_depth, locker_height - base_platform_height]);
        }
        
        // 2. Top roof panel
        color(color_cabinet)
        translate([0, 0, locker_height - base_platform_height - plywood_thickness])
            cube([total_locker_width, locker_depth, plywood_thickness]);
            
        // 3. Top cubby divider shelf
        color(color_cabinet)
        translate([0, 0, locker_height - base_platform_height - locker_upper_height - plywood_thickness])
            cube([total_locker_width, locker_depth - 0.5, plywood_thickness]);
            
        // 4. Stained solid wood bench top (1.5" thick with 0.5" overhang in Y, positioned at world Z = 18")
        color(color_floor)
        translate([0, 0, locker_bench_height - base_platform_height - bench_top_thickness])
            cube([total_locker_width, locker_depth + 0.5, bench_top_thickness]);
            
        // 5. Lower cabinet bottom shelf (resting directly on the 2x4 platform)
        color(color_cabinet)
        translate([0, 0, 0])
            cube([total_locker_width, locker_depth, plywood_thickness]);
            
        // 6. Vertical dividers for shoe cubbies under the bench (resting on bottom shelf)
        // Cubby interior height = 18" - 1.5" (bench) - 3.5" (platform) - 0.75" (shelf) = 12.25"
        cubby_interior_height = locker_bench_height - base_platform_height - bench_top_thickness - plywood_thickness;
        for (i = [0 : locker_num_bays - 1]) {
            x_pos = i * (locker_bay_width + plywood_thickness) + plywood_thickness + locker_bay_width / 2 - plywood_thickness / 2;
            color(color_cabinet)
            translate([x_pos, 0, plywood_thickness])
                cube([plywood_thickness, locker_depth - 0.5, cubby_interior_height]);
        }
        
        // 7. Coat hooks (2 per locker bay, 6" below the cubby shelf)
        hook_z = locker_height - base_platform_height - locker_upper_height - plywood_thickness - 6;
        for (i = [0 : locker_num_bays - 1]) {
            x_center = i * (locker_bay_width + plywood_thickness) + plywood_thickness + locker_bay_width / 2;
            
            translate([x_center - locker_bay_width / 4, 0.75, hook_z])
                draw_hook();
            translate([x_center + locker_bay_width / 4, 0.75, hook_z])
                draw_hook();
        }
    }
}

module mudroom_benches() {
    cubby_interior_height = bench_height - base_platform_height - bench_top_thickness - plywood_thickness; // 12.25"

    // 1. North Wall Bench (X: 59 to 108, Y: 53 to 71)
    // Wood bench top (butts into East wall corner at world Z = 18")
    color(color_floor)
    translate([59, east_wall_length - bench_depth, bench_height - bench_top_thickness])
        cube([49, bench_depth, bench_top_thickness]);
        
    // North bench carcass (rests on base platform at Z = base_platform_height)
    color(color_cabinet) {
        // Left support panel (set back due to miter door clearance)
        // Sits on platform, runs up to bottom of bench top
        translate([59, east_wall_length - bench_depth, base_platform_height])
            cube([plywood_thickness, bench_depth, bench_height - base_platform_height - bench_top_thickness]);
            
        // Right support panel (flushes with East bench face)
        translate([90 - plywood_thickness, east_wall_length - bench_depth, base_platform_height])
            cube([plywood_thickness, bench_depth, bench_height - base_platform_height - bench_top_thickness]);
            
        // Middle divider
        translate([59 + 24.5 - plywood_thickness/2, east_wall_length - bench_depth, base_platform_height])
            cube([plywood_thickness, bench_depth - 0.5, bench_height - base_platform_height - bench_top_thickness]);
            
        // Cabinet bottom shelf (resting on platform)
        translate([59 + plywood_thickness, east_wall_length - bench_depth, base_platform_height])
            cube([49 - 2*plywood_thickness, bench_depth, plywood_thickness]);
    }
    
    // 2. East Wall Bench (X: 90 to 108, Y: 18 to 53)
    // Wood bench top
    color(color_floor)
    translate([north_wall_length - bench_depth, 18, bench_height - bench_top_thickness])
        cube([bench_depth, 35, bench_top_thickness]);
        
    // East bench carcass (rests on platform)
    color(color_cabinet) {
        // South support (against lockers)
        translate([north_wall_length - bench_depth, 18, base_platform_height])
            cube([bench_depth, plywood_thickness, bench_height - base_platform_height - bench_top_thickness]);
            
        // Middle support divider
        translate([north_wall_length - bench_depth, 18 + 17.5 - plywood_thickness/2, base_platform_height])
            cube([bench_depth - 0.5, plywood_thickness, bench_height - base_platform_height - bench_top_thickness]);
            
        // Cabinet bottom shelf (resting on platform)
        translate([north_wall_length - bench_depth, 18 + plywood_thickness, base_platform_height])
            cube([bench_depth, 35 - 2*plywood_thickness, plywood_thickness]);
    }
}

// --- Render Room ---
scale(inch) {
    if (show_walls) room_walls();
    if (show_floor) room_floor();
    
    // Platforms
    if (show_platforms) room_base_platforms();
    
    
    
    room_windows();
    
    // Lockers
    if (show_lockers) mudroom_lockers();
    
    // Benches
    if (show_benches) mudroom_benches();
}
