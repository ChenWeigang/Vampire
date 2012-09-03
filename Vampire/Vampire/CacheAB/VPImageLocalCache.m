//
//  VPImageLocalCache.m
//  AsiaBriefingIPad
//
//  Created by Chen Weigang on 11-12-20.
//  Copyright (c) 2011年 Fugu Mobile Limited. All rights reserved.
//

#import "VPImageLocalCache.h"

VPImageLocalCache *instanceImage;
NSString *dataPath;

@implementation VPImageLocalCache

- (void) initCache
{
	/* create path to cache directory inside the application's Documents directory */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dataPath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:@"ImageCache"] copy];
    
	/* check for existence of cache directory */
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
		return;
	}
    
	/* create a new cache directory */
    NSError *error;
	if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath
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
	if (![[NSFileManager defaultManager] removeItemAtPath:dataPath error:&error]) {
		URLCacheAlertWithError(error);
		return;
	}
    
	/* create a new cache directory */
	if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath
								   withIntermediateDirectories:NO
													attributes:nil
														 error:&error]) {
		URLCacheAlertWithError(error);
		return;
	}    
}

/* get modification date of the current cached image */



-(BOOL)isImageCached:(NSString *)fileName
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[dataPath stringByAppendingString:fileName]];
}

-(UIImage *)loadImageFromCache:(NSString *)fileName
{        
	UIImage *theImage = [[[UIImage alloc] initWithContentsOfFile:[dataPath stringByAppendingString:fileName]] autorelease];
    return theImage;
}

-(BOOL)saveImageToCache:(NSString *)fileName
                   data:(NSData *)fileData;
{
//    NSError *error;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[dataPath stringByAppendingString:fileName]] == YES) {    
//        if (![[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
//            URLCacheAlertWithError(error);
//        }
        NSLog(@"already cached!");
        return YES;
	}
    else {
		/* file doesn't exist, so create it */
		BOOL success = [[NSFileManager defaultManager] createFileAtPath:[dataPath stringByAppendingString:fileName]
                                                       contents:fileData
                                                     attributes:nil];
        if (success) {
            NSLog(@"cache image:%@ success!", fileName);
        }
        else{
            NSLog(@"cache image:%@ failed!", fileName);
        }
        
        return success;
    }
}

#pragma mark - Singleton 

+(VPImageLocalCache *)sharedInstance{    
    @synchronized(self){
        if (instanceImage==nil) {                
            instanceImage = [[VPImageLocalCache alloc] init];// assignment not done here
            [instanceImage initCache];
        }
    }
    
    return instanceImage;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self) {
        if (instanceImage == nil) {
            instanceImage = [super allocWithZone:zone];
            return instanceImage;  // assignment and return on first allocation
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




void URLCacheAlertWithError(NSError *error)
{
    NSString *message = [NSString stringWithFormat:@"Error! %@ %@",
						 [error localizedDescription],
						 [error localizedFailureReason]];
	
	URLCacheAlertWithMessage (message);
}


void URLCacheAlertWithMessage(NSString *message)
{
	/* open an alert with an OK button */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URLCache" 
													message:message
												   delegate:nil 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles: nil];
	[alert show];
//	[alert release];
}


void URLCacheAlertWithMessageAndDelegate(NSString *message, id delegate)
{
	/* open an alert with OK and Cancel buttons */
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"URLCache" 
													message:message
												   delegate:delegate 
										  cancelButtonTitle:@"Cancel" 
										  otherButtonTitles: @"OK", nil];
	[alert show];
//	[alert release];
}
