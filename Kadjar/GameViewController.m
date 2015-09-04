//
//  GameViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "GameViewController.h"
#import "AppDelegate.h"
#import "FormViewController.h"

@implementation GameViewController

@synthesize qrCodeString;
@synthesize imageToDisplay;
@synthesize prizeLabel;

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


//-(void)initPrizeArray
//{
//    
//    NSMutableDictionary *lot01 =[NSMutableDictionary
//                                 dictionaryWithDictionary: @{
//                                                             @"name": @"Casquette",
//                                                             @"stock": [NSNumber numberWithInt:5]
//                                                             }];
//    NSMutableDictionary *lot02 = [NSMutableDictionary
//                                  dictionaryWithDictionary:@{
//                                                             @"name": @"T-Shirt",
//                                                             @"stock": [NSNumber numberWithInt:5]
//                                                             }];
//    NSMutableDictionary *lot03 = [NSMutableDictionary
//                                  dictionaryWithDictionary:@{
//                                                             @"name": @"Stylo",
//                                                             @"stock": [NSNumber numberWithInt:5]
//                                                             }];
//    NSMutableDictionary *lot04 = [NSMutableDictionary
//                                  dictionaryWithDictionary:@{
//                                                             @"name": @"Porte-Clé",
//                                                             @"stock": [NSNumber numberWithInt:5]
//                                                             }];
//    _prizeArray = [NSMutableArray arrayWithObjects:
//                   lot01, lot02, lot03, lot04, nil];
//    
//    
//}

-(void)initPrizeArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *lot00 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize00,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize00]]
                                                             }];
    NSMutableDictionary *lot01 =[NSMutableDictionary
                                 dictionaryWithDictionary: @{
                                                             @"name": kPrize01,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize01]]
                                                             }];
    NSMutableDictionary *lot02 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize02,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize02]]
                                                             }];
    NSMutableDictionary *lot03 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize03,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize03]]
                                                             }];
    NSMutableDictionary *lot04 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize04,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize04]]
                                                             }];
    NSMutableDictionary *lot05 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize05,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize05]]
                                                             }];
    _prizeArray = [NSMutableArray arrayWithObjects:
                   lot00, lot01, lot02, lot03, lot04, lot05, nil];
    
    
}


-(NSInteger)CheckPrizeWithThatPercentToWinOld:(int)winThreshold
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

-(NSInteger)CheckPrizeWithThatPercentToWin:(int)winThreshold
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    int looseLimit = 100 - winThreshold;
    
    // First: Do we win something ?
    
    int randomVal = (arc4random_uniform(100));
    NSLog(@"random value: %d, Loose threshold:%d", randomVal, looseLimit);
    if (randomVal < looseLimit){
        // We loose ;-(
        return -1;
    }
    
    // Second: As we win something, ask what ?
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"stock > 0" ];
    NSArray *filteredPrize = [_prizeArray filteredArrayUsingPredicate:predicate];
    
    NSLog(@"filteredArray: %@", filteredPrize);

    if (filteredPrize.count <= 0) {
        NSLog(@"ATTENTION: Il n'y a plus aucun lot à gagner !!!!");
        return -1;
    }else{
        NSLog(@"Il reste %d sur %d types de lots à gagner", filteredPrize.count, _prizeArray.count);
    }
    
    int totalStock = 0;

    for (id key in filteredPrize) {
//        id value = [filteredPrize objectAtIndex:key];
        NSInteger st = [key[@"stock"] integerValue];
        totalStock += st;
    }
    NSLog(@"Stock total restant: %d", totalStock);
    while (true) {
        
        int prizeIndex = arc4random_uniform((u_int32_t)(filteredPrize.count));
        
        int actualStock = [[filteredPrize[prizeIndex] objectForKey:@"stock"] intValue];
        
        // Random sur le stock total
        int secondFire = arc4random_uniform((u_int32_t)(totalStock));
        NSLog(@"Tirage fIdx=%D => %d pour %d",prizeIndex, secondFire, actualStock);

        // On test si le tirage est tombé dans le stock du lot
        if (secondFire > actualStock) {
            // Non, on passe à un autre lot
            continue;   // On refait un tirage de lot
        }
        NSNumber *newstock = [NSNumber numberWithInt:(actualStock - 1)];
        [filteredPrize[prizeIndex] setObject:newstock forKey:@"stock"];

        NSInteger fullIndex=[_prizeArray indexOfObject:filteredPrize[prizeIndex]];

        // Update des stocks
        [defaults setInteger: [newstock integerValue] forKey: _prizeArray[fullIndex][@"name"]];
        
        NSLog(@"Filtered index: %d", prizeIndex);
        NSLog(@"index dans _prizeArray: %ld", (long)fullIndex);

        
        return fullIndex;
    }
    
}


-(void)checkPrize
{
    NSString *resultStr;
    NSInteger index;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _currentPlayer= [[DBRecordClient alloc] init];
    
    NSString *scanCode = [self getGameCodeFrom: self.qrCodeString];
    
    if(_isAbadCode){
        NSLog(@"ERROR: Bad Code, back to start");
        [self performSegueWithIdentifier:@"unwindToGameStartForBadCode" sender:self];
        
        resultStr = [NSString stringWithFormat:@"Désolé vous n'avez pas gagné cette fois !"];
        _prizeWinned = @"";
        
        [prizeLabel setText:@"ERREUR Ce QR Code ne fait pas partie du jeu !"];
        
        UIImage *image = [UIImage imageNamed:@"ERROR-txt"];
        [imageToDisplay setImage:image];
        
        [self.errorButton setHidden:NO];

        return;
    }
    _currentPlayer = [appDelegate isGameCodeExist: scanCode];
    
    if(! _currentPlayer){

        NSLog(@"Nouveau Code");
        
        _isAnewCode = YES;
        
        // Check prize
        index = [self CheckPrizeWithThatPercentToWin: (int)[defaults integerForKey: kSettingsWinPercentKey]];
        if (index >= 0){
            
            resultStr = [NSString stringWithFormat:@"Votre lot est: %@ stock: %@", _prizeArray[index][@"name"], _prizeArray[index][@"stock"]];
            NSString *strLabel = [NSString stringWithFormat:@"Votre lot gagnant est: %@", _prizeArray[index][@"name"]];
           
            NSLog(@"We Win something: %@ !", resultStr);
            _prizeWinned = _prizeArray[index][@"name"];
            
            [prizeLabel setText: strLabel];

            UIImage *image = [UIImage imageNamed:@"Win-txt"];
            [imageToDisplay setImage:image];
            
            // If the audio player is not nil, then play the sound effect.
            if (_audioPlayerWin) {
                [_audioPlayerWin play];
            }

        }else{
            resultStr = [NSString stringWithFormat:@"Désolé vous n'avez pas gagné cette fois !"];
            NSLog(@"We Loose: %@", resultStr);
            _prizeWinned = @"";
            
            [prizeLabel setText:@"Vous n'avez pas gagné avec ce bon"];

            UIImage *image = [UIImage imageNamed:@"Lose-txt"];
            [imageToDisplay setImage:image];
            
            if (_audioPlayerLose) {
                [_audioPlayerLose play];
            }
            
        }
    }else{
        NSLog(@"Code connu");
        
        _isAnewCode = NO;
        
        if([_currentPlayer.prize isEqualToString:@"LOSE"]){
            NSLog(@"We Loose: %@", resultStr);
            _prizeWinned = @"";
            
            [prizeLabel setText:@"Bon déjà scanné, vous n'avez pas gagné avec ce bon !"];
            
            UIImage *image = [UIImage imageNamed:@"Lose-txt"];
            [imageToDisplay setImage:image];
            
            if (_audioPlayerLose) {
                [_audioPlayerLose play];
            }
            
        }else{
            NSString *strLabel = [NSString stringWithFormat:@"Bon déjà scanné, votre lot gagnant était: %@", _currentPlayer.prize];
            NSLog(@"%@",strLabel);
            
            _prizeWinned = @"";
            
            [prizeLabel setText: strLabel];

            UIImage *image = [UIImage imageNamed:@"Win-txt"];
            [imageToDisplay setImage:image];
            
            if (_audioPlayerWin) {
                [_audioPlayerWin play];
            }
        }
    }
    
    
    
    // Display Prize
    //    [_lblTitle performSelectorOnMainThread:@selector(setText:) withObject:resultStr waitUntilDone:NO];
    
}


-(void)loadWinSound
{
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"Drum-Roll-Win" ofType:@"mp3"];
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
    NSString *beepFilePath = [[NSBundle mainBundle] pathForResource:@"Drum-Roll-Lose" ofType:@"mp3"];
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
    
    NSCharacterSet *unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];

    // If there are any characters that I do not want in the text field, return NO.
    bool passTest = ([[code componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
    NSLog(@"passTest du QR Code: %d", passTest);
    
    if(passTest == NO){
        _isAbadCode = YES;
        return @"BAD_CODE";
    }else{
        _isAbadCode = NO;
        return code;
    }

}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFromeWinToForm"]) {
        FormViewController *destViewController = segue.destinationViewController;
        
        NSString *gamecode = [self getGameCodeFrom: self.qrCodeString];
        destViewController.gameCode = gamecode;
        destViewController.prizeWinned = _prizeWinned;
        destViewController.newCode = _isAnewCode;
        destViewController.currentPlayer = _currentPlayer;
    }
}



@end
