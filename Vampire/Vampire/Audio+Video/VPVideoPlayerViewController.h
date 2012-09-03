//
//  NNMoviePlayerViewController.h
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#ifdef VAMPIRE_MEDIAPLAYER

#import <MediaPlayer/MediaPlayer.h>

@interface VPVideoPlayerViewController : UIViewController 
{
	MPMoviePlayerController     *mpVC;
	NSURL                       *movieURL;	
	UIActivityIndicatorView     *activityIndicatorView;
    CGSize                      screenSize;
}

- (id)initWithURL:(NSURL *)url screenSize:(CGSize)size;
- (void)readyPlayer;

@end


#endif





