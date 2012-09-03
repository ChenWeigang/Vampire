//
//  VPFlashLight.h
//  Quake
//
//  Created by Chen Weigang on 12-5-4.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//


//#ifdef VAMPIRE_AVFOUNDATION

#import <Foundation/Foundation.h>
#import "AVFoundation/AVFoundation.h"

@interface VPFlashLight : NSObject

+ (void)toggleFlashLight;
+ (BOOL)isFlashLightSupported;

@end


//#endif
