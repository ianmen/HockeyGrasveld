//
//  ViewControllerViewActivity.m
//  TafelPoot
//
//  Created by Stan Janssen on 08-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerViewActivity.h"
#import "ActivityCD.h"
#import "MapViewAnnotation.h"

@interface ViewControllerViewActivity ()
{
    ActivityCD *activity;
}

@end

@implementation ViewControllerViewActivity

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lbl_activityName.text = activity.activityName;
    self.textview_activityDescription.text = activity.activityDescription;
    NSString *locationString = [NSString stringWithFormat:@"%@, %@", activity.address_street, activity.address_city];
    self.textview_activityLocation.text = locationString;

    NSString *startDate_string = [NSDateFormatter localizedStringFromDate:activity.startDate
                                                                dateStyle: NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterShortStyle];
    
    
    
    NSString *endDate_string = [NSDateFormatter localizedStringFromDate:activity.endDate
                                                                dateStyle:NSDateFormatterShortStyle
                                                                timeStyle:NSDateFormatterShortStyle];

    self.textview_activityBeginTime.text = startDate_string;
    self.textview_activityEndTime.text = endDate_string;
    
    NSURL *img_url = [NSURL URLWithString:activity.imagePath];
    NSData *img_data = [NSData dataWithContentsOfURL:img_url];
    UIImage *image = [[UIImage alloc] initWithData: img_data];
    
    [self.img_activityImage setImage:image];
}

- (IBAction)showActivityLocation:(id)sender {
    NSString *imageName = [NSString stringWithFormat:@"backgroundRaadplegen_locatie@2x.png"];
    self.img_activityBackground.image = [UIImage imageNamed:imageName];
    
    [self.lbl_activityName setHidden:YES];
    [self.img_activityImage setHidden:YES];
    [self.textview_activityBeginTime setHidden:YES];
    [self.textview_activityEndTime setHidden:YES];
    [self.textview_activityLocation setHidden:YES];
    [self.textview_activityDescription setHidden:YES];
    [self.img_beginTimeIcon setHidden: YES];
    [self.img_endTimeIcon setHidden: YES];
    [self.mapview_activityLocation setHidden: NO];
    self.mapview_activityLocation.showsUserLocation = YES;
    
    CLLocationCoordinate2D location;
	location.latitude = [activity.longitude doubleValue];
	location.longitude = [activity.latitude doubleValue];
    

    
	// Add the annotation to our map view
	MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:activity.activityName andCoordinate:location];
	[self.mapview_activityLocation addAnnotation:newAnnotation];    
}

- (IBAction)showActivitySummary:(id)sender {
    NSString *imageName = [NSString stringWithFormat:@"backgroundRaadplegen_overzicht@2x.png"];
    self.img_activityBackground.image = [UIImage imageNamed:imageName];
    
    [self.lbl_activityName setHidden:NO];
    [self.img_activityImage setHidden:NO];
    [self.textview_activityBeginTime setHidden:NO];
    [self.textview_activityEndTime setHidden:NO];
    [self.textview_activityLocation setHidden:NO];
    [self.textview_activityDescription setHidden:NO];
    [self.img_beginTimeIcon setHidden: NO];
    [self.img_endTimeIcon setHidden: NO];
    [self.mapview_activityLocation setHidden: YES];
}

- (void)setActivity:(ActivityCD *)currentActivity
{
    activity = currentActivity;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

@end



/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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