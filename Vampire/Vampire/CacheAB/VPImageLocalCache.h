//
//  VPImageLocalCache.h
//  AsiaBriefingIPad
//
//  Created by Chen Weigang on 11-12-20.
//  Copyright (c) 2011年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPImageLocalCache : NSObject

- (void) initCache;
- (void) clearCache;

+(VPImageLocalCache *)sharedInstance;
-(BOOL)isImageCached:(NSString *)fileName;
-(UIImage *)loadImageFromCache:(NSString *)fileName;
-(BOOL)saveImageToCache:(NSString *)fileName
                   data:(NSData *)fileData;

@end


extern void URLCacheAlertWithError(NSError *error);
extern void URLCacheAlertWithMessage(NSString *message);
extern void URLCacheAlertWithMessageAndDelegate(NSString *message, id delegate);
