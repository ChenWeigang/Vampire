//
//  VPFlashLight.m
//  Quake
//
//  Created by Chen Weigang on 12-5-4.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

//#ifdef VAMPIRE_AVFOUNDATION

#import "VPFlashLight.h"

@implementation VPFlashLight

+ (void)toggleFlashLight
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (device.torchMode==AVCaptureTorchModeOn) {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        else {            
            [device setTorchMode:AVCaptureTorchModeOn];
        }
          // use AVCaptureTorchModeOff to turn off
        [device unlockForConfiguration];
    }
}

+ (BOOL)isFlashLightSupported
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch]){
        return YES;
    }
    
    return NO;
}

@end

//#endif
