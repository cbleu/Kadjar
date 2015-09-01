//
//  StepUiViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "StartScanViewController.h"


@implementation StartScanViewController

@synthesize sequeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(actionSegue:) withObject:self afterDelay:3.0 ];
    NSLog(@"Scan View dans 3 sec...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)actionSegue:(id)sender
{
    NSLog(@"StartScan !");
    [self performSegueWithIdentifier:@"segueFromStartScanToScan" sender:self];
}

@end
