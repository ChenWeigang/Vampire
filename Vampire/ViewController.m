//
//  ViewController.m
//  Vampire
//
//  Created by Chen Weigang on 12-9-3.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://images.weiphone.com/attachments/Day_091007/7_273287_8a05fce1c455e0c.jpg"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
            [self.view addSubview:imgv];
            [imgv release];
        });
    });
    dispatch_release(downloadQueue);
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
