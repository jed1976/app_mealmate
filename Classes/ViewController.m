//
//  ViewController.m
//  MealMate
//
//  Created by Joseph Dakroub on 3/8/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

#pragma mark -
#pragma mark View
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([self shouldPerformActionBasedOnKey:@"SettingsField-1"]) {
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		NSInteger orientation = [prefs integerForKey:@"orientation"];
		
		if (orientation < 3) {
			return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown;
		}
		
		return interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
	}
	
	return YES;	
}

#pragma mark -
#pragma mark Actions
- (BOOL)shouldPerformActionBasedOnKey:(NSString *)key
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	return [prefs boolForKey:key];
}

@end
