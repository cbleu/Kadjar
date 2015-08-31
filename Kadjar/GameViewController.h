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

@property (nonatomic, strong) NSString *currentGameCode;

@property (nonatomic, strong) NSMutableArray *prizeArray;

@property (nonatomic, retain) IBOutlet UIImageView *imageToDisplay;

@end
