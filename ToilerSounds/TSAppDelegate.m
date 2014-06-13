//
//  TSAppDelegate.m
//  ToilerSounds
//
//  Created by Anouk Ruhaak on 6/8/14.
//  Copyright (c) 2014 Djipsy. All rights reserved.
//

#import "TSAppDelegate.h"
#import "SWRevealViewController.h"
#import "RecordSoundsViewController.h"
#import "RearViewController.h"
#import "SoundStore.h"
#import "LoginViewController.h"
#import "MySoundsViewController.h"

@interface TSAppDelegate()<SWRevealViewControllerDelegate>
@end

@implementation TSAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Style for navbar
    [application setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [UINavigationBar appearance].barTintColor = kBackgroundColor;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.window = window;
    
	RearViewController *rearViewController = [[RearViewController alloc] init];
    MySoundsViewController *soundsVC = [MySoundsViewController new];
    
    UINavigationController *frontNavigationController = [[UINavigationController alloc] initWithRootViewController:soundsVC];
    UINavigationController *rearNavigationController = [[UINavigationController alloc] initWithRootViewController:rearViewController];
    
    SWRevealViewController *mainRevealController = [[SWRevealViewController alloc]
                                                    initWithRearViewController:rearNavigationController frontViewController:frontNavigationController];
    
    mainRevealController.delegate = self;
    	self.viewController = mainRevealController;
	
	self.window.rootViewController = self.viewController;
    
    if (![[[NSUserDefaults standardUserDefaults]valueForKeyPath:@"login_status"] isEqualToString:@"loggedIn"]) {
        LoginViewController *loginVC = [LoginViewController new];
      [self.viewController pushFrontViewController:loginVC animated:NO];
        
    }
    
    self.window.backgroundColor= [UIColor whiteColor];
	[self.window makeKeyAndVisible];
	return YES;
}


- (NSString*)stringFromFrontViewPosition:(FrontViewPosition)position
{
    NSString *str = nil;
    if ( position == FrontViewPositionLeft ) str = @"FrontViewPositionLeft";
    if ( position == FrontViewPositionRight ) str = @"FrontViewPositionRight";
    if ( position == FrontViewPositionRightMost ) str = @"FrontViewPositionRightMost";
    if ( position == FrontViewPositionRightMostRemoved ) str = @"FrontViewPositionRightMostRemoved";
    return str;
}


- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    NSLog( @"%@: %@", NSStringFromSelector(_cmd), [self stringFromFrontViewPosition:position]);
}

- (void)revealController:(SWRevealViewController *)revealController willRevealRearViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController didRevealRearViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController willHideRearViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController didHideRearViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController willShowFrontViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController didShowFrontViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController willHideFrontViewController:(UIViewController *)rearViewController
{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}

- (void)revealController:(SWRevealViewController *)revealController didHideFrontViewController:(UIViewController *)rearViewController

{
    NSLog( @"%@", NSStringFromSelector(_cmd));
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    BOOL success = [[SoundStore sharedStore] saveChanges];
    if(success) {
        NSLog(@"Saved all of the Items");
    } else {
        NSLog(@"Could not save any of the Items");
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[SoundStore sharedStore] saveChanges];
    if(success) {
        NSLog(@"Saved all of the Items");
    } else {
        NSLog(@"Could not save any of the Items");
    }
    
    
}


@end
