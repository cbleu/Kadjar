//
//  AppDelegate.m
//  Kadjar
//
//  Created by Cesar Jacquet on 27/08/2015.
//  Copyright (c) 2015 c-bleu. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *kSettingsWinPercentKey = @"win-percent";
NSString *kSettingsDefaultEmail = @"Default email";
NSString *kPrize00 = @"T-shirt";
NSString *kPrize01 = @"Coffret KDO Pays";
NSString *kPrize02 = @"Pass Makes Aventures pour 1 adulte et 1 enfant";
NSString *kPrize03 = @"Sac à dos";
NSString *kPrize04 = @"Gourdes";
NSString *kPrize05 = @"Lampe Torche";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInteger:50], kSettingsWinPercentKey,
                                 @"", kSettingsDefaultEmail,
                                 [NSNumber numberWithInteger:0], kPrize01,
                                 [NSNumber numberWithInteger:0], kPrize02,
                                 [NSNumber numberWithInteger:0], kPrize03,
                                 [NSNumber numberWithInteger:0], kPrize04,
                                 [NSNumber numberWithInteger:0], kPrize05,
                                 nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
    
//    NSDictionary *Prizedictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
//                                     @"v1",@"k1",
//                                     @"v2",@"k2",
//                                     nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
