//
//  ViewControllerViewActivity.m
//  TafelPoot
//
//  Created by Stan Janssen on 08-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerViewActivity.h"

@interface ViewControllerViewActivity ()
{
    
}

@end

/*@implementation ViewControllerViewActivity


@end

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 51.5875;
    newRegion.center.longitude = 4.775;
    newRegion.span.latitudeDelta = 0.1f;
    newRegion.span.longitudeDelta = 0.1f;
    
    [self.mapKit setRegion:newRegion animated:YES];
    
    
    
    
    
    // Set gesture; long press
    UILongPressGestureRecognizer* lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    // Minimum press duration
    lpgr.minimumPressDuration = 1.5;
    
    // Add the gesture to the mapKit
    [self.mapKit addGestureRecognizer:lpgr];
    
    
}



- (void)viewDidUnload {
    [self setMapKit:nil];
    [super viewDidUnload];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toMap"])
    {
        
        activity.address_city = activityCD.address_city;
        activity.address_street = activityCD.address_street;
        
        activity.longitude = activityCD.longitude;
        activity.latitude = activityCD.latitude;
        
        ViewControllerActivityWhere *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
        
    }
}*/