//
//  AppDelegate.h
//  TafelPoot
//
//  Created by Bob Van hees on 22-10-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

extern NSString *const FBSessionStateChangedNotification;
extern NSInteger FBLoggedIn;

- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI;

@end
