//
//  UILable+AutoFitSize.m
//  Quake
//
//  Created by Chen Weigang on 12-5-29.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "UILabel+AutoFitSize.h"

@implementation UILabel(AutoFitSize)

- (void)autoFitSizeOrigin:(CGPoint)origin
                 fixWidth:(float)width
{
    self.frame = CGRectMake(origin.x, origin.y, width, 0);
    self.lineBreakMode = UILineBreakModeWordWrap;
    self.numberOfLines = 0;
    [self sizeToFit];
}

@end
