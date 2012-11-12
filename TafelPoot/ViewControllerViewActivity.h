//
//  ViewControllerViewActivity.h
//  TafelPoot
//
//  Created by Stan Janssen on 08-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ActivityCD.h"
//#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>

@class Activity;

@interface ViewControllerViewActivity : UIViewController
{
    double longitude;
    double latitude;
}

//@property (weak, nonatomic) IBOutlet UITextField *streetField;
//@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (strong, nonatomic) IBOutlet UILabel *lbl_activityName;
@property (strong, nonatomic) IBOutlet UITextView *textview_activityDescription;
@property (strong, nonatomic) IBOutlet UITextView *textview_activityLocation;

@property (strong, nonatomic) IBOutlet UITextView *textview_activityBeginTime;
@property (strong, nonatomic) IBOutlet UITextView *textview_activityEndTime;

@property (strong, nonatomic) IBOutlet UIImageView *img_activityImage;

- (void)setActivity:(ActivityCD *)currentActivity;

//@property double longitude;
//@property double latitude;

@end
