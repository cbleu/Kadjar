//
//  GameViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "GameViewController.h"


@implementation GameViewController

@synthesize qrCodeString;
@synthesize imageToDisplay;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadWinSound];
    [self loadLoseSound];

    // Init Prizes array with stock
    [self initPrizeArray];
    
    // DEBUG get the prize !
    [self checkPrize];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initPrizeArray
{
    
    NSMutableDictionary *lot01 =[NSMutableDictionary
                                 dictionaryWithDictionary: @{
                                                             @"name": @"Casquette",
                                                             @"stock": [NSNumber numberWithInt:5]
                                                             }];
    NSMutableDictionary *lot02 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": @"T-Shirt",
                                                             @"stock": [NSNumber numberWithInt:5]
                                                             }];
    NSMutableDictionary *lot03 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": @"Stylo",
                                                             @"stock": [NSNumber numberWithInt:5]
                                                             }];
    NSMutableDictionary *lot04 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": @"Porte-Clé",
                                                             @"stock": [NSNumber numberWithInt:5]
                                                             }];
    _prizeArray = [NSMutableArray arrayWithObjects:
                   lot01, lot02, lot03, lot04, nil];
    
    
}

-(NSInteger)CheckPrizeWithThatPercentToWin:(int)winThreshold
{
    int looseLimit = 100 - winThreshold;
    
    // First: Do we win something ?
    
    int randomVal = (arc4random_uniform(100));
    NSLog(@"random value: %d, Loose threshold:%d", randomVal, looseLimit);
    if (randomVal < looseLimit){
        // We loose ;-(
        return -1;
    }
    
    // Second: As we win something, ask what ?
    
    int prizeIndex = arc4random_uniform((u_int32_t)(_prizeArray.count));
    
    int num = [[_prizeArray[prizeIndex] objectForKey:@"stock"] intValue];
    if (num <= 0){
        NSLog(@"Stock épuisé pour %@ (%d)", _prizeArray[prizeIndex][@"name"], prizeIndex);
        return -1;
    }
    NSNumber *newNum = [NSNumber numberWithInt:(num - 1)];
    [_prizeArray[prizeIndex] setObject:newNum forKey:@"stock"];
    
    //    NSInteger stock = [_prizeArray[prizeIndex][@"stock"] integerValue];
    //    [_prizeArray[prizeIndex] setObject:[NSNumber numberWithInt:stock--] forKey:@"stock"];
    
    NSLog(@"random index: %d", prizeIndex);
    
    return prizeIndex;
}


-(void)checkPrize
{
    NSString *resultStr;
    
    // Check prize
    NSInteger index = [self CheckPrizeWithThatPercentToWin:50];
    
    if (index >= 0){
        
        resultStr = [NSString stringWithFormat:@"Votre lot est: %@ stock: %@", _prizeArray[index][@"name"], _prizeArray[index][@"stock"]];
        
        NSLog(@"We Win something: %@ !", resultStr);

        UIImage *image = [UIImage imageNamed:@"Win-txt"];
        [imageToDisplay setImage:image];

        // If the audio player is not nil, then play the sound effect.
        if (_audioPlayerWin) {
            [_audioPlayerWin play];
        }

//        [self performSelector:@selector(displayWinView) withObject:self afterDelay:0.2 ];

    
    }else{
        resultStr = [NSString stringWithFormat:@"Désolé vous n'avez pas gagné cette fois !"];
        NSLog(@"We Loose: %@", resultStr);

        UIImage *image = [UIImage imageNamed:@"Lose-txt"];
        [imageToDisplay setImage:image];
        
        if (_audioPlayerLose) {
            [_audioPlayerLose play];
        }
        
    }
    
    // Display Prize
    //    [_lblTitle performSelectorOnMainThread:@selector(setText:) withObject:resultStr waitUntilDone:NO];
    
}


-(void)loadWinSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"montage-win" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayerWin = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        // If the audio player cannot be initialized then log a message.
        NSLog(@"Could not play file %@.", beepFilePath);
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        // If the audio player was successfully initialized then load it in memory.
        [_audioPlayerWin prepareToPlay];
    }
}

-(void)loadLoseSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"montage-lose" ofType:@"mp3"];
    NSURL *beepURL = [NSURL URLWithString:beepFilePath];
    NSError *error;
    
    _audioPlayerLose = [[AVAudioPlayer alloc] initWithContentsOfURL:beepURL error:&error];
    if (error) {
        NSLog(@"Could not play file %@.", beepFilePath);
        NSLog(@"%@", [error localizedDescription]);
    }
    else{
        [_audioPlayerLose prepareToPlay];
    }
}

-(NSString*)getGameCodeFrom: (NSString*)scanCode
{
    NSString *code = [[scanCode componentsSeparatedByString:@"#"] lastObject];
    
    return code;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */



@end
