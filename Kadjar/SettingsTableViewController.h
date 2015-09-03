//
//  PrizesTableViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 02/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MessageUI.h>

#import "EmailTableViewCell.h"

@interface SettingsTableViewController : UITableViewController <MFMailComposeViewControllerDelegate>

- (IBAction)deleteDataBase:(id)sender;

- (IBAction)exportDatabase:(id)sender;

- (IBAction)stepperChanged:(UIStepper *)sender;
- (IBAction)defaultEmailChanged:(UITextField *)sender;

@property (nonatomic, weak) IBOutlet UILabel *winLabel;
@property (nonatomic, weak) IBOutlet UIStepper *winStepper;

@property (nonatomic, weak) IBOutlet EmailTableViewCell *defEmailCell;

@property (nonatomic, strong)  NSString  *defaultEmail;


@end
