//
//  NEAsynImageView.m
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 11-10-13.
//  Copyright 2011年 Fugu Mobile Limited. All rights reserved.
//

#import "VPAsynImageView.h"

@implementation VPAsynImageView
@synthesize delegate;
@synthesize url;

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)aUrl 
{
    self = [super initWithFrame:frame];
    if (self) {
        url = [aUrl retain];
    }
    
    return self;
}

- (void)dealloc {    
    [url release];
    [connection cancel];
    [connection release];
    [data release];
    [super dealloc];
}


- (void)cancel{
    delegate = nil;
    [connection cancel];
    [connection release], connection = nil;
    [data release], data = nil;    
}

- (void)start {        
    if (state==AsynImageViewStateInit || state==AsynImageViewStateFinish) {
        state = AsynImageViewStateLoading;
        
        [self cancel];
        
        if ([[self subviews] count]>0) {
            [[[self subviews] objectAtIndex:0] removeFromSuperview];
        }
        
        UIActivityIndicatorView *actView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        [self addSubview:actView];
        [actView startAnimating];
        actView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        
        NSURLRequest* request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:60.0];
        connection = [[NSURLConnection alloc]
                      initWithRequest:request delegate:self];    
    }    
}

- (UIImage*)getImage {
    NSArray *subviews = [self subviews];
    if (subviews!=nil && [subviews count]>0 && [[subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]) {
        UIImageView* iv = [subviews objectAtIndex:0];
        return [iv image];
    }
    
    return nil;
}


- (void)setImage:(UIImage *)image
{
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageWithData:data]] autorelease];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.autoresizingMask = ( UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight );    
    [self addSubview:imageView];
    
    [imageView setNeedsLayout];
    [self setNeedsLayout];    
}


- (void)connection:(NSURLConnection *)theConnection
    didReceiveData:(NSData *)incrementalData {
    if (data==nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
    [data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
    
    [self setImage:[UIImage imageWithData:data]];  
    [connection cancel];
    state = AsynImageViewStateFinish;
    
    if (delegate!=nil && [delegate respondsToSelector:@selector(asynImageDidLoad:)]) {
        [delegate asynImageDidLoad:self];
    }
}

- (void)connection:(NSURLConnection *)conn didFailWithError:(NSError *)error
{
    if ([[self subviews] count]>0) {
        [[[self subviews] objectAtIndex:0] removeFromSuperview];
    }
    [connection cancel];
    state = AsynImageViewStateFinish;

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



@end
