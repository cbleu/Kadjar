//
//  GameViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

-(void)loadBeepSound;

-(void)checkPrize;
-(void)initPrizeArray;
-(NSInteger)CheckPrizeWithThatPercentToWin:(int)winThreshold;
-(NSString*)getGameCodeFrom: (NSString*)scanCode;

@end


@implementation GameViewController

@synthesize imageToDisplay;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    NSInteger index = [self CheckPrizeWithThatPercentToWin:10];
    
    if (index >= 0){
        
        resultStr = [NSString stringWithFormat:@"Votre lot est: %@ stock: %@", _prizeArray[index][@"name"], _prizeArray[index][@"stock"]];
        
        NSLog(@"We Win something: %@ !", resultStr);

        UIImage *image = [UIImage imageNamed:@"ECRAN5-gagne"];
        [imageToDisplay setImage:image];

        // If the audio player is not nil, then play the sound effect.
        if (_audioPlayer) {
            [_audioPlayer play];
        }

//        [self performSelector:@selector(displayWinView) withObject:self afterDelay:0.2 ];

    
    }else{
        resultStr = [NSString stringWithFormat:@"Désolé vous n'avez pas gagné cette fois !"];
        NSLog(@"We Loose: %@", resultStr);

        UIImage *image = [UIImage imageNamed:@"ECRAN5-dommage"];
        [imageToDisplay setImage:image];
        
        // If the audio player is not nil, then play the sound effect.
        if (_audioPlayer) {
            [_audioPlayer play];
        }
        
    }
    
    // Display Prize
    //    [_lblTitle performSelectorOnMainThread:@selector(setText:) withObject:resultStr waitUntilDone:NO];
    
}


-(void)loadBeepSound{
    // Get the path to the beep.mp3 file and convert it to a NSURL object.
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
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
