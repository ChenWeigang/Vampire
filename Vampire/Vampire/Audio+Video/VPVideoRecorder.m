//
//  NEVideoRecordController.m
//  MM_BVD
//
//  Created by Chen Weigang on 12-3-31.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//



#import "VPVideoRecorder.h"


bool isVideoRecordingAvailable(void);

bool isVideoRecordingAvailable(void) {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return NO;
    }
    
    if (! [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear] && ! [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] ) {
        return NO;
    }
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    NSLog(@"mediaTypes = %@", mediaTypes);
    NSLog(@"kUTTypeVideo = %@", (NSString *)kUTTypeMovie);
    return [mediaTypes containsObject:(NSString *)kUTTypeMovie];
}

@implementation VPVideoRecorder
@synthesize delegate;


- (UIImagePickerController *)videoRecorderController
{
    bool isVideoRecordAvailable = isVideoRecordingAvailable();    
    
    if (isVideoRecordAvailable) {        
        [videoRecorderController release];         
        videoRecorderController = [[UIImagePickerController alloc] init];
        
        videoRecorderController.delegate = self;
        videoRecorderController.sourceType = UIImagePickerControllerSourceTypeCamera;   
        
        double iosVersion = [[UIDevice currentDevice].systemVersion doubleValue];
        NSLog(@"version = %f", iosVersion);
        
        if (iosVersion>=3.1) {
            videoRecorderController.videoMaximumDuration = 60;  
            videoRecorderController.videoQuality = UIImagePickerControllerQualityTypeLow;
        }
        
        if(iosVersion>=4.0){
            videoRecorderController.videoQuality = UIImagePickerControllerQualityTypeLow;
            videoRecorderController.mediaTypes =  [NSArray arrayWithObject:(NSString *)kUTTypeMovie];
            //            pickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo; // seem does not work
        }
        
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]) {                
            videoRecorderController.cameraDevice = UIImagePickerControllerCameraDeviceFront;  
            videoRecorderController.cameraViewTransform = CGAffineTransformMakeScale(-1, 1);// front camera mirror                
        }
        else if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear]){    
            videoRecorderController.cameraDevice = UIImagePickerControllerCameraDeviceRear;  
            videoRecorderController.cameraViewTransform = CGAffineTransformMakeScale(1, 1);  
        }
        
        return videoRecorderController;
    }
    else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""                              
                                                            message:@"Video Recording not available!" 
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
    
    return nil;
}

# pragma mark - UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {    
    NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [delegate videoRecorderDidFinish:mediaURL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [delegate videoRecorderDidCancel];
}

- (void)dealloc
{
    [videoRecorderController release];
    [super dealloc];
}

@end

