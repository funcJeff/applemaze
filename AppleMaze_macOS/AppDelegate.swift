//
//  AppDelegate.swift
//  AppleMaze macOS
//
//  Created by Jeff Martin on 9/8/19.
//  Copyright © 2019 funcJeff. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
