//
//  ViewControllerActivityWho.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnection.h"

@class Activity;

@interface ViewControllerActivityWho : UIViewController<ServerConnectionDelegate>


@property (strong, nonatomic) IBOutlet UIImageView *imagePreview;
@property (strong, nonatomic) IBOutlet UILabel *activity;
@property (strong, nonatomic) IBOutlet UILabel *category;
@property (strong, nonatomic) IBOutlet UILabel *tags;
@property (strong, nonatomic) IBOutlet UILabel *location;
@property (strong, nonatomic) IBOutlet UITextView *description;
@property (strong, nonatomic) IBOutlet UILabel *startDate;
@property (strong, nonatomic) IBOutlet UILabel *endDate;
@property (strong, nonatomic) IBOutlet UILabel *xmlStatusResponse;

- (IBAction)finished:(id)sender;
- (void)setActivity:(Activity*)currentActivity;
- (IBAction)shareButton:(id)sender;

@end
