//
//  GameViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface GameViewController : UIViewController


@property (nonatomic, strong) NSMutableArray *prizeArray;

@property (nonatomic, strong) AVAudioPlayer *audioPlayerWin;
@property (nonatomic, strong) AVAudioPlayer *audioPlayerLose;

@property (nonatomic, weak) IBOutlet UIImageView *imageToDisplay;


@property (nonatomic, strong) NSString *currentGameCode;
@property (nonatomic, strong) NSString *qrCodeString;



-(void)loadWinSound;
-(void)loadLoseSound;

-(void)checkPrize;
-(void)initPrizeArray;
-(NSInteger)CheckPrizeWithThatPercentToWin:(int)winThreshold;
-(NSString*)getGameCodeFrom: (NSString*)scanCode;

@end
