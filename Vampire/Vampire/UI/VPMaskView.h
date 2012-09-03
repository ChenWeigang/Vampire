//
//  UISynchronizeMaskView.h
//  MM_BVD
//
//  Created by Chen Weigang on 12-4-1.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// VPMaskView
void showMaskView(UIView *parentView);
void dismissMaskView(void);


@interface VPMaskView : UIView {
    UIView *viewBg;
    UIActivityIndicatorView *actView;
    
    UIImageView *imgLoading;
}

@end
