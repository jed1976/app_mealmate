//
//  RootViewController.h
//  MealMate
//
//  Created by Joseph Dakroub on 3/6/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import "SettingsViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ViewController.h"

@interface RootViewController : ViewController <SettingsViewControllerDelegate, UIPickerViewDelegate> 
{
	IBOutlet UIButton *infoButton;
	IBOutlet UIImageView *overlay;
	IBOutlet UIPickerView *picker;
	IBOutlet UIWebView *webView;
	AVAudioPlayer *downSound;
	AVAudioPlayer *upSound;	
	AVAudioPlayer *resetSound;	
}

- (IBAction)displaySettings:(id)sender;

@property (nonatomic, retain) IBOutlet UIImageView *overlay;
@property (nonatomic, retain) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) AVAudioPlayer *downSound;
@property (nonatomic, retain) AVAudioPlayer *upSound;
@property (nonatomic, retain) AVAudioPlayer *resetSound;

@end
