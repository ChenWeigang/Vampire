//
//  UIImageEx.h
//  ThirdParty
//
//  Created by Chen Weigang on 12-3-12.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface UIImage(Extension)

+(UIImage *)imageNameEx:(NSString *)name;

//+ (UIImage *)imageNamedEx:(NSString *)name; // ipad version add @"_iPad.png"
- (UIImage *)imageBySize:(CGSize)size;
- (UIImage *)imageByScale:(CGSize)scale;
- (UIImage *)imageClip:(CGRect)rect;

+ (UIImage *)imageNamedWithoutCache:(NSString *)fileName;

@end


CGSize sizeOfImageName(NSString *filename);

UIImage* imageVideoFrame(NSURL *url);