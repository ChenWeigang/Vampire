//
//  VPArticleLocalCache.h
//  AsiaBriefingIPad
//
//  Created by Chen Weigang on 11-12-21.
//  Copyright (c) 2011年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPItemListLocalCache : NSObject

@property (nonatomic, copy) NSString *dataPath;

- (void) initCache;
- (void) clearCache;

+(VPItemListLocalCache *)sharedInstance;
-(BOOL)isItemListCached:(NSString *)fileName;
-(NSArray *)loadItemListFromCache:(NSString *)fileName;
-(BOOL)saveItemListToCache:(NSString *)fileName
                     array:(NSArray *)fileData;

@end


extern void URLCacheAlertWithError(NSError *error);
extern void URLCacheAlertWithMessage(NSString *message);
extern void URLCacheAlertWithMessageAndDelegate(NSString *message, id delegate);