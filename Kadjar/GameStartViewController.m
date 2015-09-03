//
//  GameStartViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 03/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "GameStartViewController.h"
#import "FormViewController.h"
#import "StepViewController.h"


@interface GameStartViewController ()

@end

@implementation GameStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)unwindToGameStart:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    if ([sourceViewController isKindOfClass:[StepViewController class]])
    {
        NSLog(@"Coming from StepUIViewController!");
    }
    else if ([sourceViewController isKindOfClass:[FormViewController class]])
    {
        NSLog(@"Coming from FormViewController!");
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

@end
