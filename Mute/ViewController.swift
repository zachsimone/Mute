//
//  ViewController.swift
//  Mute
//
//  Created by Zachary Simone on 25/6/18.
//  Copyright © 2018 Zachary Simone. All rights reserved.
//

import AudioToolbox
import Cocoa

final class ViewController: NSViewController {
    
    @IBOutlet weak var inputLabelText: NSTextField!
    @IBOutlet weak var volumeSlider: NSSlider!
    @IBOutlet weak var muteButton: NSButton!
    
    private var lastNonZeroVolume: Int?
    private var volume: Int?
    private var currentVolume: Int? {
        get { return volume ?? 0 }
        set {
            guard let value = newValue else { return }
            AppleScriptController.setVolume(to: value)
            inputLabelText.stringValue = "Current input volume: \(value)%"
            volume = value
            muteButton.title = value == 0 ? "Unmute" : "Mute"
            volumeSlider.doubleValue = Double(value)
            guard value == 0 else { lastNonZeroVolume = value; return }
        }
    }
    
    override func viewDidAppear() {
        AppleScriptController.getResponse(command: "input volume of (get volume settings)", completion: { volume in
            if let v = Int(volume) {
                currentVolume = v
                inputLabelText.stringValue = "Current input volume: \(v)%"
            }
        })
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func volumeSliderChanged(_ sender: NSSlider) {
        currentVolume = Int(sender.doubleValue)
    }
    
    @IBAction func mutePressed(_ sender: Any) {
        guard currentVolume == 0 else {
            currentVolume = 0
            return
        }
        currentVolume = lastNonZeroVolume
    }
}

