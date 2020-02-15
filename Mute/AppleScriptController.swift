//
//  RunAppleScriptCommand.swift
//  Mute
//
//  Created by Zachary Simone on 29/6/18.
//  Copyright © 2018 Zachary Simone. All rights reserved.
//

import Foundation

final class AppleScriptController {
    
    // MARK: Public
    
    static func setVolume(to volume: Int) {
        run(command: "set volume input volume \(volume)")
    }
    
    static func getResponse(command: String, completion: ((String)->())) {
        var error: NSDictionary?
        let script = NSAppleScript(source: command)
        if let output: NSAppleEventDescriptor = script?.executeAndReturnError(&error) {
            guard let response = output.stringValue else {
                completion("Error")
                return
            }
            completion(response)
        }
    }
    
    // MARK: Private helper
    
    private static func run(command: String) {
        let script = NSAppleScript(source: command)
        script?.executeAndReturnError(nil)
    }
}
