//
//  StepUiViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 31/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartScanViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *sequeButton;


-(IBAction)actionSegue:(id)sender;

@end
