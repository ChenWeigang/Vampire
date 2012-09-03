//
//  NEAudioRecorder.m
//  MM_BVD
//
//  Created by Chen Weigang on 12-3-31.
//  Copyright (c) 2012年 Fugu Mobile Limited. All rights reserved.
//

//#ifdef VAMPIRE_AUDIOTOOLBOX


#import "VPAudioRecorder.h"

const NSString *audioRecordFilename = @"MyRecord.caf";
VPAudioRecorder *instance;

@implementation VPAudioRecorder
@synthesize delegate;
@synthesize state;

- (void)dealloc
{
    [avPlayer stop];
    [avPlayer release];
    
    [recorder stop];
    [recorder release];
    
    [super dealloc];
}

+ (NSString *)recordFilePath
{
    return [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, audioRecordFilename];
}

+ (VPAudioRecorder *)sharedInstance
{
    @synchronized(self){
        if (instance==nil) {
            instance = [[VPAudioRecorder alloc] init]; 
                 
        }
    }    
    return instance;
}

+ (void)releaseSharedInstance
{
    [instance release], instance = nil;
}

// 播放声音
- (void)playSound:(NSString *)filePath
{   
    [avPlayer stop];
    [avPlayer release];
    avPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:nil];
    avPlayer.volume = 0.95f;
    if ([avPlayer prepareToPlay]) { 
        [avPlayer play];   
    }
}

// 开始录音
- (void)startRecording
{	
    if (state==AudioRecorderReady) {        
        state = AudioRecorderRecording;        
        NSLog(@"RECORDING...");
        
        [self playSound:@"/System/Library/Audio/UISounds/begin_record.caf"];
        [self performSelector:@selector(performRecording) withObject:nil afterDelay:1.f];
    }    
}

// 停止录音
- (void)stopRecording
{
    if (state==AudioRecorderRecording) {  
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *err = nil;
        
        [audioSession setCategory :AVAudioSessionCategoryPlayback error:&err];
        [self playSound:@"/System/Library/Audio/UISounds/end_record.caf"];
        state = AudioRecorderReady;     
        NSLog(@"STOP RECORDING...");
        [recorder stop];
        
    }
}

- (void)deleteLastRecord
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filePath = [VPAudioRecorder recordFilePath];
    
    NSLog(@"filePath = %@", filePath);
    if ([fm fileExistsAtPath:filePath]) {        
        NSError *err;
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        BOOL successful = [fm removeItemAtURL:fileURL error:&err];
        if (!successful) {
            NSLog(@"delete last record failed! error = %@", err.localizedDescription);
        }    
    }
    else {
        NSLog(@"record file not exist!");
    }
}

- (BOOL)isRecording
{
    return state==AudioRecorderRecording;
}

// 播放上一次的录音
- (void)playLastRecord
{       
    [self playSound:[NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, audioRecordFilename]];
    avPlayer.delegate = self;
    
    NSLog(@"REPLAY...");
}


- (void)stopPlayingLastRecord
{
    avPlayer.delegate = nil;
    [avPlayer stop];
    [avPlayer release], avPlayer = nil;
}

+ (BOOL)isAudioRecorderAvailible
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    
    return audioHWAvailable;
}

// 录音逻辑
- (void)performRecording
{    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    
    [audioSession setCategory :AVAudioSessionCategoryRecord error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
        return;
    }
    
    // 录音的一些设置
    NSMutableDictionary *recordSetting = [NSMutableDictionary dictionaryWithCapacity:10];
    
    // We can use kAudioFormatAppleIMA4 (4:1 compression) or kAudioFormatLinearPCM for nocompression
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    
    // We can use 44100, 32000, 24000, 16000 or 12000 depending on sound quality
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    
    // We can use 2(if using additional h/w) or 1 (iPhone only has one microphone)
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    
    // These settings are used if we are using kAudioFormatLinearPCM format
    //[recordSetting setValue :[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    //[recordSetting setValue :[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    
    
    // Create a new dated file    
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@", DOCUMENTS_FOLDER, audioRecordFilename];
        
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];    
    err = nil;
    
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    err = nil;
    
    [recorder release];
    recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err];
    if(!recorder){
        NSLog(@"recorder: %@ %d %@", [err domain], [err code], [[err userInfo] description]);
//        showAlertBox(@"Warning", [err localizedDescription]);
        return;
    }
    
    //prepare to record
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputIsAvailable;
    if (! audioHWAvailable) {
//        showAlertBox(@"Warning", @"Audio input hardware not available");
        
        [delegate audioRecordDidFinishSuccessful:NO];
        return;
    }
    
    // start recording
    [recorder recordForDuration:(NSTimeInterval) RECORD_TIME];
    [delegate audioRecordDidStart];    
}

// 录音结束
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *) aRecorder successfully:(BOOL)flag
{
	[delegate audioRecordDidFinishSuccessful:flag];
}

// 播放声音结束
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [delegate playLastAudioDidFinish];
}

@end


//#endif
