//
//  KeyboardAccessoryView.m
//  KeyboardToolbar
//
//  Created by Chen Weigang on 12-6-28.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "VPKeyboardAccessoryView.h"

@implementation VPKeyboardAccessoryView

- (id)initWithFrame:(CGRect)frame 
         textFields:(NSArray *)tfs
           delegate:(id)d
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 40)];
    
    if (self) {
        assert(tfs!=nil && [tfs count]>0);
        textFields = [tfs retain];
        delegate = d;
        indexCurrentTextField = 0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;        
        
        toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)]; 
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;       
        toolbar.barStyle = UIBarStyleBlack;
        toolbar.translucent = YES;
        [self addSubview:toolbar];  
        
        segControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Previous", @"Next", nil]];
        segControl.segmentedControlStyle = UISegmentedControlStyleBar;
        segControl.momentary = YES;
        [segControl addTarget:self action:@selector(pressSegmentControl) forControlEvents:UIControlEventValueChanged];
        [self updateSegmentControl:indexCurrentTextField];
                
        btnCustom = [[UIBarButtonItem alloc] initWithCustomView:segControl];
        btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];        
        btnDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pressDone)]; 
        
        [toolbar setItems:[NSArray arrayWithObjects:btnCustom, btnSpace, btnDone, nil]];
    }
    return self;
}


- (void)setCurrentTextField:(UITextField *)tf
{
    indexCurrentTextField = [textFields indexOfObject:tf];
    [self updateSegmentControl:indexCurrentTextField];    
}

- (void)updateSegmentControl:(int)currentTextFieldIndex;
{
#define SegmentPrevious 0
#define SegmentNext     1
        
    if ([textFields count]<=1) {
        [segControl setEnabled:NO forSegmentAtIndex:SegmentPrevious];
        [segControl setEnabled:NO forSegmentAtIndex:SegmentNext];
        segControl.selectedSegmentIndex = -1;
    }
    else {
        [segControl setEnabled:currentTextFieldIndex>0 forSegmentAtIndex:SegmentPrevious];
        [segControl setEnabled:currentTextFieldIndex<[textFields count]-1 forSegmentAtIndex:SegmentNext];
    }
}

- (void)pressSegmentControl
{
    if (segControl.selectedSegmentIndex==0) {
        indexCurrentTextField -= 1;
    }
    else {
        indexCurrentTextField += 1;
    }    
    [self updateSegmentControl:indexCurrentTextField]; 
    
    
    UITextField *currTextField;    
    if (indexCurrentTextField>=0 && indexCurrentTextField<[textFields count]) {  
        currTextField = [textFields objectAtIndex:indexCurrentTextField];
    }
    [currTextField becomeFirstResponder];
    
    if (delegate!=nil && [delegate respondsToSelector:@selector(keyboardAccessoryDidPressed:)]) {
        if (indexCurrentTextField>=0 && indexCurrentTextField<[textFields count]) {   
            [delegate keyboardAccessoryDidPressed:currTextField];
        }
        else {
            NSLog(@"pressSegmentControl index for textField error!");
        }
    }
}

- (void)pressDone
{   
    indexCurrentTextField = -1;
    
    for (UITextField *tf in textFields) {
        [tf resignFirstResponder];
    }
    
    if (delegate!=nil && [delegate respondsToSelector:@selector(keyboardAccessoryDidFinish)]) {
        [delegate keyboardAccessoryDidFinish];
    }
}



- (void)dealloc
{
    delegate = nil;
    [textFields release];
    [segControl release];
    [btnCustom release];
    [btnSpace release];
    [btnDone release];
    [toolbar release];
    
    [super dealloc];
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
