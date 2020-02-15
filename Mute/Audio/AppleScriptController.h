//
//  AppleScriptController.h
//  Mute
//
//  Created by Zachary Simone on 16/2/20.
//  Copyright © 2020 Zachary Simone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppleScriptController : NSObject

-(void) runCommand:(NSString*)command;
-(void) setVolume:(int*)volume;
-(void) getResponse:(NSString*)command :(void (^)(NSAppleEventDescriptor* response))completion;

@end

NS_ASSUME_NONNULL_END
