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

@interface MediaPlayerViewController ()

@property (nonatomic, retain) AVPlayerViewController *avPlayerViewcontroller;


-(void)itemDidFinishPlaying:(NSNotification *) notification;

@end


@implementation MediaPlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *view = self.view;
    NSString *resourceName = @"ECRAN3BD.mov";
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

//    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"segueFromTransitionToWin" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFromScanToTransition"]) {
        GameViewController *destViewController = segue.destinationViewController;
        destViewController.currentGameCode = _currentGameCode;
    }
}



@end
