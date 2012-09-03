//
//  NNLoadingView.h
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 11-10-17.
//  Copyright 2011年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


void showLoadingView(UIView *parentView);
void dismissLoadingView(void);

@interface VPLoadingView : UIView {
    UIActivityIndicatorView *actView;
    UIView *viewBg;
}

- (void)startAnimation;
- (void)stopAnimation;

@end


