//
//  ViewControllerActivityWhere.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface ViewControllerActivityWhere : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *activityAddress;

- (void)setActivity:(Activity*)currentActivity;

@end
