//
//  PrizesTableViewController.m
//  Kadjar
//
//  Created by Cesar Jacquet on 03/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "PrizesTableViewController.h"
#import "PrizeTableViewCell.h"
#import "AppDelegate.h"

@interface PrizesTableViewController ()

@end

@implementation PrizesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

//    NSDictionary *dictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"1",@"2",@"2", nil];
//    NSArray *keyArray = [dictionary allKeys];
//    NSArray *valueArray = [dictionary allValues];
    [self initPrizeArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initPrizeArray
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *lot00 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize00,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize00]]
                                                             }];
    NSMutableDictionary *lot01 =[NSMutableDictionary
                                 dictionaryWithDictionary: @{
                                                             @"name": kPrize01,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize01]]
                                                             }];
    NSMutableDictionary *lot02 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize02,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize02]]
                                                             }];
    NSMutableDictionary *lot03 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize03,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize03]]
                                                             }];
    NSMutableDictionary *lot04 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize04,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize04]]
                                                             }];
    NSMutableDictionary *lot05 = [NSMutableDictionary
                                  dictionaryWithDictionary:@{
                                                             @"name": kPrize05,
                                                             @"stock": [NSNumber numberWithInt:[defaults integerForKey: kPrize05]]
                                                             }];
    _prizeArray = [NSMutableArray arrayWithObjects:
                   lot00, lot01, lot02, lot03, lot04, lot05, nil];
    
    
}

- (IBAction)stockChanged:(UITextField *)sender
{

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    [_prizeArray objectAtIndex:indexPath.row][@"stock"] = sender.text;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger: [sender.text integerValue] forKey:[_prizeArray objectAtIndex:indexPath.row][@"name"]];

    NSLog(@"Update %d = %@", indexPath.row, sender.text);
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _prizeArray.count;
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
//
//    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
//    cell.accessoryType = UITableViewCellAccessoryNone;
//    
////    NSUInteger section = [indexPath section];
////    NSUInteger row = [indexPath row];
//    
//    // Configure the cell...
//    
//    return cell;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PrizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrizeCell"];
    cell.textLabel.text = [_prizeArray objectAtIndex:indexPath.row][@"name"];
    cell.numberItem.text = [NSString stringWithFormat: @"%@", [_prizeArray objectAtIndex:indexPath.row][@"stock"] ];
    return cell;
}

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

@end
