//
//  EmailTableViewCell.h
//  Kadjar
//
//  Created by Cesar Jacquet on 03/09/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *defaultEmail;

@end
