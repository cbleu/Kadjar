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
//@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
//@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;

@property (nonatomic, strong) NSString *currentGameCode;
@property (nonatomic, strong) NSString *qrCodeString;

@property (nonatomic, strong)     UIDevice *iOSDevice;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;
@property (nonatomic) BOOL detectFlag;

@property (nonatomic, strong) UIView *highlightView;


//-(IBAction)startStopReading:(id)sender;

-(BOOL)startReading;
-(void)stopReading;
-(void)stopDetection;

-(void)loadBeepSound;


@end