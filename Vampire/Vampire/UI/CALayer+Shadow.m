//
//  CALayer+Shadow.m
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 12-8-10.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "CALayer+Shadow.h"

@implementation CALayer(shadow)

- (void)layerShadow
{
    self.shadowOffset = CGSizeMake(0, 3);
    self.shadowColor=[[UIColor blackColor] CGColor];
    self.shadowRadius = 3;
    self.shadowOpacity = 0.5;
    [self setShouldRasterize:YES];
}

@end
