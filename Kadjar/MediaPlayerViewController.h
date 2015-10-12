//
//  MediaPlayerViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 27/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;
@import AVKit;

@interface MediaPlayerViewController : UIViewController




@property (nonatomic, retain) AVPlayerViewController *avPlayerViewcontroller;

@property (nonatomic, strong) NSString *qrCodeString;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;



-(void)itemDidFinishPlaying:(NSNotification *) notification;

@end
