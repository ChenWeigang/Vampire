//
//  VPSearchLightLabel.h
//  SlideToUnlockDemo
//
//  Created by Chen Weigang on 12-5-14.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface VPSearchLightLabel : UILabel {    
    NSTimer *animationTimer;
	CGFloat gradientLocations[3];
	int animationTimerCount;
}

- (void)enableSearchLightEffect;
- (void)disableSearchLightEffect;

@end
