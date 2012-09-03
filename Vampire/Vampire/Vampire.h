//
//  Vampire.h
//  Vampire
//
//  Created by Chen Weigang on 12-5-3.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#ifndef Vampire_Vampire_h
#define Vampire_Vampire_h

#define DEBUG_MODE

#ifdef DEBUG_MODE
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) 
#endif

#define SAFE_RELEASE(__POINTER) { [__POINTER release]; __POINTER = nil; }
#define SAFE_INVALIDATE_TIMER(__TIMER) { [__TIMER invalidate]; __TIMER = nil; }
#define SAFE_CFRELEASE(__REF) { if (nil != (__REF)) { CFRelease(__REF); __REF = nil; } }


#define DEGREES_TO_RADIANS(x) (M_PI * x / 180.0)
#define RADIANS_TO_DEGREES(x) (x * 180.0 / M_PI)

#import "VPAsynImageView.h"
#import "VPAudioRecorder.h"
#import "VPRequest.h"
#import "CALayer+Animation.h"
#import "VPVideoPlayerViewController.h"
#import "UIView+Animation.h"
#import "UIView+Autoresizing.h"
#import "NSString+Extension.h"
#import "UIImage+Extension.h"
#import "VPUtil.h"

#endif
