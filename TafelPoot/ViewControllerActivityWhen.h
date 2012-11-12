//
//  ViewControllerActivityWhen.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface ViewControllerActivityWhen : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) Activity *activity;

- (IBAction)beginTijd:(id)sender;
- (IBAction)eindTijd:(id)sender;

- (IBAction)back:(id)sender;

- (void)setActivity:(Activity*)currentActivity;

@end
