//
//  ViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 27/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ScanViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

@property (nonatomic, strong) NSString *currentGameCode;
@property (nonatomic, strong) NSMutableArray *prizeArray;

- (IBAction)startStopReading:(id)sender;


@end