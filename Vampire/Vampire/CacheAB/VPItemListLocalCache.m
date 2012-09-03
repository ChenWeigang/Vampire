//
//  VPArticleLocalCache.m
//  AsiaBriefingIPad
//
//  Created by Chen Weigang on 11-12-21.
//  Copyright (c) 2011年 Fugu Mobile Limited. All rights reserved.
//

#import "VPItemListLocalCache.h"
VPItemListLocalCache *instanceItemList;

@implementation VPItemListLocalCache
@synthesize dataPath;

- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.dataPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ItemListCache"] copy];
    
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



-(BOOL)isItemListCached:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self.dataPath stringByAppendingString:fileName]];
}

-(NSArray *)loadItemListFromCache:(NSString *)fileName
{        
//    NSError *error;
    
    NSArray *itemList = [NSArray arrayWithContentsOfFile:[self.dataPath stringByAppendingString:fileName]];
//    NSLog(@"err = %@", error);
    return itemList;
}

-(BOOL)saveItemListToCache:(NSString *)fileName
                   array:(NSArray *)fileData;
{

//    NSLog(@"data = %@", fileData);
//    
//    NSMutableArray *newArray = [[[NSMutableArray alloc] initWithCapacity:[fileData count]] autorelease];
//    
//    for (int i=0; i<[fileData count]; i++) {
//        NSDictionary *dict = [fileData objectAtIndex:i];
//        NSMutableDictionary *newDict = [[NSMutableDictionary alloc] init];
//        [newDict setObject:[dict objectForKey:@"id"] forKey:@"id"];
//        [newDict setObject:[dict objectForKey:@"title"] forKey:@"title"];
//        [newDict setObject:[dict objectForKey:@"description"] forKey:@"description"];
//        [newDict setObject:[dict objectForKey:@"image"] forKey:@"image"];
//        
//        [newArray addObject:newDict];
//        [newDict release];
//    }
//    
//    NSLog(@"new array = %@", newArray);
    
    
//    NSArray *arr = [NSArray arrayWithObjects:@"111",@"222", nil];
//    NSLog(@"name = %@", [self.dataPath stringByAppendingString:@"/cache.txt"]);
        NSString *path = [self.dataPath stringByAppendingFormat:@"%@", fileName];
    BOOL success = [fileData writeToFile:path
                              atomically:YES];
        
        if (success) {
            NSLog(@"cache item list:%@ success!", fileName);
        }
        else{
            NSLog(@"cache item list:%@ failed!", fileName);
        }
        
        return success;
//    }
}

#pragma mark - Singleton 

+(VPItemListLocalCache *)sharedInstance{    
    @synchronized(self){
        if (instanceItemList==nil) {                
            instanceItemList = [[VPItemListLocalCache alloc] init];// assignment not done here
            [instanceItemList initCache];
        }
    }
    
    return instanceItemList;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (instanceItemList == nil) {
            instanceItemList = [super allocWithZone:zone];
            return instanceItemList;  // assignment and return on first allocation
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






