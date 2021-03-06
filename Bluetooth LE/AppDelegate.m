//
//  AppDelegate.m
//  Bluetooth LE
//
//  Created by Jens Willy Johannsen on 30-04-12.
//  Copyright (c) 2012 Greener Pastures. All rights reserved.
//

#import "AppDelegate.h"
#import "CBUUID+Utils.h"
#import "ViewController.h"

static NSString* const kUserDefaults_PreferredDeviceKey = @"kUserDefaults_PreferredDeviceKey";

@implementation AppDelegate

@synthesize window = _window, preferredDeviceUUID;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
	[self.window makeKeyAndVisible];
	[self showSplash];
	[self setAppearance];
	
    return YES;
}
	
- (void)showSplash
{
	DEBUG_POSITION;
	UIImageView *splashView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
	[self.window addSubview:splashView];
	
	CGRect frame = CGRectInset( splashView.frame, -splashView.frame.size.width, -splashView.frame.size.height );
	[UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
		DEBUG_LOG( @"Animating: %@", splashView ); 
		splashView.alpha = 0;
		splashView.frame = frame;
	} completion:^(BOOL finished) {
		[splashView removeFromSuperview];
	}];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	[self savePreferredDevice];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	[self loadPreferredDevice];
	
	// Connect if not already connected
	ViewController *viewController = (ViewController*)_window.rootViewController;
	if( !viewController.connectedPeripheral )
	{
		[viewController scanAction:nil];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)savePreferredDevice
{
	DEBUG_POSITION;
	
	if( preferredDeviceUUID == nil )
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaults_PreferredDeviceKey];
	else 
	{
		NSData *UUIDData = [preferredDeviceUUID data];
		[[NSUserDefaults standardUserDefaults] setObject:UUIDData forKey:kUserDefaults_PreferredDeviceKey];
	}
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadPreferredDevice
{
	DEBUG_POSITION;
	
	NSData *UUIDData = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaults_PreferredDeviceKey];
	if( UUIDData != nil )
		preferredDeviceUUID = [CBUUID UUIDWithData:UUIDData];
}

- (void)setAppearance
{
	[[UIToolbar appearance] setBackgroundImage:[UIImage imageNamed:@"toolbar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}
@end
