//
//  ClientForm.h
//  Nestle base client
//
//  Created by Cesar Jacquet on 22/01/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtFirstname;

@property (weak, nonatomic) IBOutlet UITextField *txtLastname;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UISwitch *switchClub;

@property (weak, nonatomic) IBOutlet UIButton *buttonSend;

@property (nonatomic) int recordIDToEdit;


- (IBAction)saveInfo:(id)sender;

- (IBAction)switchPressedAction:(id)sender;

@end
