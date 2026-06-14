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
locker_num_bays     = 4;    // 4 bays for 4 kids
locker_bay_width    = 10.25; // Interior width of each bay (staying clear of door trim)
locker_depth        = 18;
locker_height       = 90;   // 6 inches below window trim (96")
locker_bench_height = 18;
locker_upper_height = 12;   // Height of top cubby bins (12" from the top)
locker_hook_height  = 50;   // Height of hooks from the floor (lower for kids)

// --- Bench Parameters (Inches) ---
bench_depth  = 18;
bench_height = 18;

// --- Visualization Toggles ---
show_north_wall  = false; // Set to false to hide North wall and see interior easily
show_south_wall  = true;  // Set to false to hide South wall
show_east_wall   = true;  // Set to false to hide East wall
show_floor       = true;
show_doors       = true;
show_door_swing  = true;  // Shows the door's opening path/clearance zone on the floor
show_windows     = true;
show_transom     = true;
show_east_window = true;
show_lockers     = true;  // Renders the South wall locker cabinet unit
show_benches     = true;  // Renders the North & East wall L-shaped benches
show_platforms   = true;  // Renders the 2x4 base platforms
show_glass       = false; // Set to false to hide glass panes if preview transparency blocks your view
show_baskets     = true;  // Renders woven rattan baskets inside the cubbies

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
color_basket       = [0.82, 0.70, 0.54, 1.0]; // Natural rattan/wicker color

module room_walls() {
    // North Wall: X from 0 to 108 + thickness, Y from 71 to 71 + thickness
    if (show_north_wall) {
        color(color_wall)
        difference() {
            translate([0, east_wall_length, 0])
                cube([north_wall_length + wall_thickness, wall_thickness, wall_height]);
            
            // North door opening cut
            translate([north_wall_length - north_door_from_east - north_door_width, east_wall_length - 0.5, 0])
                cube([north_door_width, wall_thickness + 1, north_door_height]);
                
            // North window opening cut
            if (show_windows) {
                translate([north_wall_length - window_from_east - window_width, east_wall_length - 0.5, window_bottom_height])
                    cube([window_width, wall_thickness + 1, window_height]);
            }

            // Transom window opening cut
            if (show_transom) {
                translate([north_wall_length - north_door_from_east - north_door_width, east_wall_length - 0.5, transom_bottom_height])
                    cube([north_door_width, wall_thickness + 1, transom_height]);
            }
        }
    }

    // South Wall: X from 0 to 108 + thickness, Y from -thickness to 0
    if (show_south_wall) {
        color(color_wall)
        difference() {
            translate([0, -wall_thickness, 0])
                cube([south_wall_length + wall_thickness, wall_thickness, wall_height]);
            
            // South door opening cut
            translate([south_wall_length - south_door_from_east - south_door_width, -wall_thickness - 0.5, 0])
                cube([south_door_width, wall_thickness + 1, south_door_height]);
        }
    }

    // East Wall: X from 108 to 108 + thickness, Y from 0 to 71
    if (show_east_wall) {
        color(color_wall)
        difference() {
            translate([north_wall_length, 0, 0])
                cube([wall_thickness, east_wall_length, wall_height]);
            
            // East window opening cut
            if (show_east_window) {
                translate([north_wall_length - 0.5, east_wall_length - east_window_from_north - east_window_width, east_window_bottom_height])
                    cube([wall_thickness + 1, east_window_width, east_window_height]);
            }
        }
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
    // North Window (only if North wall is shown)
    if (show_windows && show_north_wall) {
        window_x = north_wall_length - window_from_east - window_width;
        window_unit(window_x, east_wall_length, window_bottom_height, window_width, window_height);
    }
    
    // Transom Window (only if North wall is shown)
    if (show_transom && show_north_wall) {
        transom_x = north_wall_length - north_door_from_east - north_door_width;
        window_unit(transom_x, east_wall_length, transom_bottom_height, north_door_width, transom_height);
    }
    
    // East Window (only if East wall is shown)
    if (show_east_window && show_east_wall) {
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

// Reusable Basket/Bin Component
module basket_unit(w, d, h) {
    color(color_basket) {
        difference() {
            // Main basket box
            cube([w, d, h]);
            // Hollow interior
            translate([0.5, 0.5, 0.5])
                cube([w - 1, d - 1, h]);
            // Front handle slot (centered on the Y = d face)
            translate([w/2 - 1.5, d - 0.75, h - 3.5])
                cube([3, 1.0, 1.25]);
        }
    }
}

module room_base_platforms() {
    total_locker_width = locker_num_bays * locker_bay_width + (locker_num_bays + 1) * plywood_thickness;

    // 1. Locker Platform (South-East corner, recessed from front Y=18)
    if (show_south_wall) {
        color(color_platform)
        translate([north_wall_length - total_locker_width, 0, 0])
            cube([total_locker_width, locker_depth - toe_kick_recess, base_platform_height]);
    }

    // 2. North Bench Platform (North-East wall, recessed from front Y=53)
    if (show_north_wall) {
        color(color_platform)
        translate([59, east_wall_length - bench_depth + toe_kick_recess, 0])
            cube([49, bench_depth - toe_kick_recess, base_platform_height]);
    }

    // 3. East Bench Platform (East wall, recessed from front X=90)
    if (show_east_wall) {
        color(color_platform)
        translate([north_wall_length - bench_depth + toe_kick_recess, 18, 0])
            cube([bench_depth - toe_kick_recess, 35, base_platform_height]);
    }
}

module mudroom_lockers() {
    total_locker_width = locker_num_bays * locker_bay_width + (locker_num_bays + 1) * plywood_thickness;
    
    // Positioned in the South-East corner (rests on base platform at Z = base_platform_height)
    translate([north_wall_length - total_locker_width, 0, base_platform_height]) {
        // 1. Vertical upright divider panels above the benchtop (Z = 14.5 to 86.5)
        for (i = [0 : locker_num_bays]) {
            x_pos = i * (locker_bay_width + plywood_thickness);
            color(color_cabinet)
            translate([x_pos, 0, locker_bench_height - base_platform_height])
                cube([plywood_thickness, locker_depth, locker_height - locker_bench_height]);
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
            
        // 6. Under-bench vertical support panels (spaced to bisect the floor space)
        // Splitting the 45" wide carcass into two equal-width compartments below the bench (21.3" interior each)
        support_h = locker_bench_height - base_platform_height - bench_top_thickness - plywood_thickness; // 12.25"
        
        // Left outer support panel (X = 0)
        color(color_cabinet)
        translate([0, 0, plywood_thickness])
            cube([plywood_thickness, locker_depth, support_h]);
            
        // Middle bisecting support panel (centered under the bench)
        color(color_cabinet)
        translate([total_locker_width/2 - plywood_thickness/2, 0, plywood_thickness])
            cube([plywood_thickness, locker_depth, support_h]);
            
        // Right outer support panel (flush against East wall at X = total_locker_width - thickness)
        color(color_cabinet)
        translate([total_locker_width - plywood_thickness, 0, plywood_thickness])
            cube([plywood_thickness, locker_depth, support_h]);
        
        // 7. Coat hooks (2 per locker bay, 6" below the cubby shelf)
        hook_z = locker_hook_height - base_platform_height;
        for (i = [0 : locker_num_bays - 1]) {
            left_wall_x = i * (locker_bay_width + plywood_thickness) + plywood_thickness;
            right_wall_x = (i + 1) * (locker_bay_width + plywood_thickness);
            
            // Left hook (mounted on left wall, extending +X)
            translate([left_wall_x, locker_depth / 2, hook_z])
                rotate([0, 0, -90])
                draw_hook();
                
            // Right hook (mounted on right wall, extending -X)
            translate([right_wall_x, locker_depth / 2, hook_z])
                rotate([0, 0, 90])
                draw_hook();
        }
        
        // 8. Baskets (if toggled on)
        if (show_baskets) {
            basket_w = locker_bay_width - 1.0; // ~9.25" wide
            basket_d = locker_depth - 1.0;     // ~17" deep
            basket_h = locker_upper_height - 2.0; // ~10" tall
            
            // Baskets in the top cubbies (1 in each of the 4 bays)
            for (i = [0 : locker_num_bays - 1]) {
                x_pos = i * (locker_bay_width + plywood_thickness) + plywood_thickness + (locker_bay_width - basket_w)/2;
                translate([x_pos, 0.5, locker_height - base_platform_height - locker_upper_height])
                    basket_unit(basket_w, basket_d, basket_h);
            }
            
            // Baskets in the bottom cubbies (exactly 2 baskets total, centered in the 2 visible compartments)
            visible_locker_w = total_locker_width - bench_depth; // 26.75"
            comp_w = visible_locker_w / 2 - plywood_thickness;  // ~12.6"
            basket_lw = 11.0; // 11" wide baskets (slide out of the visible openings)
            gap = (comp_w - basket_lw) / 2;
            
            // Compartment 1 (left visible bay)
            translate([plywood_thickness + gap, 0.5, plywood_thickness])
                basket_unit(basket_lw, basket_d, 10);
                
            // Compartment 2 (right visible bay)
            comp2_x = visible_locker_w / 2 + plywood_thickness / 2;
            translate([comp2_x + gap, 0.5, plywood_thickness])
                basket_unit(basket_lw, basket_d, 10);
        }
    }
}

module mudroom_benches() {
    cubby_interior_height = bench_height - base_platform_height - bench_top_thickness - plywood_thickness; // 12.25"

    // Spacing variables for East Bench (shared between carcass and baskets)
    visible_east_w = 53 - 18;
    east_bay_w = (visible_east_w - 2 * plywood_thickness) / 3;
    y_pos_1 = 18 + east_bay_w + plywood_thickness/2;
    y_pos_2 = 18 + 2 * east_bay_w + 1.5 * plywood_thickness;

    // 1. North Wall Bench (X: 59 to 108, Y: 53 to 71)
    // Wood bench top (butts into East wall corner at world Z = 18")
    color(color_floor)
    translate([59, east_wall_length - bench_depth, bench_height - bench_top_thickness])
        cube([49, bench_depth, bench_top_thickness]);
        
    // North bench carcass (rests on base platform at Z = base_platform_height)
    color(color_cabinet) {
        // Left support panel (set back due to miter door clearance)
        translate([59, east_wall_length - bench_depth, base_platform_height])
            cube([plywood_thickness, bench_depth, bench_height - base_platform_height - bench_top_thickness]);
            
        // Middle divider (bisects the visible floor opening: X from 59 to 90)
        color(color_cabinet)
        translate([74.5 - plywood_thickness/2, east_wall_length - bench_depth, base_platform_height])
            cube([plywood_thickness, bench_depth - 0.5, bench_height - base_platform_height - bench_top_thickness]);
            
        // Cabinet bottom shelf (resting on platform, runs all the way to East wall)
        translate([59 + plywood_thickness, east_wall_length - bench_depth, base_platform_height])
            cube([108 - (59 + plywood_thickness), bench_depth, plywood_thickness]);
    }
    
    // 2. East Wall Bench (X: 90 to 108, Y: 18 to 53)
    // Wood bench top
    color(color_floor)
    translate([north_wall_length - bench_depth, 18, bench_height - bench_top_thickness])
        cube([bench_depth, 35, bench_top_thickness]);
        
    // East bench carcass (rests on platform)
    color(color_cabinet) {
        // South support against lockers removed to allow open access to corner storage
        
        // Two support dividers splitting the 35" visible opening into 3 equal bays
        // Divider 1
        translate([north_wall_length - bench_depth, y_pos_1 - plywood_thickness/2, base_platform_height])
            cube([bench_depth - 0.5, plywood_thickness, bench_height - base_platform_height - bench_top_thickness]);
            
        // Divider 2
        translate([north_wall_length - bench_depth, y_pos_2 - plywood_thickness/2, base_platform_height])
            cube([bench_depth - 0.5, plywood_thickness, bench_height - base_platform_height - bench_top_thickness]);
            
        // Cabinet bottom shelf (resting on platform, runs up to North bench Y=53)
        translate([north_wall_length - bench_depth, 18 + plywood_thickness, base_platform_height])
            cube([bench_depth, 53 - (18 + plywood_thickness), plywood_thickness]);
            
        // 3. Inside Corner Support Posts (2"x2" support legs at corner intersections)
        // North-East corner pillar
        translate([90, 53, base_platform_height])
            cube([2, 2, bench_height - base_platform_height - bench_top_thickness]);
            
        // South-East corner pillar (between lockers and East bench)
        translate([90, 18 - 2, base_platform_height])
            cube([2, 2, bench_height - base_platform_height - bench_top_thickness]);
    }
    
    // 4. Baskets inside benches (if toggled on)
    if (show_baskets) {
        // North Bench Baskets
        // Left compartment: X = 59.75 to 74.125 (width 14.375"). Hand facing South (Y-minus).
        basket_n1_w = 13.0;
        basket_n_d  = bench_depth - 1.0; // 17"
        translate([59.75 + basket_n1_w + (14.375 - basket_n1_w)/2, east_wall_length - bench_depth + 0.5 + basket_n_d, base_platform_height + plywood_thickness])
            rotate([0, 0, 180])
            basket_unit(basket_n1_w, basket_n_d, 10);
            
        // Right visible compartment: X = 74.875 to 90 (width 15.125"). Hand facing South (Y-minus).
        basket_n2_w = 13.5;
        translate([74.875 + basket_n2_w + (15.125 - basket_n2_w)/2, east_wall_length - bench_depth + 0.5 + basket_n_d, base_platform_height + plywood_thickness])
            rotate([0, 0, 180])
            basket_unit(basket_n2_w, basket_n_d, 10);
            
        // East Bench Baskets (1 basket per compartment, facing West, i.e., rotated 90 deg around Z)
        basket_ew = 9.5;
        basket_e_d = bench_depth - 1.0; // 17"
        
        // Compartment 1: Y = 18 to y_pos_1
        y_center_1 = 18 + (east_bay_w - basket_ew)/2;
        translate([north_wall_length - bench_depth + 0.5 + basket_e_d, y_center_1, base_platform_height + plywood_thickness])
            rotate([0, 0, 90])
            basket_unit(basket_ew, basket_e_d, 10);
            
        // Compartment 2: y_pos_1 to y_pos_2
        y_center_2 = y_pos_1 + plywood_thickness/2 + (east_bay_w - basket_ew)/2;
        translate([north_wall_length - bench_depth + 0.5 + basket_e_d, y_center_2, base_platform_height + plywood_thickness])
            rotate([0, 0, 90])
            basket_unit(basket_ew, basket_e_d, 10);
            
        // Compartment 3: y_pos_2 to 53
        y_center_3 = y_pos_2 + plywood_thickness/2 + (east_bay_w - basket_ew)/2;
        translate([north_wall_length - bench_depth + 0.5 + basket_e_d, y_center_3, base_platform_height + plywood_thickness])
            rotate([0, 0, 90])
            basket_unit(basket_ew, basket_e_d, 10);
    }
}

// --- Render Room ---
scale(inch) {
    room_walls();
    if (show_floor) room_floor();
    
    // Platforms
    if (show_platforms) room_base_platforms();
    
    room_windows();
    
    // Lockers
    if (show_lockers) mudroom_lockers();
    
    // Benches
    if (show_benches) mudroom_benches();
}
