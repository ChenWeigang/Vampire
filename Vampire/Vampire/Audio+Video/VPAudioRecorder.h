//
//  NEAudioRecorder.h
//  MM_BVD
//
//  Created by Chen Weigang on 12-3-31.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

//#ifdef VAMPIRE_AUDIOTOOLBOX

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum {
    AudioRecorderReady = 0,
    AudioRecorderRecording = 1,
}AudioRecorderState;

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define RECORD_TIME 180

@protocol NEAudioRecorderDelegate;

@interface VPAudioRecorder : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    AVAudioPlayer *avPlayer;    
	AVAudioRecorder *recorder;
}

@property (nonatomic, assign) id<NEAudioRecorderDelegate> delegate;
@property (nonatomic, assign, readonly) AudioRecorderState state;


+ (BOOL)isAudioRecorderAvailible;
+ (VPAudioRecorder *)sharedInstance;
+ (void)releaseSharedInstance;

- (BOOL)isRecording;
- (void)startRecording;
- (void)stopRecording;

- (void)deleteLastRecord;
- (void)playLastRecord;
- (void)stopPlayingLastRecord;

+ (NSString *)recordFilePath;

@end


@protocol NEAudioRecorderDelegate <NSObject>
@required
- (void)audioRecordDidStart;
- (void)audioRecordDidFinishSuccessful:(BOOL)flag;

- (void)playLastAudioDidFinish;

@end

const NSString *audioRecordFilename;


//#endif
