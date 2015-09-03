//
//  MediaPlayerViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 27/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "GameViewController.h"


@implementation MediaPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = self.view;
    NSString *resourceName = @"ECRAN3BD-audio.mov";
    NSString* movieFilePath = [[NSBundle mainBundle]
                               pathForResource:resourceName ofType:nil];
    NSAssert(movieFilePath, @"movieFilePath is nil");
    NSURL *fileURL = [NSURL fileURLWithPath:movieFilePath];
    
    AVPlayerViewController *playerViewController = [[AVPlayerViewController alloc] init];
    playerViewController.player = [AVPlayer playerWithURL:fileURL];
    _avPlayerViewcontroller = playerViewController;

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(itemDidFinishPlaying:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_avPlayerViewcontroller.player currentItem]];



    _avPlayerViewcontroller.showsPlaybackControls = NO;

    [self resizePlayerToViewSize];
    [view addSubview: _avPlayerViewcontroller.view];

    view.autoresizesSubviews = TRUE;


    // Begin playback
    [_avPlayerViewcontroller.player play];

    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) resizePlayerToViewSize
{
    CGRect frame = self.view.frame;
    
    NSLog(@"frame size %d, %d", (int)frame.size.width, (int)frame.size.height);
    
    self.avPlayerViewcontroller.view.frame = frame;
}


-(void)itemDidFinishPlaying:(NSNotification *) notification
{
    // Will be called when AVPlayer finishes playing playerItem
    NSLog(@"End media");

    // If the audio player is not nil, then play the sound effect.
//    if (_audioPlayer) {
//        [_audioPlayer play];
//    }

//    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"segueFromTransitionToWin" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"segueFromScanToTransition"]) {
    if ([segue.identifier isEqualToString:@"segueFromTransitionToWin"]) {
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.qrCodeString = self.qrCodeString;
    }
}


-(void)loadBeepSound
{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"montage-win" ofType:@"mp3"];
    //    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    
    NSError *error;
    
    // Initialize the audio player object using the NSURL object previously set.
    _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play beep file.");
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayer prepareToPlay];
    }
}


@end
