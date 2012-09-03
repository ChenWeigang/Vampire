//
//  KeyboardAccessoryView.h
//  KeyboardToolbar
//
//  Created by Chen Weigang on 12-6-28.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol VPKeyboardAccessoryViewDelegate;



/*
    How to use
 
 //ViewController.h
 VPKeyboardAccessoryView *kbView;
 
 //ViewController.n
 - (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
 {
    if (textField.inputAccessoryView == nil) {
        if (kbView==nil) {
            NSArray *arr = [NSArray arrayWithObjects:tfName,tfLastName,tfEmail,tfCountryCode,tfMobile, nil];
            kbView = [[VPKeyboardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) textFields:arr delegate:self];
        }
        textField.inputAccessoryView = kbView;    
    }
    [kbView setCurrentTextField:textField];
 }
 
 // delegate if need
 - (void)keyboardAccessoryDidPressed:(UITextField *)textField
 {
 }
 
 - (void)keyboardAccessoryDidFinish
 {
    // dismiss animation if need
 }
 */


@interface VPKeyboardAccessoryView : UIView {
    
    UIToolbar *toolbar;
    UISegmentedControl *segControl;
    UIBarButtonItem *btnCustom;
    UIBarButtonItem *btnSpace;    
    UIBarButtonItem *btnDone;
    
    NSArray *textFields;
    int indexCurrentTextField; // -1 = nil
    
    id<VPKeyboardAccessoryViewDelegate> delegate;
}


- (id)initWithFrame:(CGRect)frame 
         textFields:(NSArray *)textFields
           delegate:(id)delegate;

- (void)setCurrentTextField:(UITextField *)textField;

@end


@protocol VPKeyboardAccessoryViewDelegate <NSObject>

@optional
- (void)keyboardAccessoryDidPressed:(UITextField *)textField;
- (void)keyboardAccessoryDidFinish;


@end