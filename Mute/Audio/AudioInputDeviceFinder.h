//
//  AudioInputDeviceFinder.h
//  Mute
//
//  Created by Zachary Simone on 17/2/20.
//  Copyright © 2020 Zachary Simone. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AudioInputDeviceFinder : NSObject

-(CFArrayRef) createInputDeviceArray;

@end

NS_ASSUME_NONNULL_END
