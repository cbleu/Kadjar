//
//  GameViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DBManager.h"
#import "DBRecordClient.h"

@interface GameViewController : UIViewController


@property (nonatomic, strong) NSMutableArray *prizeArray;

@property (nonatomic, strong) AVAudioPlayer *audioPlayerWin;
@property (nonatomic, strong) AVAudioPlayer *audioPlayerLose;

@property (nonatomic, weak) IBOutlet UIImageView *imageToDisplay;
@property (nonatomic, weak) IBOutlet UILabel *prizeLabel;

@property (nonatomic, weak) IBOutlet UIButton *errorButton;



@property (nonatomic, strong) NSString *currentGameCode;
@property (nonatomic, strong) NSString *qrCodeString;
@property (nonatomic, strong) NSString *prizeWinned;

@property (nonatomic, strong) DBRecordClient *currentPlayer;

@property bool isAnewCode;
@property bool isAbadCode;

@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrClientInfo;


-(void)loadWinSound;
-(void)loadLoseSound;

-(NSString*)getGameCodeFrom: (NSString*)scanCode;

-(void)checkPrize;
-(void)initPrizeArray;
-(NSInteger)CheckPrizeWithThatPercentToWinOld:(int)winThreshold;
-(NSInteger)CheckPrizeWithThatPercentToWin:(int)winThreshold;

@end
