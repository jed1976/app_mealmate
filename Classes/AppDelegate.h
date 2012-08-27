//
//  AppDelegate.h
//  MealMate
//
//  Created by Joseph Dakroub on 3/6/11.
//  Copyright 2011 Teacup Studio, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *mainViewController;

@end

