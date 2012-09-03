//
//  VPConnection.h
//  Quake
//
//  Created by Chen Weigang on 12-5-10.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPRequestDelegate;

enum {
    kVPRequestStateReady = 0,
    kVPRequestStateLoading,
    kVPRequestStateComplete,
    kVPRequestStateError,    
};
typedef NSUInteger VPRequestState;

enum {
    kVPRequestFormatXML = 0,
    kVPRequestFormatJSON,
};
typedef NSUInteger VPRequestFormat;

NSString* encodeString(NSString *string);
NSDictionary* parseJsonString(NSString *string);

@interface VPRequest : NSObject <NSURLConnectionDelegate>{
    
    id<VPRequestDelegate>   _delegate;
    NSString*               _url;
    NSString*               _httpMethod;
    NSDictionary*           _params;
    NSURLConnection*        _connection;
    NSMutableData*          _responseData;
    long long               _responseTotalLength;
    VPRequestState          _state;
    NSError*                _error;
    BOOL                    _sessionDidExpire;
    VPRequestFormat         _format;
}

@property (nonatomic, assign) id<VPRequestDelegate> delegate;

@property (nonatomic,copy) NSString* url;
@property (nonatomic,copy) NSString* httpMethod;
@property (nonatomic,retain) NSDictionary* params;
@property (nonatomic,retain) NSURLConnection* connection;
@property (nonatomic,retain) NSMutableData* responseData;
@property (nonatomic,readonly) VPRequestState state;
@property (nonatomic, readonly) VPRequestFormat format;

@property(nonatomic,retain) NSError* error;

// 同步链接
// 返回 XML 方式
+ (NSData *)synchronousRequestWithURL:(NSString *)url; // 同步请求链接, 无参数, XML Get方式
+ (NSData *)synchronousRequestWithURL:(NSString *)url  // 同步请求链接, 有参数, 自动encode参数, XML Post方式
                               andParams:(NSDictionary *)params;

// 返回 JSON 方式
+ (NSData *)synchronousJsonRequestWithURL:(NSString *)url  // 同步请求链接, 有参数, 自动encode参数, JSON Post方式
                                andParams:(NSDictionary *)params;


// 异步链接
// 返回 XML 方式
+ (VPRequest *)requestRequestWithURL:(NSString *)url
                         andDelegate:(id<VPRequestDelegate>)delegate;
+ (VPRequest *)requestRequestWithURL:(NSString *)url
                           andParams:(NSDictionary *)params
                         andDelegate:(id<VPRequestDelegate>)delegate;
// 返回 JSON 方式
+ (VPRequest *)requestJsonRequestWithURL:(NSString *)url
                               andParams:(NSDictionary *)params
                             andDelegate:(id<VPRequestDelegate>)delegate;


- (id)initWithURL:(NSString *)url
        andParams:(NSDictionary *)params
      andDelegate:(id<VPRequestDelegate>)delegate
        andFormat:(VPRequestFormat)format;

- (void)connect;
- (void)cancelAndClearDelegate; // recommand to use this
- (void)cancel;

- (BOOL)isLoading;


@end


@protocol VPRequestDelegate <NSObject>

@required
- (void)VPRequest:(VPRequest *)request didFinishWithResult:(NSData *)result;
- (void)VPRequest:(VPRequest *)request didFailWithError:(NSError *)error;

@optional
- (void)VPRequest:(VPRequest *)request didProgress:(NSUInteger)percent;

@end