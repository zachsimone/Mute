//
//  AppleScriptController.m
//  Mute
//
//  Created by Zachary Simone on 16/2/20.
//  Copyright © 2020 Zachary Simone. All rights reserved.
//

#import "AppleScriptController.h"

@implementation AppleScriptController

-(void) runCommand:(NSString*)command {
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:command];
    [script executeAndReturnError:nil]; // Not handling errors for now
}

-(void) setVolume:(NSInteger*)volume {
    NSString *volumeString = [NSString stringWithFormat:@"%ld", (long)*volume];
    [self runCommand:[[NSString alloc] initWithFormat:@"set volume input volume %@", volumeString]];
}

-(NSAppleEventDescriptor*) getResponse:(NSString*)command {
    NSDictionary *error = nil;
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource:command];
    NSAppleEventDescriptor *result = [script executeAndReturnError:&error];
    NSLog(@"AppleScript command result: %@", result);
    return result;
}

@end
