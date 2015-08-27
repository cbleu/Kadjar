//
//  ViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 27/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "ScanViewController.h"


@interface ScanViewController ()

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic) BOOL isReading;
@property (nonatomic) BOOL detectFlag;

@property (nonatomic, strong) UIView *highlightView;


-(BOOL)startReading;
-(void)stopReading;
-(void)stopDetection;

-(void)loadBeepSound;

-(void)checkPrize;
-(void)initPrizeArray;
-(NSInteger)CheckPrizeWithThatPercentToWin:(int)winThreshold;
-(NSString*)getGameCodeFrom: (NSString*)scanCode;

@end

@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    
    _detectFlag = FALSE;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    
    [self initPrizeArray];
    
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:NO];
//    [UIView setAnimationsEnabled:NO];
//    
//    // Stackoverflow #26357162 to force orientation
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:NO];
//    [UIView setAnimationsEnabled:YES];
//}


-(void)viewWillAppear:(BOOL)animated
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:[UIDevice currentDevice]];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationChanged:(NSNotification *)notification
{
    _iOSDevice = notification.object;
    
//    _videoPreviewLayer.connection.videoOrientation = [self interfaceOrientationToVideoOrientation];
    
    //or
    
//    [self setAutoVideoConnectionOrientation:YES];
    
}

//-(BOOL)shouldAutorotate {
//    return NO;
//}

//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
////    UIInterfaceOrientationMaskLandscapeLeft| UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskPortraitUpsideDown;
//    //or simply UIInterfaceOrientationMaskAll;
//}

#pragma mark - IBAction method implementation

- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        // This is the case where the app should read a QR code when the start button is tapped.
        if ([self startReading]) {
            // If the startReading methods returns YES and the capture session is successfully
            // running, then change the start button title and the status message.
            [_bbitemStart setTitle:@"Stop"];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        // In this case the app is currently reading a QR code and it should stop doing so.
        [self stopReading];
        // The bar button item's title should change again.
        [_bbitemStart setTitle:@"Start!"];
    }
    
    // Set to the flag the exact opposite value of the one that currently has.
    _isReading = !_isReading;
}


#pragma mark - Private method implementation


- (BOOL)startReading {
    NSError *error;
    
    // Patch: Anti bounce flag
    _detectFlag = FALSE;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
    // as the media type parameter.
    
//    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    AVCaptureDevice *captureDevice = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *camera in devices) {
        if([camera position] == AVCaptureDevicePositionFront) { // is front camera
            captureDevice = camera;
            break;
        }
    }

    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }

//    AVCaptureConnection *videoConnection = nil;
//    
//    for ( AVCaptureConnection *connection in [movieFileOutput connections] )
//    {
//        NSLog(@"%@", connection);
//        for ( AVCaptureInputPort *port in [connection inputPorts] )
//        {
//            NSLog(@"%@", port);
//            if ( [[port mediaType] isEqual:AVMediaTypeVideo] )
//            {
//                videoConnection = connection;
//            }
//        }
//    }
//
//    if ([videoConnection isVideoOrientationSupported])
//    {
//        AVCaptureVideoOrientation orientation = AVCaptureVideoOrientationLandscapeLeft;
//        [videoConnection setVideoOrientation:orientation];
//    }

    // Initialize the captureSession object.
    _captureSession = [[AVCaptureSession alloc] init];
    
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput: captureMetadataOutput];
    
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    //    // Get the device orientation
    //    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    //    _videoPreviewLayer.orientation = deviceOrientation;
    
    AVCaptureConnection *videoConnection = _videoPreviewLayer.connection;
    if ([videoConnection isVideoOrientationSupported])
    {
        [videoConnection setVideoOrientation:(AVCaptureVideoOrientation)[UIDevice currentDevice].orientation];
    }

    // Start video capture.
    [_captureSession startRunning];
    
    // Add green detection frame
    [self.view addSubview:_highlightView];
    [self.view bringSubviewToFront:_highlightView];
    
    _isReading = YES;

    return YES;
}


-(void)stopReading{
    // Stop video capture and make the capture session object nil.
    [_captureSession stopRunning];
    _captureSession = nil;
    
    // Remove the video preview layer from the viewPreview view's layer.
    [_videoPreviewLayer removeFromSuperlayer];
}

-(void)stopDetection
{
    // If the audio player is not nil, then play the sound effect.
    if (_audioPlayer) {
        [_audioPlayer play];
    }
    
    // Create a empty view with the color white.
    
    UIView *flashView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIView *blackView = [[UIView alloc] initWithFrame:_viewPreview.bounds];
    blackView.frame = CGRectOffset(_viewPreview.bounds, _viewPreview.frame.origin.x, _viewPreview.frame.origin.y);
    flashView.backgroundColor = [UIColor whiteColor];
    blackView.backgroundColor = [UIColor blackColor];
    flashView.alpha = 1.0;
    blackView.alpha = 0.0;
    flashView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    
    // Add the flash view to the window
    [self.view addSubview:flashView];
    [self.view bringSubviewToFront:flashView];
    [self.view addSubview:blackView];
    [self.view bringSubviewToFront:blackView];
    //    [window addSubview:flashView];
    
    // Fade it out and remove after animation.
    [UIView animateWithDuration:0.5 animations:^{
        // animation 1
        flashView.alpha = 0.0;
        blackView.alpha = 1.0;
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            // animation 2
            [_highlightView removeFromSuperview];
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.0 animations:^{
                // animation 3
                // Stop detection
                [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
                
                [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
                
                [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:_currentGameCode waitUntilDone:NO];
                
                [flashView removeFromSuperview];
                [blackView removeFromSuperview];
                
                // DEBUG get the prize !
                [self checkPrize];

                // Close the scan View
                [self dismissViewControllerAnimated:YES completion:nil];
                [self performSegueWithIdentifier:@"show_transition" sender:self];
//                dispatch_async(dispatch_get_main_queue(), {performSegueWithIdentifier(@"", self)});
                
//                dispatch_async(dispatch_get_main_queue(),{
//                    self.performSegueWithIdentifier(mysegueIdentifier, self)
//                });

            }];
        }];
    }];
    
    _isReading = NO;
    
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
    NSInteger index = [self CheckPrizeWithThatPercentToWin:100];
    
    if (index >= 0){
        
        resultStr = [NSString stringWithFormat:@"Votre lot est: %@ stock: %@", _prizeArray[index][@"name"], _prizeArray[index][@"stock"]];
        
        NSLog(@"We Win something: %@ !", resultStr);
    }else{
        resultStr = [NSString stringWithFormat:@"Désolé vous n'avez pas gagné cette fois !"];
        NSLog(@"We Loose: %@", resultStr);
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

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    
    // Check if the metadataObjects array is not nil and it contains at least one object.
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        // Get the metadata object.
        for (AVMetadataObject *metadata in metadataObjects) {
            if ([[metadata type] isEqualToString:AVMetadataObjectTypeQRCode]) {
                // If the found metadata is equal to the QR code metadata then update the status label's text,
                // stop reading and change the bar button item's title and the flag's value.
                // Everything is done on the main thread.
                
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[_videoPreviewLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                
                highlightViewRect = barCodeObject.bounds;
                _highlightView.frame = CGRectOffset(highlightViewRect, _viewPreview.frame.origin.x, _viewPreview.frame.origin.y);
                
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                
                [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:detectionString waitUntilDone:NO];
                
                _currentGameCode = [self getGameCodeFrom: detectionString];
                
                if(!_detectFlag){
                    _detectFlag = true;
                    [self performSelector:@selector(stopDetection) withObject:self afterDelay:0.2 ];
                }
            }
            break;
        }
    }else{
        _highlightView.frame = CGRectOffset(highlightViewRect, 2000, 2000);
    }
    
    
    
}

@end
