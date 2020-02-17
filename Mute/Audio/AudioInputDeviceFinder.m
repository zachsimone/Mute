//
//  AudioInputDeviceFinder.m
//  Mute
//
//  Created by Zachary Simone on 17/2/20.
//  Copyright © 2020 Zachary Simone. All rights reserved.
//

#import "AudioInputDeviceFinder.h"
#include <CoreAudio/CoreAudio.h>

@implementation AudioInputDeviceFinder

/// Get current input devices
/// Heavily inspired by: https://stackoverflow.com/a/4577271
-(CFArrayRef) createInputDeviceArray {
    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMaster
    };
    
    UInt32 dataSize = 0;
    OSStatus status = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &dataSize);
    if(kAudioHardwareNoError != status) {
        fprintf(stderr, "AudioObjectGetPropertyDataSize (kAudioHardwarePropertyDevices) failed: %i\n", status);
        return NULL;
    }
    
    AudioDeviceID s = 0;
    UInt32 deviceCount = dataSize / sizeof(s);
    
    AudioDeviceID *audioDevices = malloc(dataSize);
    if(NULL == audioDevices) {
        fputs("Unable to allocate memory", stderr);
        return NULL;
    }
    
    status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &dataSize, audioDevices);
    if(kAudioHardwareNoError != status) {
        fprintf(stderr, "AudioObjectGetPropertyData (kAudioHardwarePropertyDevices) failed: %i\n", status);
        (void)(free(audioDevices)), audioDevices = NULL;
        return NULL;
    }
    
    CFMutableArrayRef inputDeviceArray = CFArrayCreateMutable(kCFAllocatorDefault, deviceCount, &kCFTypeArrayCallBacks);
    if(NULL == inputDeviceArray) {
        fputs("CFArrayCreateMutable failed", stderr);
        (void)(free(audioDevices)), audioDevices = NULL;
        return NULL;
    }
    
    // Iterate through all the devices and determine which are input-capable
    propertyAddress.mScope = kAudioDevicePropertyScopeInput;

    for(UInt32 i = 0; i < deviceCount; ++i) {
        // Query device UID
        CFStringRef deviceUID = NULL;
        dataSize = sizeof(deviceUID);
        propertyAddress.mSelector = kAudioDevicePropertyDeviceUID;
        status = AudioObjectGetPropertyData(audioDevices[i], &propertyAddress, 0, NULL, &dataSize, &deviceUID);
        if(kAudioHardwareNoError != status) {
            fprintf(stderr, "AudioObjectGetPropertyData (kAudioDevicePropertyDeviceUID) failed: %i\n", status);
            continue;
        }
        
        // Query device name
        CFStringRef deviceName = NULL;
        dataSize = sizeof(deviceName);
        propertyAddress.mSelector = kAudioDevicePropertyDeviceNameCFString;
        status = AudioObjectGetPropertyData(audioDevices[i], &propertyAddress, 0, NULL, &dataSize, &deviceName);
        if(kAudioHardwareNoError != status) {
            fprintf(stderr, "AudioObjectGetPropertyData (kAudioDevicePropertyDeviceNameCFString) failed: %i\n", status);
            continue;
        }
        
        // Determine if the device is an input device (it is an input device if it has input channels)
        dataSize = 0;
        propertyAddress.mSelector = kAudioDevicePropertyStreamConfiguration;
        status = AudioObjectGetPropertyDataSize(audioDevices[i], &propertyAddress, 0, NULL, &dataSize);
        if(kAudioHardwareNoError != status) {
            fprintf(stderr, "AudioObjectGetPropertyDataSize (kAudioDevicePropertyStreamConfiguration) failed: %i\n", status);
            continue;
        }
        
        AudioBufferList *bufferList = malloc(dataSize);
        if(NULL == bufferList) {
            fputs("Unable to allocate memory", stderr);
            break;
        }
        
        status = AudioObjectGetPropertyData(audioDevices[i], &propertyAddress, 0, NULL, &dataSize, bufferList);
        if(kAudioHardwareNoError != status || 0 == bufferList->mNumberBuffers) {
            if(kAudioHardwareNoError != status)
                fprintf(stderr, "AudioObjectGetPropertyData (kAudioDevicePropertyStreamConfiguration) failed: %i\n", status);
            (void)(free(bufferList)), bufferList = NULL;
            continue;
        }
        
        (void)(free(bufferList)), bufferList = NULL;
        
        // Add a dictionary for this device to the array of input devices
        CFStringRef keys    []  = { CFSTR("deviceUID"),     CFSTR("deviceName") };
        CFStringRef values  []  = { deviceUID,              deviceName };
        
        CFDictionaryRef deviceDictionary = CFDictionaryCreate(kCFAllocatorDefault,
                                                              (const void **)keys,
                                                              (const void **)values,
                                                              2,
                                                              &kCFTypeDictionaryKeyCallBacks,
                                                              &kCFTypeDictionaryValueCallBacks);
        
        CFArrayAppendValue(inputDeviceArray, deviceDictionary);
        
        (void)(CFRelease(deviceDictionary)), deviceDictionary = NULL;
    }
    
    (void)(free(audioDevices)), audioDevices = NULL;
    
    // Return a non-mutable copy of the array
    CFArrayRef copy = CFArrayCreateCopy(kCFAllocatorDefault, inputDeviceArray);
    (void)(CFRelease(inputDeviceArray)), inputDeviceArray = NULL;
    
    return copy;
}

@end
