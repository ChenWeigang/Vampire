//
//  NEVideoRecorderController.h
//  MM_BVD
//
//  Created by Chen Weigang on 12-3-31.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//



#import <MobileCoreServices/MobileCoreServices.h>

@protocol VPVideoRecorderDelegate;

// Simple to use video recorder, no need config
// Don't forget to implment delegate method
@interface VPVideoRecorder : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    UIImagePickerController *videoRecorderController;
}

@property (nonatomic, retain) id<VPVideoRecorderDelegate> delegate;


- (UIImagePickerController *)videoRecorderController;

@end


@protocol VPVideoRecorderDelegate <NSObject>
@required
- (void)videoRecorderDidCancel;
- (void)videoRecorderDidFinish:(NSURL *)urlVideo;

@end
