//
//  SettingsViewController.m
//  MealMate
//
//  Created by Joseph Dakroub on 3/7/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

@synthesize delegate;
@synthesize versionLabel;

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
}

- (void)dealloc
{
	[versionLabel release];
    [super dealloc];
}

#pragma mark -
#pragma mark View
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
	[versionLabel setText:[NSString stringWithFormat:[versionLabel text], [info objectForKey:@"CFBundleVersion"]]];
}

#pragma mark -
#pragma mark Delegate methods
- (IBAction)done:(id)sender 
{
	[[self delegate] settingsViewControllerDidFinish:self];
}

#pragma mark -
#pragma mark UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	UIImageView *imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"settings-background.png"]] autorelease];
	[tableView setBackgroundView:imageView];
	
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

	if (indexPath.row == 1) {
		[[cell textLabel] setText:@"UK System"];		
		
		UISwitch *systemSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)] autorelease];
		[systemSwitch addTarget:self action:@selector(savePreference:) forControlEvents:UIControlEventValueChanged];
		[systemSwitch setOn:[prefs boolForKey:@"SettingsField-2"]];
		[systemSwitch setTag:2];
		
		[cell setAccessoryView:systemSwitch];		
	}
			
	if (indexPath.row == 0) {
		[[cell textLabel] setText:@"Lock Orientation"];

		UISwitch *orientationSwitch = [[[UISwitch alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)] autorelease];
		[orientationSwitch addTarget:self action:@selector(savePreference:) forControlEvents:UIControlEventValueChanged];		
		[orientationSwitch setOn:[prefs boolForKey:@"SettingsField-1"]];
		[orientationSwitch setTag:1];
		[cell setAccessoryView:orientationSwitch];
	}

    return cell;
}

#pragma mark -
#pragma mark Actions
- (void)savePreference:(id)sender
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	UISwitch *control = (UISwitch *)sender;

	[prefs setBool:[control isOn] forKey:[NSString stringWithFormat:@"SettingsField-%i", [control tag]]];

	if ([control tag] == 1) {
		[prefs setInteger:[[UIApplication sharedApplication] statusBarOrientation] forKey:@"orientation"];		
	}
}

@end
