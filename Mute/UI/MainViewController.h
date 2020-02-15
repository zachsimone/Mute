//
//  ViewController.h
//  Mute
//
//  Created by Zachary Simone on 16/2/20.
//  Copyright © 2020 Zachary Simone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainViewController : NSViewController

@property (weak) IBOutlet NSTextField *currentInputVolumeTextField;
@property (weak) IBOutlet NSSlider *currentVolumeSlider;
@property (weak) IBOutlet NSButton *muteStateButton;

@property (weak) IBOutlet NSPopUpButton *inputDeviceSelector;

@end

