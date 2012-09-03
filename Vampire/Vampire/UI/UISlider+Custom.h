//
//  UISlider+Custom.h
//  MM_BVD
//
//  Created by Chen Weigang on 12-4-1.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

// custiomize UISlider

@interface UISlider(Custom)

- (void)customWithThumbImage:(UIImage *)thumb 
                    minImage:(UIImage *)min 
                    maxImage:(UIImage *)max;

@end
