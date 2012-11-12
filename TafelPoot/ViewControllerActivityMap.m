//
//  ViewControllerActivityMap.m
//  TafelPoot
//
//  Created by Mark on 12/11/2012.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityMap.h"
#import "AppDelegate.h"
#import "ActivityCD.h"

@interface ViewControllerActivityMap ()

@end

@implementation ViewControllerActivityMap

@synthesize mapView;

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
	// Do any additional setup after loading the view.
    
    //Get the DB connection
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //Sett the entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ActivityCD" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    //Time to update each item on the distance
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

	mapView.delegate=self;
    
    NSMutableArray* annotations=[[NSMutableArray alloc] init];
    
    CLLocationCoordinate2D theCoordinate;
    ActivityAnnotation *activityAnnotation;
    
    for(ActivityCD *aCD in fetchedObjects){
        theCoordinate.latitude = [aCD.latitude doubleValue];
        theCoordinate.longitude = [aCD.longitude doubleValue];
        
        activityAnnotation = [[ActivityAnnotation alloc] init];
        activityAnnotation.coordinate = theCoordinate;
        activityAnnotation.title = aCD.activityName;
        activityAnnotation.subtitle = aCD.activityDescription;
        
        [mapView addAnnotation:activityAnnotation];
        
        [annotations addObject:activityAnnotation];
    }
    
    // Append this code at the end of viewDidLoad method to concentratet the Map
    // Walk the list of overlays and annotations and create a MKMapRect that
    // bounds all of them and store it into flyTo.
    MKMapRect flyTo = MKMapRectNull;
	for (id <MKAnnotation> annotation in annotations) {
		NSLog(@"fly to on");
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(flyTo)) {
            flyTo = pointRect;
        } else {
            flyTo = MKMapRectUnion(flyTo, pointRect);
        }
    }
    
    // Position the map so that all overlays and annotations are visible on screen.
    mapView.visibleMapRect = flyTo;
}

#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
	NSLog(@"welcome into the map view annotation");
	
	// if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
	// try to dequeue an existing pin view first
	static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
	MKPinAnnotationView* pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationIdentifier];
	pinView.animatesDrop=YES;
	pinView.canShowCallout=YES;
	pinView.pinColor=MKPinAnnotationColorPurple;
	
	
	UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[rightButton setTitle:annotation.title forState:UIControlStateNormal];
	[rightButton addTarget:self
					action:@selector(showDetails:)
		  forControlEvents:UIControlEventTouchUpInside];
	pinView.rightCalloutAccessoryView = rightButton;
	
	UIImageView *profileIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"profile.png"]];
	pinView.leftCalloutAccessoryView = profileIconView;
	
	return pinView;
}

-(IBAction)showDetails:(id)sender{
	NSLog(@"Annotation Click");
	//self.userProfileVC.title=((UIButton*)sender).currentTitle;
	//[self.navigationController pushViewController:self.userProfileVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
