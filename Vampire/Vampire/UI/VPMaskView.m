//
//  UISynchronizeMaskView.m
//  MM_BVD
//
//  Created by Chen Weigang on 12-4-1.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPMaskView.h"

static VPMaskView *instanceMaskView;


@interface VPMaskView()
+ (VPMaskView *)sharedMaskViewWithFrame:(CGRect)frame;
- (void)startAnimation;
- (void)stopAnimation;
@end


void showMaskView(UIView *parentView)
{
    [VPMaskView sharedMaskViewWithFrame:CGRectMake(0, 0, parentView.frame.size.width, parentView.frame.size.height)];
    [parentView addSubview:instanceMaskView];
    [instanceMaskView startAnimation];
}

void dismissMaskView(void)
{
    [instanceMaskView stopAnimation];
    [instanceMaskView removeFromSuperview];
}


@implementation VPMaskView

+ (VPMaskView *)sharedMaskViewWithFrame:(CGRect)frame
{
    @synchronized(self){
        if (instanceMaskView==nil) {                
            instanceMaskView = [[VPMaskView alloc] initWithFrame:frame];// assignment not done here
        }
    }
    
    return instanceMaskView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code    
        
        viewBg = [[UIView alloc] initWithFrame:frame];
        viewBg.backgroundColor = [UIColor blackColor];
        viewBg.alpha = 0.6f;
        [self addSubview:viewBg];
        
//        actView = [[UIActivityIndicatorView alloc] init];
//        actView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
//        actView.frame = CGRectMake(frame.size.width/2-18, frame.size.height/2-18, 36, 36);
//        actView.backgroundColor = [UIColor clearColor];
//        
//        [self addSubview:actView];
//        [actView startAnimating];
        
        imgLoading = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2-18, frame.size.height/2-18, 36, 36)];
        imgLoading.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loading1.png"], [UIImage imageNamed:@"loading2.png"],[UIImage imageNamed:@"loading3.png"],[UIImage imageNamed:@"loading4.png"],[UIImage imageNamed:@"loading5.png"],[UIImage imageNamed:@"loading6.png"],nil];
        [self addSubview:imgLoading];
        imgLoading.animationDuration = 0.5f;
        [imgLoading startAnimating];
        
    }
    return self;
}

- (void)startAnimation
{
    [actView startAnimating];
}

- (void)stopAnimation
{
    [actView stopAnimating];
}

-(void)dealloc 
{
    [imgLoading release];
    [viewBg release];
    [actView release];
    
    [super dealloc];
}


@end
