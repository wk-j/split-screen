//
//  SnapLayout.swift
//  SplitScreen
//
//  Created by Evan Thompson on 10/13/15.
//  Copyright © 2015 SplitScreen. All rights reserved.
//

import Foundation
import AppKit

class SnapLayout {

    struct point {
        var x = 0;
        var y = 0;
    }
    // How to resize the hardpoint
    private struct hardpoint_resize {
        var upper_left_corner = point()
        var lower_right_corner = point()
    }
	
	private func create_hardpoint(p1: (Int, Int),
									hp1: (Int, Int),
									hp2: (Int, Int)) -> (point, hardpoint_resize) {
		var first_point = point()
		first_point.x = p1.0
		first_point.y = p1.1
		
		var first_point_resize = hardpoint_resize()
		
		var resize_left_corner = point()
		resize_left_corner.x = hp1.0
		resize_left_corner.y = hp1.1
		
		var resize_right_corner = point()
		resize_right_corner.x = hp2.0
		resize_right_corner.y = hp2.1
		
		first_point_resize.upper_left_corner = resize_left_corner
		first_point_resize.lower_right_corner = resize_right_corner
		
		return (first_point, first_point_resize)
	}
    
    // Load layout from file
    func load(file_path: NSString) {
		
		// Bottom left corner of the screen
		hardpoints.append(create_hardpoint((0, 0), hp1: (0, HEIGHT/2), hp2: (WIDTH/2, 0)))
		
		// Top left corner of the screen
		hardpoints.append(create_hardpoint((0, HEIGHT), hp1: (0, 0), hp2: (WIDTH/2, HEIGHT/2)))
		
		// Bottom right corner of the screen
		hardpoints.append(create_hardpoint((WIDTH, 0), hp1: (WIDTH/2, HEIGHT/2), hp2: (WIDTH, 0)))
		
		// Top right corner of the screen
		hardpoints.append(create_hardpoint((WIDTH, HEIGHT), hp1: (WIDTH/2, 0), hp2: (WIDTH, HEIGHT/2)))
    }
    
    // Checks if the location given is a hard point
    func is_hardpoint(x: CGFloat, y: CGFloat) -> Bool {
        let xpos:Int = Int(x + 0.5)
        let ypos:Int = Int(y + 0.5)
        for var i = 0; i < hardpoints.count; ++i{
            if xpos == hardpoints[i].0.x && ypos == hardpoints[i].0.y {
                return true
            }
            if xpos == 0 || xpos == WIDTH {
                return true
            }
            if ypos == HEIGHT {
                return true
            }
        }
        
        return false
    }
    
    // Returns x, y, x_size, y_size
    func get_snap_dimensions(x: CGFloat, y: CGFloat) ->(Int,Int,Int,Int) {
        let x_i:Int = Int(x + 0.5)
        let y_i:Int = Int(y + 0.5)
        for var i = 0; i < hardpoints.count; ++i{
            if x_i == hardpoints[i].0.x && y_i == hardpoints[i].0.y {
                
                // Fix height for the main menu bar
                if hardpoints[i].1.upper_left_corner.y == 0 {
                    return (hardpoints[i].1.upper_left_corner.x, Int(menu!.menuBarHeight), abs(hardpoints[i].1.upper_left_corner.x - hardpoints[i].1.lower_right_corner.x), abs(hardpoints[i].1.upper_left_corner.y - hardpoints[i].1.lower_right_corner.y))
                }
                
                return (hardpoints[i].1.upper_left_corner.x, hardpoints[i].1.upper_left_corner.y, abs(hardpoints[i].1.upper_left_corner.x - hardpoints[i].1.lower_right_corner.x), abs(hardpoints[i].1.upper_left_corner.y - hardpoints[i].1.lower_right_corner.y))
            }
        }
        
        // Check if location is on a side
        if x_i == 0 {
            return (0,Int(menu!.menuBarHeight),WIDTH/2,HEIGHT)
        }
        else if x_i == WIDTH {
            return (WIDTH/2,Int(menu!.menuBarHeight),WIDTH/2,HEIGHT)
        }
        
        // Check if location is on top of screen
        if y_i == HEIGHT {
            return (0,Int(menu!.menuBarHeight),WIDTH, HEIGHT)
        }
        
        return (0,0,0,0)
    }
    
    let menu = NSApplication.sharedApplication().mainMenu
    private var hardpoints = [(point, hardpoint_resize)]()
    private let HEIGHT: Int = Int((NSScreen.mainScreen()?.frame.height)!)
    private let WIDTH: Int = Int((NSScreen.mainScreen()?.frame.width)!)
}