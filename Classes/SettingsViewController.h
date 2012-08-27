//
//  SettingsViewController.h
//  MealMate
//
//  Created by Joseph Dakroub on 3/7/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : ViewController <UITableViewDelegate, UITableViewDataSource> {
	id <SettingsViewControllerDelegate> delegate;
	IBOutlet UILabel *versionLabel;
}

- (IBAction)done:(id)sender;

@property (nonatomic, assign) id <SettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *versionLabel;

@end

@protocol SettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller;
@end
