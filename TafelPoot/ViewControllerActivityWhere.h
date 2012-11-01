//
//  ViewControllerActivityWhere.h
//  TafelPoot
//
//  Created by Stan Janssen on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Activity;

@interface ViewControllerActivityWhere : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    
    CLGeocoder *_geocoder;
    
    __weak UITextField *_streetField;
    __weak UITextField *_cityField;
    __weak UIButton *_fetchCoordinatesButton;
}

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (strong, nonatomic) IBOutlet UITextField *activityAddress;

- (void)setActivity:(Activity*)currentActivity;
@property (weak, nonatomic) IBOutlet UITextField *streetField;
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UIButton *fetchCoordinatesButton;
@property (weak, nonatomic) IBOutlet UIButton *locationNowButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapKit;
- (IBAction)locationNow:(id)sender;
- (IBAction)fetchCoordinates:(id)sender;

@end
