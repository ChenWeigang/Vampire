
//
//  VPConnection.m
//  Vampire
//
//  Created by Chen Weigang on 12-5-10.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPRequest.h"
//#import "JSON.h"

///////////////////////////////////////////////////////////////////////////////////////////////////
// global

static const NSTimeInterval kTimeoutInterval = 90.0;

///////////////////////////////////////////////////////////////////////////////////////////////////

NSString* encodeString(NSString *string)
{
    NSString* escaped_value = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, /* allocator */
                                                                                  (CFStringRef)string,
                                                                                  NULL, /* charactersToLeaveUnescaped */
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8);
    NSString *stringForReturn = [[escaped_value copy] autorelease];
    CFRelease(escaped_value);
    
    return stringForReturn;
}

//NSDictionary* parseJsonString(NSString *string)
//{
//    SBJsonParser *jsonParser = [[[SBJsonParser alloc] init] autorelease];  
//    NSDictionary *jsonDict = [jsonParser objectWithString:string]; 
//    
//    return jsonDict;
//}

@interface VPRequest()
+ (NSString *)serializeXMLParams:(NSDictionary *)params;
+ (NSString *)serializeJsonParams:(NSDictionary *)params;
@end

@implementation VPRequest

@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize httpMethod = _httpMethod;
@synthesize params = _params;
@synthesize connection = _connection;
@synthesize responseData = _responseData;
@synthesize state = _state;
@synthesize error = _error;
@synthesize format = _format;

# pragma mark - 同步请求


// 同步请求链接, 无参数, 默认XML Get方式
+ (NSData *)synchronousRequestWithURL:(NSString *)url
{
    return [VPRequest synchronousRequestWithURL:url andParams:nil];
} 


// 同步请求链接, 有参数, 自动encode参数, JSON Post方式
+ (NSData *)synchronousJsonRequestWithURL:(NSString *)url  
                                andParams:(NSDictionary *)params
{
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];	
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:kTimeoutInterval];
    if (params!=nil && [params count]>0) {        
        [request setHTTPMethod:@"POST"]; 
        NSString *postString = [self serializeJsonParams:params];
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    
    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}

// 同步请求链接, 有参数, 自动encode参数, XML Post方式
+ (NSData *)synchronousRequestWithURL:(NSString *)url  
                               andParams:(NSDictionary *)params
{
    NSMutableURLRequest *request;
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];	
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:kTimeoutInterval];
    if (params!=nil && [params count]>0) {        
        [request setHTTPMethod:@"POST"]; 
        NSString *postString = [self serializeXMLParams:params];
        NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:postData];
    }
    
    return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
}



- (VPRequest *)initWithURL:(NSString *)url
                      post:(NSString *)postString
                  delegateX:(id<VPRequestDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.url = url;
        self.delegate = delegate;
        NSLog(@"url = %@", url);
        NSLog(@"post data = %@", postString);
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setValue:@"text/xml;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setTimeoutInterval:kTimeoutInterval];
        if (postString!=nil) {        
            [request setHTTPMethod:@"PUT"]; 
            NSString *postString = @"";
            NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:postData];
        }
        else {
            NSString *postString = @"";
            NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:postData];
        }
        
        _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        _state = kVPRequestStateReady;
        
    }
        return self;
}

# pragma mark - 异步请求

- (VPRequest *)initWithURL:(NSString *)url
                 andParams:(NSDictionary *)params
               andDelegate:(id<VPRequestDelegate>)delegate
                 andFormat:(VPRequestFormat)format
{
    self = [super init];
    if (self) {
        self.url = url;
        self.params = params;
        self.delegate = delegate;
        _format = format;    
        NSLog(@"url = %@", url);
        NSLog(@"param = %@", params);
        
        if (format==kVPRequestFormatXML) { // XML format
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setTimeoutInterval:kTimeoutInterval];
            if (params!=nil && [params count]>0) {        
                [request setHTTPMethod:@"POST"]; 
                NSString *postString = [VPRequest serializeXMLParams:params];
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:postData];
            }
            else {
                NSString *postString = @"";
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:postData];
            }
            
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
            _state = kVPRequestStateReady;
        }
        else if (format==kVPRequestFormatJSON) { // JSON format
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
            [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            [request setTimeoutInterval:kTimeoutInterval];       
            [request setHTTPMethod:@"POST"]; 
            if (params!=nil && [params count]>0) { 
                NSString *postString = [VPRequest serializeJsonParams:params];
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:postData];
            }
            else {
                NSString *postString = @"";
                NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];
                [request setHTTPBody:postData]; 
            }
            
            _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
            _state = kVPRequestStateReady;
        }
    }
    
    return self;
}

+ (VPRequest *)requestRequestWithURL:(NSString *)url
                         andDelegate:(id<VPRequestDelegate>)delegate
{
    return [[[VPRequest alloc] initWithURL:url
                                andParams:nil
                              andDelegate:delegate
                                andFormat:kVPRequestFormatXML] autorelease];
}

+ (VPRequest *)requestRequestWithURL:(NSString *)url
                           andParams:(NSDictionary *)params
                         andDelegate:(id<VPRequestDelegate>)delegate
{
    return [[[VPRequest alloc] initWithURL:url
                                andParams:params
                              andDelegate:delegate
                                andFormat:kVPRequestFormatXML] autorelease];
}

+ (VPRequest *)requestJsonRequestWithURL:(NSString *)url
                               andParams:(NSDictionary *)params
                             andDelegate:(id<VPRequestDelegate>)delegate
{
    return [[[VPRequest alloc] initWithURL:url
                                andParams:params
                              andDelegate:delegate
                                andFormat:kVPRequestFormatJSON] autorelease];
}

- (void)connect
{
    [_connection start];
    _state = kVPRequestStateLoading;
}

- (void)cancel
{
    [_connection cancel];
    _state = kVPRequestStateComplete;
}

- (void)cancelAndClearDelegate
{
    _delegate = nil;
    [self cancel];
}

- (BOOL)isLoading
{
    return _state == kVPRequestStateLoading;
}

#pragma mark -
#pragma mark =================== NSURLConnection delegate ===================

// connection did finish
- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
	if (_delegate && [_delegate respondsToSelector:@selector(VPRequest:didFinishWithResult:)]) {		
		[_delegate VPRequest:self didFinishWithResult:_responseData];
	}
    _state = kVPRequestStateComplete;
    self.responseData = nil;
    self.connection = nil;
}


// connection did fail with error
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	if (_delegate && [_delegate respondsToSelector:@selector(VPRequest:didFailWithError:)]) {		
		[_delegate VPRequest:self didFailWithError:error];
	}
    _state = kVPRequestStateError;
    self.responseData = nil;
    self.connection = nil;
}

// connection did receive data
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{	
    [_responseData appendData:data];	
	int percent = [_responseData length]*100/_responseTotalLength;
	percent = percent<0?0:percent;
	percent = percent>100?100:percent;
	if (_delegate!=nil && [_delegate respondsToSelector:@selector(VPRequest:didProgress:)]) {
        [_delegate VPRequest:self didProgress:percent];
	}
}

// connection did receive response
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
    _responseData = [[NSMutableData alloc] init];
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    if(httpResponse && [httpResponse respondsToSelector:@selector(allHeaderFields)]){
        NSDictionary *httpResponseHeaderFields = [httpResponse allHeaderFields]; 
        _responseTotalLength = [[httpResponseHeaderFields objectForKey:@"Content-Length"] longLongValue];		
    }
}                           

                           
# pragma mark - 序列化 params encode

+ (NSString *)serializeXMLParams:(NSDictionary *)params
{
    NSString *fullParams = @"";
    int i = 0;
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        fullParams = [fullParams stringByAppendingFormat:@"%@%@=%@", i==0?@"":@"&", key, encodeString(value)];
        i++;
    }
    NSLog(@"xml params for post = %@", fullParams);
    return fullParams;
}

+ (NSString *)serializeJsonParams:(NSDictionary *)params
{
    /*
     @"{ \"Lang\": \"%@\", \"CountPerPage\":\"%d\", \"CurrentPage\": \"%d\", \"Category\":\"%@\", \"Area\":\"%@\"}"
     */
    NSString *jsonForPost = @"";
    
    int i = 0;
    for (NSString *key in params) {
        if (i==0) {            
            jsonForPost = [NSString stringWithFormat:@"%@{", jsonForPost];
        }
        
        id obj = [params objectForKey:key];
        
        if ([obj isKindOfClass:[NSString class]]) { 
            NSString *str = obj;
            jsonForPost = [jsonForPost stringByAppendingFormat:@"\"%@\":\"%@\"", key, encodeString(str)];
        }
        else {
            jsonForPost = [jsonForPost stringByAppendingFormat:@"\"%@\":\"%@\"", key, obj];
        }        
        
        if (i==[params count]-1) {            
            jsonForPost = [jsonForPost stringByAppendingFormat:@"}"];
        }
        else {
            jsonForPost = [jsonForPost stringByAppendingFormat:@","];
        }
        
        i++;
    }
    
    NSLog(@"json params for post = %@", jsonForPost);
    return jsonForPost;
}



- (void)dealloc
{
    [_url release];
    [_httpMethod release];
    [_params release];
    [_connection cancel];
    [_connection release];
    [_responseData release];
    
    [super dealloc];
}

@end
