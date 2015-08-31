//
//  StepUiViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "StepViewController.h"

@interface StepViewController ()
-(void)actionSegue;

@end

@implementation StepViewController

@synthesize sequeButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self performSelector:@selector(actionSegue) withObject:self afterDelay:5.0 ];
    NSLog(@"Retour automatique vers l'accueil dans 5 sec...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)actionSegue
{
    NSLog(@"Retour vers l'accueil !");
//    [self performSelector:@selector(actionButton) withObject:self afterDelay:5.0 ];
    [self performSegueWithIdentifier:@"unwindToStartSegue" sender:self];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
//#pragma mark - Navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"segueFromScanToTransition"]) {
//        UIViewController *destViewController = segue.destinationViewController;
//        destViewController.datatoTransfer = _dataToTransfer;
//    }
//}

@end
