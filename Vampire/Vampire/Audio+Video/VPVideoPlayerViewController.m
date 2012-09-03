//
//  NNMoviePlayerViewController.m
//
//  Copyright iOSDeveloperTips.com All rights reserved.
//

#ifdef VAMPIRE_MEDIAPLAYER

#import "VPVideoPlayerViewController.h"

#pragma mark -
#pragma mark Compiler Directives & Static Variables

@implementation VPVideoPlayerViewController

- (id)initWithURL:(NSURL *)url screenSize:(CGSize)size
{
    self = [super init];
    if (self) {
        movieURL = [url retain];
        screenSize = size;
    }
    
    return self;
}

- (void)dealloc 
{
	[movieURL release];
	[mpVC release];
    [activityIndicatorView release];
	
	[super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [self readyPlayer];
}

- (void)AnimationEnd {    
	[self dismissModalViewControllerAnimated:YES];	
}

// prepare to play and wait preload notification
- (void) readyPlayer
{    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(screenSize.width/2, screenSize.height/2);
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];
    
 	mpVC =  [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    

    // Set controll style
    [mpVC setControlStyle:MPMovieControlStyleFullscreen]; // MPMovieControlStyleNone
    [mpVC setFullscreen:YES];
    
    
    // May help to reduce latency
    [mpVC prepareToPlay];
    
    // Register that the load state changed (movie is ready)
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayerLoadStateChanged:) 
                                                 name:MPMoviePlayerLoadStateDidChangeNotification 
                                               object:nil];
    
    
    // Register to receive a notification when the movie has finished playing. 
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification 
                                               object:nil];
}

- (void)fadeIn
{
//    self.view.alpha = 0.0;
//    [UIView beginAnimations:@"fade" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:1.5];
//    self.view.alpha = 1.0;    
//    [UIView commitAnimations];
}

- (void)fadeOut
{
//    self.view.alpha = 1.0;
//    [UIView beginAnimations:@"fade" context:nil];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDuration:1.5];
//    [UIView setAnimationDidStopSelector:@selector(AnimationEnd)];
//    self.view.alpha = 0;    
//    [UIView commitAnimations];    
}

/*---------------------------------------------------------------------------
* For 3.2 and 4.x devices
* For 3.1.x devices see moviePreloadDidFinish:
*--------------------------------------------------------------------------*/
- (void) moviePlayerLoadStateChanged:(NSNotification*)notification 
{
	// Unless state is unknown, start playback
	if ([mpVC loadState] != MPMovieLoadStateUnknown)
    {
        // Remove observer
        [[NSNotificationCenter 	defaultCenter] 
    												removeObserver:self
                         		name:MPMoviePlayerLoadStateDidChangeNotification 
                         		object:nil];

        // When tapping movie, status bar will appear, it shows up
        // in portrait mode by default. Set orientation to landscape
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        // Rotate the view for landscape playback        
        [activityIndicatorView removeFromSuperview];
        
        // Set frame of movieplayer
        [[mpVC view] setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    
        // Add movie player as subview
        [[self view] addSubview:[mpVC view]];   
        // mp.controlStyle = MPMovieControlStyleNone;

        // Play the movie
        mpVC.initialPlaybackTime = -1.f;
        [mpVC play];	
            
        [self fadeIn];

    }
}


- (void) moviePlayBackDidFinish:(NSNotification*)notification 
{    
 	// Remove observer
    [[NSNotificationCenter 	defaultCenter] 
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification 
     object:nil];
	[mpVC stop];	
	
	mpVC.initialPlaybackTime = -1.0;
    
    [self fadeOut];

	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}



//Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{   // Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft 
            || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}



@end

#endif
