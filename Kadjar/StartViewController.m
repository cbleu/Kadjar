//  Renault Kadjar
//
//  Created by Cesar Jacquet on 24/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//
//
//  RootViewController.m


#import "StartViewController.h"
#import "DBManager.h"
#import "StepViewController.h"
#import "FormViewController.h"

@interface StartViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrClientInfo;

-(void)loadData;

-(void)eraseAllData;

@end

@implementation StartViewController


@synthesize switchErase;
@synthesize buttonErase;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"clientInfoDB.sql"];
    
    // Load the data.
    [self loadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)deleteDataBase:(id)sender {
    
    [self eraseAllData];
    
}

- (IBAction)exportDatabase:(id)sender {
    
    // Export the database to CSV.
    [self.dbManager exportDBtoCSV];
    
    [self displayComposerSheet];
}

-(IBAction) switchPressedAction:(id)sender {
    
    // Lock-unlock the erase button
    if(self.switchErase.on){
        self.buttonErase.enabled = YES;
    }else{
        self.buttonErase.enabled = NO;
    }
}

- (IBAction)unwindToStart:(UIStoryboardSegue *)unwindSegue
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

#pragma mark - Private method implementation


-(void)loadData{
    // Form the query.
    NSString *query = @"select * from clientInfo";
    
    // Get the results.
    if (self.arrClientInfo != nil) {
        self.arrClientInfo = nil;
    }
    self.arrClientInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
}

-(void)eraseAllData{
    // Form the query.
    NSString *query = @"delete from clientInfo";
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    [picker setSubject:@"Export CSV de la base client"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@"contact@cbleu.re"];
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
    NSString *emailBody = @"Email d'export de l'application Nestle base Client Club";
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




//#import "RootViewController.h"
//#import "ModelController.h"
//#import "DataViewController.h"
//
//@interface RootViewController ()
//
//@property (readonly, strong, nonatomic) ModelController *modelController;
//@end
//
//@implementation RootViewController
//
//@synthesize modelController = _modelController;
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view, typically from a nib.
//    // Configure the page view controller and add it as a child view controller.
//    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    self.pageViewController.delegate = self;
//
//    DataViewController *startingViewController = [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
//    NSArray *viewControllers = @[startingViewController];
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//
//    self.pageViewController.dataSource = self.modelController;
//
//    [self addChildViewController:self.pageViewController];
//    [self.view addSubview:self.pageViewController.view];
//
//    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
//    CGRect pageViewRect = self.view.bounds;
//    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
//    self.pageViewController.view.frame = pageViewRect;
//
//    [self.pageViewController didMoveToParentViewController:self];
//
//    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
//    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//- (ModelController *)modelController {
//    // Return the model controller object, creating it if necessary.
//    // In more complex implementations, the model controller may be passed to the view controller.
//    if (!_modelController) {
//        _modelController = [[ModelController alloc] init];
//    }
//    return _modelController;
//}
//
//#pragma mark - UIPageViewController delegate methods
//
//- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
//    if (UIInterfaceOrientationIsPortrait(orientation)) {
//        // In portrait orientation: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
//        UIViewController *currentViewController = self.pageViewController.viewControllers[0];
//        NSArray *viewControllers = @[currentViewController];
//        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//        
//        self.pageViewController.doubleSided = NO;
//        return UIPageViewControllerSpineLocationMin;
//    }
//
//    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
//    DataViewController *currentViewController = self.pageViewController.viewControllers[0];
//    NSArray *viewControllers = nil;
//
//    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
//    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
//        UIViewController *nextViewController = [self.modelController pageViewController:self.pageViewController viewControllerAfterViewController:currentViewController];
//        viewControllers = @[currentViewController, nextViewController];
//    } else {
//        UIViewController *previousViewController = [self.modelController pageViewController:self.pageViewController viewControllerBeforeViewController:currentViewController];
//        viewControllers = @[previousViewController, currentViewController];
//    }
//    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
//
//
//    return UIPageViewControllerSpineLocationMid;
//}
//
//@end
