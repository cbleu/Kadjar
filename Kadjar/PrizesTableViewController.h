//
//  PrizesTableViewController.h
//  Kadjar
//
//  Created by Cesar Jacquet on 03/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol PrizesTableViewControllerDelegate <NSObject>
//
//- (void)gamePickerViewController: (PrizesTableViewController *)controller didSelectGame:(NSString *)game;
//
//@end

@interface PrizesTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *prizeArray;

//NSArray *prizesArray;

@end
