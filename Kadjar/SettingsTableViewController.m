//
//  PrizesTableViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 02/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "StartViewController.h"
#import "AppDelegate.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

#define TAG_WINSTEPPER      10


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.winStepper.value = [defaults integerForKey:kSettingsWinPercentKey];
    self.winStepper.stepValue = 5.0f;
    self.winLabel.text = [NSString stringWithFormat:@"%1.0f", self.winStepper.value];
    
    _defaultEmail = [defaults stringForKey:kSettingsDefaultEmail];
    self.defEmailCell.defaultEmail.text = [defaults stringForKey:kSettingsDefaultEmail];
//     [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}


- (IBAction)stepperChanged:(UIStepper *)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    switch (sender.tag)
    {
        case TAG_WINSTEPPER:
            [defaults setInteger:sender.value forKey:kSettingsWinPercentKey];
            self.winLabel.text = [NSString stringWithFormat:@"%1.0f", sender.value];
            NSLog(@"Win = %@", self.winLabel.text);
            break;
    }
}


- (IBAction)deleteDataBase:(id)sender {
    
    if([self.presentingViewController isKindOfClass:[StartViewController class]]) {
        StartViewController* vc = (StartViewController*)self.presentingViewController;
        
        [vc eraseAllData];
    }

}

- (IBAction)exportDatabase:(id)sender {
    
    if([self.presentingViewController isKindOfClass:[StartViewController class]]) {
        StartViewController* vc = (StartViewController*)self.presentingViewController;
        
        // Export the database to CSV.
        [vc.dbManager exportDBtoCSV];
        
        [self displayComposerSheet];
    }
    
}

- (IBAction)defaultEmailChanged:(UITextField *)sender
{

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: sender.text forKey: kSettingsDefaultEmail];
    
    NSLog(@"Update default email to %@", sender.text);
}



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
////    EmailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"defaultEmailCell"];
////    cell.defaultEmail.text = _defaultEmail;
////    return cell;
//
//    UITableViewCell *aCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//
//    // Configure the cell...
//    if ([aCell.reuseIdentifier isEqualToString:@"defaultEmailCell"]){
//        EmailTableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"defaultEmailCell"];
//        aCell.defaultEmail.text = _defaultEmail;
//    }
//    
////    else if ([aCell.reuseIdentifier isEqualToString:@"someOtherIdentifier"]) {
////        //other configuration block
////    }
//    return aCell;
//
//
//    NSString *cellIdentifier = [NSString stringWithFormat:@"s%i-r%i", indexPath.section, indexPath.row];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if (cell == nil)
//    {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
//        //you can customize your cell here because it will be used just for one row.
//    }
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)displayComposerSheet
{
//    if(![MFMessageComposeViewController canSendText]) {
//        NSLog(@"ERROR: can't use email function !");
//        return;
//    }

    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Export CSV de la base client"];
    
    // Set up recipients
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *defaultEmail = [defaults stringForKey:kSettingsDefaultEmail];

    NSArray *toRecipients = [NSArray arrayWithObject:defaultEmail];
    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
    
    [picker setToRecipients:toRecipients];
    // [picker setCcRecipients:ccRecipients];
    // [picker setBccRecipients:bccRecipients];
    
    // Set the documents directory path to the documentsDirectory property.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    NSString *csvFile = [documentsDir stringByAppendingPathComponent:@"clientInfo.csv"];
    
    NSData *fileData = [NSData dataWithContentsOfFile:csvFile];
    
    [picker addAttachmentData:fileData mimeType:@"text/csv" fileName:@"clientInfo.csv"];
    
    // Fill out the email body text
    NSString *emailBody = @"Email d'export de la base Client";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewController delegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
