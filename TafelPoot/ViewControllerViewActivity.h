//
//  ViewControllerViewActivity.h
//  TafelPoot
//
//  Created by Stan Janssen on 08-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>
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

@property double longitude;
@property double latitude;

@end
