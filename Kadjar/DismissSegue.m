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

// MCFadeSegue.h
#import <UIKit/UIKit.h>

@interface MCFadeSegue : UIStoryboardSegue

@end

// MCFadeSegue.m
#import <QuartzCore/QuartzCore.h>
//#import "MCFadeSegue.h"

@implementation MCFadeSegue

- (void)perform
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    
    [[[[[self sourceViewController] view] window] layer] addAnimation:transition
                                                               forKey:kCATransitionFade];
    
    [[self sourceViewController]
     presentViewController:[self destinationViewController]
     animated:NO completion:NULL];
}

@end
