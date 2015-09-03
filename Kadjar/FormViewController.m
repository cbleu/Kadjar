//
//  ClientForm.m
//  Nestle base client
//
//  Created by Cesar Jacquet on 22/01/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "FormViewController.h"

@interface FormViewController ()


@end


@implementation FormViewController
//@synthesize switchClub;
@synthesize buttonSend;
@synthesize txtFirstname;
@synthesize txtLastname;
@synthesize txtEmail;
@synthesize txtGSM;
@synthesize gameCode;
@synthesize newCode;


- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view.
	
	// Make self the delegate of the textfields.
	self.txtFirstname.delegate = self;
	self.txtLastname.delegate = self;
    self.txtEmail.delegate = self;
    self.txtGSM.delegate = self;
    
    _isFormOk = NO;
	
	// Initialize the dbManager object.
	self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"clientInfoDB.sql"];
    
//    _currentPlayer = [[DBRecordClient alloc] init];
    
    self.txtFirstname.text = _currentPlayer.nom;
    self.txtLastname.text = _currentPlayer.prenom;
    self.txtEmail.text = _currentPlayer.email;
    self.txtGSM.text = _currentPlayer.gsm;
    
	
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate method implementation


-(BOOL)textFieldShouldReturn:(UITextField *)textField {

	if([self.txtFirstname.text isEqualToString:@""] || [self.txtLastname.text isEqualToString:@""] || [self.txtEmail.text isEqualToString:@""]) {
//		self.switchClub.enabled = false;
        _isFormOk = NO;
	}else{
//		self.switchClub.enabled = true;
        _isFormOk = YES;
	}
	if (textField ==txtFirstname) {
		[txtLastname becomeFirstResponder];
    }else if ( textField == txtLastname){
        [txtEmail becomeFirstResponder];
    }else if ( textField == txtEmail){
        [txtGSM becomeFirstResponder];
	}else{
		[textField resignFirstResponder];
	}
	return YES;
}


// Define some constants:

#define ALPHA                   @"ABCDEFGHIJKLMNOPQRSTUVWXYZaàbcçdeéèêfghijklmnopqrstuùûvwxyz"
#define FRENCH                  @"àçéèêùû"
#define NUMERIC                 @"1234567890"
#define ALPHA_NUMERIC           ALPHA NUMERIC

// Make sure you are the text fields 'delegate', then this will get called before text gets changed.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	
	// This will be the character set of characters I do not want in my text field.  Then if the replacement string contains any of the characters, return NO so that the text does not change.
	NSCharacterSet *unacceptedInput = nil;
	
	// I have 4 types of textFields in my view, each one needs to deny a specific set of characters:
	if (textField == self.txtEmail) {
		//  Validating an email address doesnt work 100% yet, but I am working on it....  The rest work great!
		if ([[textField.text componentsSeparatedByString:@"@"] count] > 1) {
			unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".-"]] invertedSet];
		} else {
			unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA_NUMERIC stringByAppendingString:@".-_~@"]] invertedSet];
		}
    } else if (textField == self.txtFirstname || textField == self.txtLastname) {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[ALPHA stringByAppendingString:FRENCH @" "]] invertedSet];
    } else if (textField == self.txtGSM) {
        unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:[NUMERIC stringByAppendingString:@".-()+ "]] invertedSet];
	} else {
		unacceptedInput = [[NSCharacterSet illegalCharacterSet] invertedSet];
	}
    bool test = ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1);
//    NSLog(@"test: %d", test);
	// If there are any characters that I do not want in the text field, return NO.
	return test;
}

#pragma mark - IBAction method implementation

- (IBAction)saveInfo:(id)sender {
	
	// Prepare the query string.
	NSString *query;
    if(self.newCode){
        query = [NSString stringWithFormat:@"insert into clientInfo values(null, '%@', '%@', '%@', '%@', '%@', '%@')", self.txtFirstname.text, self.txtLastname.text, self.txtEmail.text, self.txtGSM.text, self.gameCode, self.prizeWinned];
    }else{
        query = [NSString stringWithFormat:@"update clientInfo Set firstname = '%@', lastname = '%@', email = '%@', gsm = '%@' where clientInfoID = %d", self.txtFirstname.text, self.txtLastname.text, self.txtEmail.text, self.txtGSM.text, self.currentPlayer.clientInfoID];
    }
	
	// Execute the query.
	[self.dbManager executeQuery:query];
	
	// If the query was successfully executed then pop the view controller.
	if (self.dbManager.affectedRows != 0) {
		NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
		
		// Pop the view controller.
		[self.navigationController popViewControllerAnimated:YES];
	}
	else{
		NSLog(@"Could not execute the query.");
	}
}


//-(IBAction) switchPressedAction:(id)sender {
//
////    NSLog(@"switchClub:%d", switchClub.on);
//    if(switchClub.on){
//		self.buttonSend.enabled = YES;
//    }else{
//		self.buttonSend.enabled = NO;
//	}
//}


- (IBAction) NoButtonPress:(id)sender
{
    [self saveInfo:self];

    [self performSegueWithIdentifier:@"unwindToGameStartFromFormSegue" sender:self];

}



#pragma mark - Private method implementation


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:_activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}
@end
