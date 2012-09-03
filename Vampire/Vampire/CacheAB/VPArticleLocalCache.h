//
//  VPArticleListLocalCache.h
//  AsiaBriefingIPad
//
//  Created by Chen Weigang on 11-12-21.
//  Copyright (c) 2011年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPArticleLocalCache : NSObject

@property (nonatomic, copy) NSString *dataPath;

- (void) initCache;
- (void) clearCache;

+(VPArticleLocalCache *)sharedInstance;
-(BOOL)isArticleCached:(NSString *)fileName;
-(NSDictionary *)loadArticleFromCache:(NSString *)fileName;
-(BOOL)saveArticleToCache:(NSString *)fileName
                     dict:(NSDictionary *)fileData;

@end


extern void URLCacheAlertWithError(NSError *error);
extern void URLCacheAlertWithMessage(NSString *message);
extern void URLCacheAlertWithMessageAndDelegate(NSString *message, id delegate);
