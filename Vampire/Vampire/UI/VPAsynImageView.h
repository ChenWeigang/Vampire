//
//  NEAsynImageView.h
//  AsiaBriefing_iPhone
//
//  Created by Chen Weigang on 11-10-13.
//  Copyright 2011年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    AsynImageViewStateInit = 0,
    AsynImageViewStateLoading,
    AsynImageViewStateFinish,
}AsynImageViewState;

@interface VPAsynImageView : UIView {
    NSURLConnection* connection;
    AsynImageViewState state;
    NSMutableData* data;
    NSURL *url;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) NSURL *url;

- (id)initWithFrame:(CGRect)frame URL:(NSURL *)url;
- (void)start;  // 開始鏈接 只能鏈接一次
- (void)cancel;

- (UIImage *)getImage;
- (void)setImage:(UIImage *)image; // if is loading, it will not cancel the connection. So may replace 


@end


@protocol NEAsynImageViewDidLoad
- (void)asynImageDidLoad:(VPAsynImageView *)aImg;
@end

