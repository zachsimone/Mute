//
//  ViewController.m
//  Mute
//
//  Created by Zachary Simone on 16/2/20.
//  Copyright © 2020 Zachary Simone. All rights reserved.
//

#import "MainViewController.h"
#import "AppleScriptController.h"

@implementation MainViewController

/// A reference to the last non-zero volume value - informs what to return to when "unmute" is pressed
NSInteger lastNonZeroValue;
AppleScriptController *scriptController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scriptController = [[AppleScriptController alloc] init];
    
    self.currentVolumeSlider.minValue = 0;
    self.currentVolumeSlider.maxValue = 100;
    [self.currentVolumeSlider setContinuous:YES];
    
   //createInputDeviceArray();
    
    [self updateUI];
}

- (void)updateVolume:(NSInteger*)volume {
    [scriptController setVolume:volume];
    if (*volume > 0) {
        lastNonZeroValue = *volume;
    }
}

- (void)updateUI {
    NSAppleEventDescriptor *volumeResponse = [scriptController getResponse:@"input volume of (get volume settings)"];
    NSInteger volume = [volumeResponse int32Value];
    self.currentVolumeSlider.doubleValue = volume;
    
    if (volume > 0) {
        [self.muteStateButton setTitle:@"Mute"];
    } else {
        [self.muteStateButton setTitle:@"Unmute"];
    }
    
    NSString *labelText = [NSString stringWithFormat:@"Current input volume: %li%%", (long)volume];
    [self.currentInputVolumeTextField setStringValue:labelText];
}

- (IBAction)sliderValueChanged:(NSSliderCell *)sender {
    NSInteger inputVolume = sender.doubleValue;
    [self updateVolume:&inputVolume];
    [self updateUI];
}

- (IBAction)muteButtonPressed:(NSButton *)sender {
    NSAppleEventDescriptor *volumeResponse = [scriptController getResponse:@"input volume of (get volume settings)"];
    NSInteger volume = [volumeResponse int32Value];
    if (volume == 0) {
        // Unmute
        [self updateVolume:&lastNonZeroValue];
    } else {
        // Mute
        NSInteger zero = 0;
        [self updateVolume:&zero];
    }
    [self updateUI];
}

@end
