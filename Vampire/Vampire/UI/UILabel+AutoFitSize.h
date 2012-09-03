//
//  UILable+AutoFitSize.h
//  Quake
//
//  Created by Chen Weigang on 12-5-29.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(AutoFitSize)

// 根据原点及固定宽度，自动适配尺寸
- (void)autoFitSizeOrigin:(CGPoint)origin
                 fixWidth:(float)width;


@end
