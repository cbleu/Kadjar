//
//  ClientForm.h
//  Nestle base client
//
//  Created by Cesar Jacquet on 22/01/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBManager.h"

@interface FormViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;

@property (weak, nonatomic) IBOutlet UITextField *txtLastname;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtGSM;

//@property (weak, nonatomic) IBOutlet UISwitch *switchClub;

@property (weak, nonatomic) IBOutlet UIButton *buttonSend;

@property (nonatomic) int recordIDToEdit;

@property (nonatomic) bool isFormOk;

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

@property (nonatomic, weak) UITextField *activeField;

- (IBAction)saveInfo:(id)sender;

//- (IBAction)switchPressedAction:(id)sender;
-(void)registerForKeyboardNotifications;

@end
