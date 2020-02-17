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

AppleScriptController *scriptController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scriptController = [[AppleScriptController alloc] init];
    
    self.currentVolumeSlider.minValue = 0;
    self.currentVolumeSlider.maxValue = 100;
    [self.currentVolumeSlider setContinuous:YES];
    
   //createInputDeviceArray();
    
    [self setValues];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)setValues {
    UInt32 volume = [[scriptController getResponse:@"input volume of (get volume settings)"] int32Value];
    self.currentVolumeSlider.doubleValue = volume;
    NSString *labelText = [NSString stringWithFormat:@"Current input volume %i%%", volume];
    [self.currentInputVolumeTextField setStringValue:labelText];
}

- (IBAction)sliderValueChanged:(NSSliderCell *)sender {
    int inputVolumeValue = sender.intValue;
    [scriptController setVolume:&inputVolumeValue];
    [self setValues];
}


@end
