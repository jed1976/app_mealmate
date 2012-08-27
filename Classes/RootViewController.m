//
//  RootViewController.m
//  MealMate
//
//  Created by Joseph Dakroub on 3/6/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController()
- (void)calculatePoints:(UIPickerView *)pickerView;
- (void)reset;
- (void)displaySystem;
- (void)storePickerComponentSelections;
- (void)updatePickerComponents;
- (void)setServings:(CGFloat)servings;
@end

@implementation RootViewController

@synthesize downSound;
@synthesize overlay;
@synthesize picker;
@synthesize upSound;
@synthesize resetSound;
@synthesize webView;

NSMutableArray *pickerComponentSelections;
NSInteger points = 0;
NSInteger currentPoints = 0;

#pragma mark -
#pragma mark Memory management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
	[downSound release];	
	[overlay release];
	[picker release];
	[pickerComponentSelections release];
	[upSound release];	
	[resetSound release];
	[webView release];	
    [super dealloc];
}

#pragma mark -
#pragma mark View
-(BOOL)canBecomeFirstResponder
{
	return YES;
}

- (void)viewDidLoad
{
	// Picker origin
	CGRect frame = [picker frame];
	frame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height == 40.0 ? 196.0 : 208.0;
	[picker setFrame:frame];
	
	// WebView
	NSString *path = [[NSBundle mainBundle] pathForResource:@"display" ofType:@"html"];
	NSURL *URL = [NSURL fileURLWithPath:path];
	[webView setOpaque:NO];
	[webView setBackgroundColor:[UIColor clearColor]];	
	[webView loadRequest:[NSURLRequest requestWithURL:URL]];
	
	// Up Sound
	path = [[NSBundle mainBundle] pathForResource:@"beep-up" ofType:@"caf"];
	URL = [NSURL fileURLWithPath:path];	
	AVAudioPlayer *p = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:NULL];
	[self setUpSound:p];
	[p release];

	// Down Sound
	path = [[NSBundle mainBundle] pathForResource:@"beep-down" ofType:@"caf"];
	URL = [NSURL fileURLWithPath:path];	
	p = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:NULL];
	[self setDownSound:p];
	[p release];

	// Reset Sound
	path = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"caf"];
	URL = [NSURL fileURLWithPath:path];	
	p = [[AVAudioPlayer alloc] initWithContentsOfURL:URL error:NULL];
	[self setResetSound:p];
	[p release];
	
	pickerComponentSelections = [[NSMutableArray alloc] initWithCapacity:8];
	
	[super viewDidLoad];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
	[[[self view] layer] setShouldRasterize:YES];
	[[[self view] layer] setRasterizationScale:[[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2 ? 2.0 : 1.0];	
	[[self view] setAlpha:0.0];	

	if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
		if (![self shouldPerformActionBasedOnKey:@"SettingsField-1"]) {			
			if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
				[picker selectRow:0 inComponent:8 animated:NO];
				[picker selectRow:0 inComponent:9 animated:NO];					
			}
		}
	}
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
	CGRect pickerFrame = [picker frame];
	CGRect webViewFrame = [webView frame];	
	
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		// Overlay
		[overlay setImage:[UIImage imageNamed:@"overlay-landscape.png"]];
		
		// Picker
		pickerFrame.origin.y = 125.0;
		pickerFrame.size.height = 162.0;
		
		// WebView
		webViewFrame.origin.x = 56.0;		
		webViewFrame.origin.y = 13.0;
		webViewFrame.size.width = 369.0;
		webViewFrame.size.height = 98.0;
	} else {
		// Overlay
		[overlay setImage:[UIImage imageNamed:@"overlay-portrait.png"]];
		
		// Picker
		pickerFrame.origin.y = [[UIApplication sharedApplication] statusBarFrame].size.height == 40.0 ? 196.0 : 208.0;
		pickerFrame.size.height = 216.0;
		
		// WebView
		webViewFrame.origin.x = 11.0;		
		webViewFrame.origin.y = 16.0;
		webViewFrame.size.width = 298.0;
		webViewFrame.size.height = 168.0;		
	}
	
	[picker setFrame:pickerFrame];
	[picker setNeedsLayout];		
	[webView setFrame:webViewFrame];	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[UIView beginAnimations:@"fadeIn" context:nil];
	[UIView setAnimationDuration:0.25];
	[[self view] setAlpha:1.0];
	[UIView commitAnimations];
	
	[self updatePickerComponents];
	[self calculatePoints:picker];	
	[self becomeFirstResponder];	
}

#pragma mark -
#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return UIInterfaceOrientationIsLandscape([self interfaceOrientation]) ? 10 : 8;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if (component == 8) {
		return 25;
	}
	
	if (component == 9) {
		return 2;
	}
	
	return component % 2 == 0 ? 100 : 2;
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return 35.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIButton *)view 
{	
	UIButton *label = nil;
	
	if (!view) {
		label = [[[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)] autorelease];
		[label setBackgroundImage:[UIImage imageNamed:@"picker-background.png"] forState:UIControlStateNormal];
		[label setContentEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, component % 2 ? 0.0 : 5.0)];
		[label setContentHorizontalAlignment:component % 2 == 0 ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft];		
		[label setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[[label titleLabel] setFont:[UIFont boldSystemFontOfSize:16.0]];
		[label setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
		[label setUserInteractionEnabled:NO];		
	} else {		
		label = view;
	}
	
	switch (component) {
		case 8:
			[label setTitle:[NSString stringWithFormat:@"%i", row + 1] forState:UIControlStateNormal];
			break;
		
		case 9:
			[label setTitle:[NSString stringWithFormat:@" .%i", row == 0 ? row : 5] forState:UIControlStateNormal];
			break;

		default:
			[label setTitle:component % 2 == 0 ? [NSString stringWithFormat:@"%i", row] : [NSString stringWithFormat:@" .%i", row == 0 ? row : 5] forState:UIControlStateNormal];	
			break;
	}
	
	return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component 
{
	[self calculatePoints:pickerView];
	[self storePickerComponentSelections];	
	[self becomeFirstResponder];	
}

#pragma mark -
#pragma mark UIWebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(displayWebView) withObject:nil afterDelay:0.05];          
}

- (void)displayWebView
{
	// We need to initially set the webview to hidden to avoid the white background flicker	
	[webView setHidden:NO];
	[self displaySystem];
	[self calculatePoints:picker];
}

#pragma mark -
#pragma mark Shake method
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event 
{
	if ([event subtype] == UIEventSubtypeMotionShake) {
		[self reset];
	}
}

#pragma mark -
#pragma mark Actions
- (void)calculatePoints:(UIPickerView *)pickerView 
{
	CGFloat fat = [[NSString stringWithFormat:@"%i.%i", [pickerView selectedRowInComponent:0], [pickerView selectedRowInComponent:1]] floatValue];
	CGFloat carbs = [[NSString stringWithFormat:@"%i.%i", [pickerView selectedRowInComponent:2], [pickerView selectedRowInComponent:3]] floatValue];
	CGFloat fiber = [[NSString stringWithFormat:@"%i.%i", [pickerView selectedRowInComponent:4], [pickerView selectedRowInComponent:5]] floatValue];
	CGFloat protein = [[NSString stringWithFormat:@"%i.%i", [pickerView selectedRowInComponent:6], [pickerView selectedRowInComponent:7]] floatValue];
	CGFloat servings = 1.0;
	
	// Calculate the points according to: http://en.wikipedia.org/wiki/Weight_Watchers#.E2.80.9CPoints.E2.80.9D_formulas	
	NSInteger USPoints = (NSInteger)MAX(round((((16 * protein) + (19 * carbs) + (45 * fat)) - (14 * fiber)) / 175), 0);
	NSInteger UKPoints = (NSInteger)MAX(round((protein / 10.99) + (carbs / 9.17) + (fat / 3.89) + (fiber / 34.48)), 0);	
	points = [self shouldPerformActionBasedOnKey:@"SettingsField-2"] ? UKPoints : USPoints;
	
	if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
		[[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) {
		servings = [[NSString stringWithFormat:@"%i.%i", [pickerView selectedRowInComponent:8] + 1, [pickerView selectedRowInComponent:9] == 0 ? 0 : 5] floatValue];
		points = points	* servings;		
	}
	
	[self setServings:servings];	

	NSString *script = [NSString stringWithFormat:@"setValue('%i');", points];
	[webView stringByEvaluatingJavaScriptFromString:script];
	
	if (points != currentPoints) {
		// Prevents a cracking sound conflict with the picker sound
		[points >= currentPoints ? upSound : downSound performSelector:@selector(play) withObject:points >= currentPoints ? upSound : downSound afterDelay:0.1];
		currentPoints = points;
	}
}

- (void)reset
{
	[pickerComponentSelections removeAllObjects];
	
	for (int i = 0; i < [picker numberOfComponents]; i++) {
		[picker selectRow:0 inComponent:i animated:NO];
	}	
	
	points = currentPoints = 0;	
	[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setValue('%i')", points]];
	[resetSound performSelector:@selector(play) withObject:resetSound afterDelay:0.25];	
	
	[self calculatePoints:picker];
}

- (void)settingsViewControllerDidFinish:(SettingsViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
	[self displaySystem];
	[self calculatePoints:picker];
}

- (IBAction)displaySettings:(id)sender
{
	SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
	[controller setDelegate:self];
	[controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
	[self presentModalViewController:controller animated:YES];
	
	[controller release];	
}

- (void)displaySystem
{
	NSString *script = [NSString stringWithFormat:@"setUKSystem(%i)", [self shouldPerformActionBasedOnKey:@"SettingsField-2"]];
	[webView stringByEvaluatingJavaScriptFromString:script];	
}

- (void)setServings:(CGFloat)servings
{
	NSString *script = [NSString stringWithFormat:@"setServings(%f)", servings];
	[webView stringByEvaluatingJavaScriptFromString:script];	
}

- (void)storePickerComponentSelections
{
	[pickerComponentSelections removeAllObjects];
	
	for (int i = 0; i < [picker numberOfComponents]; i++) {
		if (i < 8) {
			[pickerComponentSelections insertObject:[NSNumber numberWithInt:[picker selectedRowInComponent:i]] atIndex:i];
		}
	}
}

- (void)updatePickerComponents
{
	for (int i = 0; i < [picker numberOfComponents]; i++) {
		if (i < [pickerComponentSelections count]) {
			[picker selectRow:[[pickerComponentSelections objectAtIndex:i] intValue] inComponent:i animated:NO];
		}
	}		
}

@end
