//
//  ViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 27/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "ScanViewController.h"
#import "MediaPlayerViewController.h"


@implementation ScanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Initially make the captureSession object nil.
    _captureSession = nil;
    
    // Set the initial value of the flag to NO.
    _isReading = NO;
    _detectFlag = NO;
    
    // Begin loading the sound effect so to have it ready for playback when it's needed.
    [self loadBeepSound];
    
    // Prepare the green detection scan square
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
        
    [self startReading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
}

-(BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
//    UIInterfaceOrientationMaskLandscapeLeft| UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait |UIInterfaceOrientationMaskPortraitUpsideDown;
}


#pragma mark - Private method implementation


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

- (BOOL)startReading {
    NSError *error;
    
    // Patch: Anti bounce flag
    _detectFlag = FALSE;
    
    // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
    AVCaptureDevice *captureDevice = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice *camera in devices) {
        if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
            NSLog(@"IPAD");
            if([camera position] == AVCaptureDevicePositionFront) { // is front camera
                captureDevice = camera;
                break;
            }
        }else{
            NSLog(@"IPHONE");
            if([camera position] == AVCaptureDevicePositionBack) { // is Back camera
                captureDevice = camera;
                break;
            }
        }
    }

    // Get an instance of the AVCaptureDeviceInput class using the previous device object.
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        // If any error occurs, simply log the description of it and don't continue any more.
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }

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
    
    // Adjust the capture orientation
    AVCaptureConnection *videoConnection = _videoPreviewLayer.connection;

    if ([videoConnection isVideoOrientationSupported])
    {
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
            [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
        }else{
            [videoConnection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
        }
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
        NSLog(@"Play beep file.");
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
                
                [flashView removeFromSuperview];
                [blackView removeFromSuperview];

                // Close the scan View
                [self performSegueWithIdentifier:@"segueFromScanToTransition" sender:self];

            }];
        }];
    }];
    _isReading = NO;
}


#pragma mark - navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueFromScanToTransition"]) {
        MediaPlayerViewController *destViewController = segue.destinationViewController;
        destViewController.qrCodeString = self.qrCodeString;
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate method implementation

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    
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
                
                self.qrCodeString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                
//                [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:_qrCodeString waitUntilDone:NO];

                if(!_detectFlag){
                    _detectFlag = true;
                    [self performSelector:@selector(stopDetection) withObject:self afterDelay:0.2 ];
                }
            }
            break;
        }
    }else{
        _highlightView.frame = CGRectOffset(highlightViewRect, 2000, 2000); // en dehors de l'ecran
    }

}

@end
