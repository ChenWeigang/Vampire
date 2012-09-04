//
//  VPUtil.m
//  ThirdParty
//
//  Created by Chen Weigang on 12-3-12.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPUtil.h"



#pragma mark -
#pragma mark File Managerment

NSString* filePathAtDocument(NSString *filename)
{
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDirectory = [pathArray objectAtIndex:0];
	NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
	return filePath;
}

NSString* filePathAtMainBundle(NSString *filename)
{
    NSArray *components = [filename componentsSeparatedByString:@"."];    
    assert([components count]==2);
    NSString *prefix = [components objectAtIndex:0];
    NSString *suffix = [components objectAtIndex:1];
    
	return [[NSBundle mainBundle] pathForResource:prefix ofType:suffix];
}

NSURL* fileURL(NSString *path)
{    
    return [[[NSURL alloc] initFileURLWithPath:path] autorelease];
}

bool isFileExistAtPath(NSString *filePath)
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    const bool isExist = [fileManager fileExistsAtPath:filePath];
    
    if (!isExist){
        NSLog(@"%@ not exist!", filePath);
    }
    
    return isExist;
}


# pragma mark -
# pragma mark Read and write plist file

NSArray* arrayFromMainBundle(NSString *filename)
{    
    NSArray *arrayForReturn = nil;
    NSString *path = filePathAtMainBundle(filename);
    
    if (isFileExistAtPath(path)){
        arrayForReturn = [NSArray arrayWithContentsOfFile:path];
    }    
    return arrayForReturn;
}

NSDictionary* dictionaryFromMainBundle(NSString *filename)
{
    NSDictionary *dictionaryForReturn = nil;
    NSString *path = filePathAtMainBundle(filename);
    
    if (isFileExistAtPath(path)){
        dictionaryForReturn = [NSDictionary dictionaryWithContentsOfFile:path];
    }    
    return dictionaryForReturn;
}

NSArray* loadArrayFromDocument(NSString *filename)
{
    NSString *path = filePathAtDocument(filename);
    return [NSArray arrayWithContentsOfFile:path];
}

NSDictionary* loadDictionaryFromDocument(NSString *filename)
{
    NSString *path = filePathAtDocument(filename);
    return [NSDictionary dictionaryWithContentsOfFile:path];
}

BOOL saveArrayToDocument(NSString *filename, NSArray *array)
{
    NSString *path = filePathAtDocument(filename);
    return [array writeToFile:path atomically:YES];
}

BOOL saveDictionaryToDocument(NSString *filename, NSDictionary *dictionary)
{
    NSString *path = filePathAtDocument(filename);
    return [dictionary writeToFile:path atomically:YES];
}


#pragma mark -
#pragma mark Encoding

NSString* encodeURL(NSString *string)
{
    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                  (CFStringRef)string,
                                                                                  NULL, 
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
    NSString *stringForReturn = [[escaped_value copy] autorelease];
    CFRelease(escaped_value);
    
    return stringForReturn;
}

NSString* stringUsingEncodingUTF8(NSData *data)
{
	return [[[NSString alloc] initWithData:data	encoding:NSUTF8StringEncoding] autorelease];
}

NSString* stringUsingEncoding(NSData *data, NSStringEncoding encoding)
{
	return [[[NSString alloc] initWithData:data	encoding:encoding] autorelease];    
}

NSData* dataUsingEncodingUTF8(NSString *string)
{
	return dataUsingEncoding(string, NSUTF8StringEncoding);
}

NSData* dataUsingEncoding(NSString *string, NSStringEncoding encoding)
{    
	return [string dataUsingEncoding:encoding];
}

NSString* base64forData(NSData *theData) {
    
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding] autorelease];
}


#pragma mark - Device

void deviceInfo(void)
{         
    NSLog(@"Device Name: %@", [UIDevice currentDevice].name);
    NSLog(@"Device Model: %@", [UIDevice currentDevice].model);
    NSLog(@"System Name: %@", [UIDevice currentDevice].systemName);
    NSLog(@"System Version: %@", [UIDevice currentDevice].systemVersion);    
    NSLog(@"Retina Display: %@", isRetinaDisplay()?@"YES":@"NO");
}

bool isIPad(void)
{
    return [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
}

double systemVersion(void)
{
    return [[[UIDevice currentDevice] systemVersion] doubleValue];
}

NSString* deviceName(void)
{
    return [UIDevice currentDevice].name;
}

NSString* deviceModel(void)
{
    return [UIDevice currentDevice].model;
}

NSString* deviceSystemName(void)
{
    return [UIDevice currentDevice].systemName;
}

NSString* deviceSystemVersion(void)
{
    return [UIDevice currentDevice].systemVersion;
}

bool isRetinaDisplay(void)
{    
    return ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.00);
}






# pragma mark -
# pragma Regular Expression

bool isEmailFormat(NSString *email)
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,16}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

bool isCountryCodeFormat(NSString *countryCode)
{
    NSString *mobileRegex = @"[0-9]{1,5}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [emailTest evaluateWithObject:countryCode];
}

bool isMobileFormat(NSString *mobile)
{
    NSString *mobileRegex = @"[0-9() +-]{1,30}"; 
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileRegex];
    return [emailTest evaluateWithObject:mobile];
}

bool isFirstLetterNumber(NSString *number)
{
    NSString *firstNumber = @"[0-9]{0,1}"; 
    NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", firstNumber];
    return [numberTest evaluateWithObject:firstNumber];
}

bool isAccountFormat(NSString *account)
{
    NSString *accountRegex = @"[A-Z0-9a-z_]{3,30}"; 
    NSPredicate *accountTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", accountRegex];
    return [accountTest evaluateWithObject:account];
}

bool isPasswordFormat(NSString *password)
{    
    NSString *formatRegex = @"[A-Z0-9a-z]{6,20}"; 
    NSPredicate *formatTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", formatRegex];
    return [formatTest evaluateWithObject:password];
}




# pragma mark - Open URL

void openURL(NSURL *url) 
{
    [[UIApplication sharedApplication] openURL:url];    
}

void openRateURL(NSString *appId)
{
    NSString* url = [NSString stringWithFormat:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=%@&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8", appId];    
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:url]];
}

void openPhoneCallURL(NSString *tel)
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
    [[UIApplication sharedApplication] openURL:url];
}

# pragma mark -
# pragma mark Serialize NSCoder

bool archive(id object, NSString *path)
{
    NSData *data;
    data = [NSKeyedArchiver archivedDataWithRootObject:object];
    return [data writeToFile:path atomically:YES];
}

id unarchiveObjectFromPath(NSString *path)
{    
    NSData *data=[NSData dataWithContentsOfFile:path];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

# pragma mark -
# pragma mark Local Notification

void localNotification(void)
{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;//应用程序右上角的数字=0（消失）  
    [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知  
    //------通知；  
    
    UILocalNotification *notification=[[[UILocalNotification alloc] init] autorelease];   
    if (notification!=nil) {//判断系统是否支持本地通知  
        notification.fireDate=[NSDate dateWithTimeIntervalSinceNow:kCFCalendarUnitDay];//本次开启立即执行的周期  
        notification.repeatInterval=kCFCalendarUnitDay;//循环通知的周期  
        notification.timeZone=[NSTimeZone defaultTimeZone];  
        notification.alertBody=@"Pop up message!";//弹出的提示信息  
        notification.applicationIconBadgeNumber=1; //应用程序的右上角小数字  
        notification.soundName= UILocalNotificationDefaultSoundName;//本地化通知的声音  
        notification.alertAction = NSLocalizedString(@"距離對嗎？？！", nil);  //弹出的提示框按钮  
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];  
    }  
}

# pragma mark -
# pragma mark KVO Notification

void addNotification(id observer, SEL sel, NSString *name, id obj)
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:sel
                                                 name:name 
                                               object:obj];
}

void removeNotification(id observer, NSString *name, id obj)
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer 
                                                    name:name 
                                                  object:obj];
}

void postNotification(NSString *name)
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

# pragma mark -
# pragma mark Utility

void showAlertBox(NSString *title, NSString *message)
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title                              
                                                        message:message 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

NSString* currTime(void)
{
    NSDate *now = [NSDate date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents *dd = [cal components:unitFlags fromDate:now]; 
    int y = [dd year];
    int m = [dd month];
    int d = [dd day];
    //    int week = [dd weekday];
    
    int hour = [dd hour];
    int minute = [dd minute];
    int second = [dd second];
    
    return [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", y, m, d, hour, minute, second];
}

NSDate* dateByDate(int year, int month, int day)
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[[NSDateComponents alloc] init] autorelease];
    [components setDay:day];
    [components setMonth:month];
    [components setYear:year];
    return [calendar dateFromComponents:components];
}

void saveLog(NSString *log)
{
    if (log==nil) {
        return;
    }
    
#define FILE_LOGGER @"logger.txt"
    
    NSString *filePath = filePathAtDocument(FILE_LOGGER);
    NSMutableArray *arrNew;
    
    if (isFileExistAtPath(filePath)) {
        NSArray *arrLogs = [NSArray arrayWithContentsOfFile:filePath];
        arrNew = [NSMutableArray arrayWithArray:arrLogs];
    }
    else {
        arrNew = [NSMutableArray arrayWithCapacity:2];
    }
    
    [arrNew addObject:log];
    NSLog(@"add logger = %@", log);
    
    BOOL successful = saveArrayToDocument(FILE_LOGGER, arrNew);
    //    NSLog(@"%@", [NSString stringWithFormat:@"Save file %@ %@", filePath, successful?@"successful":@"failed"]);
    if (!successful) {
        NSLog(@"save logger failed!");
    }
}

