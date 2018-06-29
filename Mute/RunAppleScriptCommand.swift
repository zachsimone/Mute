//
//  RunAppleScriptCommand.swift
//  Mute
//
//  Created by Zachary Simone on 29/6/18.
//  Copyright © 2018 Zachary Simone. All rights reserved.
//

import Foundation

class AS {
    static func runCommand(command: String) {
        let script = NSAppleScript(source: command)
        script?.executeAndReturnError(nil)
    }
    
    static func setVolume(to volume: Int) {
        let script = NSAppleScript(source: "set volume input volume \(volume)")
        script?.executeAndReturnError(nil)
    }
    
    static func getResponse(command: String, completion: ((String)->())) {
        var error: NSDictionary?
        let script = NSAppleScript(source: command)
        if let output: NSAppleEventDescriptor = script?.executeAndReturnError(
            &error) {
            guard let response = output.stringValue else {
                completion("Error")
                return
            }
            completion(response)
        }
    }
}
