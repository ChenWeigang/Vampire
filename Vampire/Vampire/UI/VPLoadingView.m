//
//  NNLoadingView.m
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 11-10-17.
//  Copyright 2011年 Fugu Mobile Limited. All rights reserved.
//

#import "VPLoadingView.h"

VPLoadingView *instanceLoadingView = nil;

@implementation VPLoadingView

+ (VPLoadingView *)sharedLoadingViewWithFrame:(CGRect)frame
{
    @synchronized(self){
        if (instanceLoadingView==nil) {                
            instanceLoadingView = [[VPLoadingView alloc] initWithFrame:frame];// assignment not done here
        }
    }
    
    return instanceLoadingView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        viewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        viewBg.backgroundColor = [UIColor blackColor];
        viewBg.layer.cornerRadius = 10.f;
        [self addSubview:viewBg];
        
        
        actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:actView];
        actView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [actView startAnimating];
    }
    return self;
}

- (void)startAnimation
{
    [actView startAnimating];
    self.alpha = 0.f;
    viewBg.alpha = 0.f;
    
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 1.f;
        viewBg.alpha = 0.6f;
    } completion:^(BOOL finished) {
        ;
    }];
}

- (void)stopAnimation
{
    [actView stopAnimating];
    self.alpha = 1.f;
    viewBg.alpha = 0.6f;
    
    [UIView animateWithDuration:0.33 animations:^{
        self.alpha = 0.f;
        viewBg.alpha = 0.f;
    } completion:^(BOOL finished) {
        [instanceLoadingView removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    [viewBg release], viewBg = nil;
    [actView release], actView = nil;
    [super dealloc];
}

@end

void showLoadingView(UIView *parentView)
{
    instanceLoadingView = [VPLoadingView sharedLoadingViewWithFrame:CGRectMake(0, 0, 64, 64)];
    instanceLoadingView.center = parentView.center;
    [parentView addSubview:instanceLoadingView];
    [instanceLoadingView startAnimation];
}

void dismissLoadingView(void)
{
    [instanceLoadingView stopAnimation];
}
