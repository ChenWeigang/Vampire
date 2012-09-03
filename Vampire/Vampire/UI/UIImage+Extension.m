//
//  UIImageEx.m
//  ThirdParty
//
//  Created by Chen Weigang on 12-3-12.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage(Extension)

+(UIImage *)imageName_1x:(NSString *)name 
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", name]];
}

+(UIImage *)imageName_2x:(NSString *)name 
{
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", name]];
}

+(UIImage *)imageNameEx:(NSString *)name
{
    UIImage *image = nil;
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00) {
        // RETINA DISPLAY
        image = [UIImage imageName_2x:name]; 
        
        if (image==nil) {                              
            image = [UIImage imageName_1x:name]; 
        }                
    }
    else{        
        image = [UIImage imageName_1x:name]; 
        
        if (image==nil) {                              
            image = [UIImage imageName_2x:name]; 
        }       
    }
    
    if (image==nil) {        
        NSLog(@"load %@ failed!", name);
    }
    //    else{
    //        DEBUG_NSLog(@"load %@ success!", fullName);        
    //    }
    
    return image;
}

//+ (UIImage *)imageNamedEx:(NSString *)name
//{
//    assert(name);
//    
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
//        if ([name hasSuffix:@".png"]) {
//            name = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
//        }
//        
//        if ([name hasSuffix:@"@2x"]) {
//            name = [name stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
//            name = [name stringByAppendingString:@"_iPad@2x.png"];
//        }
//        else {
//            name = [name stringByAppendingString:@"_iPad.png"];
//        }
//    }
//    
//    UIImage *img = [UIImage imageNamed:name];   
//    
//    if (img==nil) {
//        NSLog(@"load image %@ failed!!!", name);
//    }
//    
//    return img;
//}

- (UIImage *)imageBySize:(CGSize)size
{
	UIGraphicsBeginImageContext(size);    
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	[self drawInRect:rect];	
	UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();  
	
	return newimg;  
}

- (UIImage *)imageByScale:(CGSize)scale
{
    return [self imageBySize:CGSizeMake(self.size.width*scale.width, self.size.height*scale.height)];
}

- (UIImage *)imageClip:(CGRect)rect
{
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();    
    CGRect drawRect = CGRectMake(-rect.origin.x, -rect.origin.y, self.size.width, self.size.height);    
    CGContextClipToRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));    
    [self drawInRect:drawRect];
    UIImage* subImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    
    return subImage;
}

+(UIImage *)imageNamedWithoutCache:(NSString *)fileName {    
    NSString *pathStr = [[NSBundle mainBundle] bundlePath];
	NSString *finalPath = [pathStr stringByAppendingPathComponent:fileName];
    
    return [UIImage imageWithContentsOfFile:finalPath];
}

@end

CGSize sizeOfImageName(NSString *filename)
{
    UIImage *image = [UIImage imageNameEx:filename];
    if ([[filename componentsSeparatedByString:@"@2x"] count]>1) {
        return CGSizeMake(image.size.width/2, image.size.height/2);
    }
    
    return image.size;
}

UIImage* imageVideoFrame(NSURL *url)
{
    MPMoviePlayerController	*mpVC =  [[MPMoviePlayerController alloc] initWithContentURL:url];
    UIImage *image = [[[mpVC thumbnailImageAtTime:0.1f timeOption:MPMovieTimeOptionExact] retain] autorelease]; 
    [mpVC release];
    
    return image;
}
