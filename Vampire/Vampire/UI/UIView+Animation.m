//
//  NEViewAnimation.m
//  TK189
//
//  Created by Chen Weigang on 12-2-2.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "UIView+Animation.h"

@implementation UIView(Animation)


- (void)animationElasticPopup
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    self.transform = CGAffineTransformMakeScale(0.001f, 0.001f);
    
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationDelay:0];
        self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);//1.1
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{            
            self.transform = CGAffineTransformMakeScale(0.9f, 0.9f);//0.9
        } completion:^(BOOL finished) {            
            [UIView animateWithDuration:0.1 animations:^{                
                self.transform = CGAffineTransformMakeScale(1.f, 1.f);//1.0
            } completion:^(BOOL finished) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }];            
        }];
    }];  
}

- (void)animationElasticOpenVerticle
{
    self.transform = CGAffineTransformMakeScale(1.0f, 0.001f);
    
    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationDelay:0];
        self.transform = CGAffineTransformMakeScale(1.0f, 1.1f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{            
            self.transform = CGAffineTransformMakeScale(1.0f, 0.9f);
        } completion:^(BOOL finished) {            
            [UIView animateWithDuration:0.1 animations:^{                
                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
            }];            
        }];
    }];  
}

- (void)animationElasticOpenHorizontal
{
    self.transform = CGAffineTransformMakeScale(0.001f, 1.0f);
    
    [UIView animateWithDuration:0.4 animations:^{
        [UIView setAnimationDelay:0];
        self.transform = CGAffineTransformMakeScale(1.1f, 1.0f);
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{            
            self.transform = CGAffineTransformMakeScale(0.9f, 1.0f);
        } completion:^(BOOL finished) {            
            [UIView animateWithDuration:0.1 animations:^{                
                self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            } completion:^(BOOL finished) {
                ;
            }];            
        }];
    }];  
}

- (void)animationFadeIn
{
    self.alpha = 1.f;
    [UIView animateWithDuration:1.f animations:^{             
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        ;
    }]; 
}

- (void)animationFadeOut
{
    self.alpha = 0.f;
    [UIView animateWithDuration:1.f animations:^{                
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
        ;
    }]; 
}


@end
