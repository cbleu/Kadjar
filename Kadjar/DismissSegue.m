//
//  DismissSegue.m
//  Nestle base client
//
//  Created by Cesar Jacquet on 21/01/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
	
	// Close both modal view controller. TODO: improve !
	UIViewController *sourceViewController = self.sourceViewController;
	[sourceViewController.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end