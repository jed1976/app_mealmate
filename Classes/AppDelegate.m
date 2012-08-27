//
//  AppDelegate.m
//  MealMate
//
//  Created by Joseph Dakroub on 3/6/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize mainViewController;

#pragma mark -
#pragma mark Memory management
- (void)dealloc 
{
    [mainViewController release];
    [window release];
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    [self.window addSubview:mainViewController.view];
    [self.window makeKeyAndVisible];
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	// Orientation
	if (![prefs boolForKey:@"SettingsField-1"]) {
		[prefs setBool:NO forKey:@"SettingsField-1"];
	}

	// UK System
	if (![prefs boolForKey:@"SettingsField-2"]) {
		[prefs setBool:NO forKey:@"SettingsField-2"];
	}

	[prefs synchronize];

    return YES;
}

- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
	if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait) {
		CGRect frame = [[(RootViewController *)mainViewController picker] frame];
		
		switch ((int)newStatusBarFrame.size.height) {
			case 40:
				frame.origin.y += 7.0;
				break;
				
			default:
				frame.origin.y -= 7.0;            
				break;
		}
		
		[[(RootViewController *)mainViewController picker] setFrame:frame];    
	}
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

@end
