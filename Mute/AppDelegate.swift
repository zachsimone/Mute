//
//  AppDelegate.swift
//  Mute
//
//  Created by Zachary Simone on 25/6/18.
//  Copyright © 2018 Zachary Simone. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        for window: AnyObject in sender.windows {
            window.makeKeyAndOrderFront(self)
        }
        return true
    }

}

