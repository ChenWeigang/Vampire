//
//  UISlider+Custom.m
//  MM_BVD
//
//  Created by Chen Weigang on 12-4-1.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "UISlider+Custom.h"

@implementation UISlider(Custom)

- (void)customWithThumbImage:(UIImage *)thumb 
                    minImage:(UIImage *)min 
                    maxImage:(UIImage *)max 
{    
    self.backgroundColor = [UIColor clearColor];	
    UIImage *stetchLeftTrack = [min stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    UIImage *stetchRightTrack = [max stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0];
    [self setThumbImage:thumb forState:UIControlStateNormal];
    [self setThumbImage:thumb forState:UIControlStateHighlighted];
    [self setMinimumTrackImage:stetchLeftTrack forState:UIControlStateNormal];
    [self setMaximumTrackImage:stetchRightTrack forState:UIControlStateNormal];
    self.minimumValue = 0.0;
    self.maximumValue = 1.0;
    self.continuous = YES;
    self.value = 0;    
}

@end
