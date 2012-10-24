//
//  ViewControllerActivityWho.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface ViewControllerActivityWho : UIViewController

- (IBAction)finished:(id)sender;
- (void)setActivity:(Activity*)currentActivity;

@end
