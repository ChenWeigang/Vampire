//
//  VPUtil.h
//  Vampire
//
//  Created by Chen Weigang on 12-3-12.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

// File Managerment
NSString*       filePathAtDocument(NSString *filename);
NSString*       filePathAtMainBundle(NSString *filename);
NSURL*          fileURL(NSString *path);
bool            isFileExistAtPath(NSString *filePath);

// Read and write plist file
NSArray*        arrayFromMainBundle(NSString *fileName);
NSDictionary*   dictionaryFromMainBundle(NSString *fileName);
NSArray*        loadArrayFromDocument(NSString *filename);
NSDictionary*   loadDictionaryFromDocument(NSString *filename);
BOOL            saveArrayToDocument(NSString *filename, NSArray *array);
BOOL            saveDictionaryToDocument(NSString *filename, NSDictionary *dictionary);

// Encoding
NSString*       base64 (NSData *theData);
NSString*       encodeURL(NSString *string);
NSString*       stringUsingEncodingUTF8(NSData *data);
NSString*       stringUsingEncoding(NSData *data, NSStringEncoding encoding);
NSData*         dataUsingEncodingUTF8(NSString *string);
NSData*         dataUsingEncoding(NSString *string, NSStringEncoding encoding);

// Device
NSString*       deviceName(void);
NSString*       deviceModel(void);
NSString*       deviceSystemName(void);
NSString*       deviceSystemVersion(void);
double          systemVersion(void);
bool            isRetinaDisplay(void);
void            deviceInfo(void);
bool            isIPad(void);

// Regular expressions
bool            isEmailFormat(NSString *email);
bool            isCountryCodeFormat(NSString *countryCode);
bool            isMobileFormat(NSString *mobile);
bool            isAccountFormat(NSString *account);
bool            isPasswordFormat(NSString *password);
bool            isFirstLetterNumber(NSString *number);

// Open URL
void            openURL(NSURL *url);
void            openRateURL(NSString *appId);
void            openPhoneCallURL(NSString *tel);

// Serialize NSCoder
bool            archive(id object, NSString *path);
id              unarchive(NSString *path);

// Local Notification
void            localNotification(void);

// KVO Notification
void            addNotification(id observer, SEL sel, NSString *name, id obj);
void            removeNotification(id observer, NSString *name, id obj);
void            postNotification(NSString *name);

// Utility
void            showAlertBox(NSString *title, NSString *message);
NSString*       currTime(void);
NSDate*         dateByDate(int year, int month, int day);
void            saveLog(NSString *log); // enable share in info.plist

void            throwException(NSString *ExceptionName, NSString *reason, id userInfo);
 
// Multable Arguments
void            multableArguments(int start, ...);

/* 
 // Multable Arguments for Objective C
 
 [self arrayWithObjs:@"AAA", @"BBB", @"CCC", nil];
 
 - (void)arrayWithObjs:(id)firstObj, ... NS_REQUIRES_NIL_TERMINATION
 {
    va_list argList;  
    id statement = firstObj;
    id arg = firstObj;  
    va_start(argList, firstObj); 
 
    if(statement)  
    {   
        do {
            NSLog(@"obj = %@", arg);            
        } while ((arg = va_arg(argList, id))); // 取下一个
        va_end(argList); // argList = nil;  
    }   
 }
 */

// blocks
typedef double(^block_operation)(double count);
// (void (^)(id key, id obj, BOOL *stop))block;
// ...params:^(id key, id obj, BOOL *stop) {}];

// Grand Central Dispatch
/*
 dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
 dispatch_async(downloadQueue, ^{
 NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://images.weiphone.com/attachments/Day_091007/7_273287_8a05fce1c455e0c.jpg"]];
 dispatch_async(dispatch_get_main_queue(), ^{
 UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
 [self.view addSubview:imgv];
 [imgv release];
 });
 });
 dispatch_release(downloadQueue); 
 =======
 
 */

