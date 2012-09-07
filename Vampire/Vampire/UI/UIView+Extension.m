//
//  UIView+Extension.m
//  Vampire
//
//  Created by Chen Weigang on 12-5-28.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView(Extension)

- (UIImage *)glViewToUIImage
{
    int w = self.frame.size.width;  // 1024
    int h = self.frame.size.height; // 768
    
    NSInteger myDataLength = w * h * 4;
    
    // allocate array and read pixels into it.
    GLubyte *buffer = (GLubyte *) malloc(myDataLength);
    glReadPixels(0, 0, w, h, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
    
    // gl renders "upside down" so swap top to bottom into new array.
    // there's gotta be a better way, but this works.
    GLubyte *buffer2 = (GLubyte *) malloc(myDataLength);
    for(int y = 0; y <h; y++)
    {
        for(int x = 0; x <w * 4; x++)
        {
            buffer2[(h-1 - y) * w * 4 + x] = buffer[y * 4 * w + x];
        }
    }
    free(buffer);
    
    // make data provider with data.
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, buffer2, myDataLength, NULL);    
    free(buffer2);
    
    // prep the ingredients
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * w;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    // make the cgimage
    CGImageRef imageRef = CGImageCreate(w, h, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    
    CFRelease(colorSpaceRef);
    CFRelease(provider);
    
    // then make the uiimage from that
    UIImage *myImage = [[[UIImage imageWithCGImage:imageRef] retain] autorelease];    
    CFRelease(imageRef);
    
    return myImage;
}


@end
