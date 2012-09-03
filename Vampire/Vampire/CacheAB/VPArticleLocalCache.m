		//
//  VPArticleLocalCache.m
//  AsiaBriefingIPad
//
//  Created by Chen Weigang on 11-12-21.
//  Copyright (c) 2011年 Fugu Mobile Limited. All rights reserved.
//

#import "VPArticleLocalCache.h"
VPArticleLocalCache *instanceArticle;

@implementation VPArticleLocalCache
@synthesize dataPath;

- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.dataPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ArticleCache"] copy];
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.dataPath]) {
		return;
	}
    
	/* create a new cache directory */
    NSError *error;
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.dataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:&error]) {
		URLCacheAlertWithError(error);
		return;
	}
}


/* removes every file in the cache directory */

- (void) clearCache
{
	/* remove the cache directory and its contents */
    NSError *error;
	if (![[NSFileManager defaultManager] removeItemAtPath:self.dataPath error:&error]) {
		URLCacheAlertWithError(error);
		return;
	}
    
	/* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:self.dataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:&error]) {
		URLCacheAlertWithError(error);
		return;
	}    
}

/* get modification date of the current cached image */



-(BOOL)isArticleCached:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self.dataPath stringByAppendingString:fileName]];
}

-(NSDictionary *)loadArticleFromCache:(NSString *)fileName
{        
    //    NSError *error;
    
    NSDictionary *articleDict = [NSDictionary dictionaryWithContentsOfFile:[self.dataPath stringByAppendingString:fileName]];
    //    NSLog(@"err = %@", error);
    return articleDict;
}

-(BOOL)saveArticleToCache:(NSString *)fileName
                     dict:(NSDictionary *)fileData;
{
    
    NSLog(@"data = %@", fileData);
        
    NSString *path = [self.dataPath stringByAppendingFormat:@"%@", fileName];
    BOOL success = [fileData writeToFile:path
                              atomically:YES];
    
    if (success) {
        NSLog(@"cache article:%@ success!", fileName);
    }
    else{
        NSLog(@"cache article:%@ failed!", fileName);
    }
    
    return success;
    //    }
}

#pragma mark - Singleton 

+(VPArticleLocalCache *)sharedInstance{    
    @synchronized(self){
        if (instanceArticle==nil) {                
            instanceArticle = [[VPArticleLocalCache alloc] init];// assignment not done here
            [instanceArticle initCache];
        }
    }
    
    return instanceArticle;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (instanceArticle == nil) {
            instanceArticle = [super allocWithZone:zone];
            return instanceArticle;  // assignment and return on first allocation
        }
    }
    
    return nil; //on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

//- (id)retain
//{
//    return self;
//}
//
//- (unsigned)retainCount
//{
//    return UINT_MAX;  //denotes an object that cannot be released
//}
//
//- (oneway void)release
//{
//    //do nothing
//}
//
//- (id)autorelease
//{
//    return self;
//}

@end

