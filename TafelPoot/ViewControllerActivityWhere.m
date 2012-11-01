//
//  ViewControllerActivityWhere.m
//  TafelPoot
//
//  Created by Stan Janssen on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWhere.h"
#import "ViewControllerActivityWhen.h"
#import "Activity.h"

@interface ViewControllerActivityWhere ()
{
    Activity *activity;
}
@end

@implementation ViewControllerActivityWhere

@synthesize geocoder = _geocoder;
@synthesize streetField = _streetField, cityField = _cityField, fetchCoordinatesButton = _fetchCoordinatesButton;

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
    
    // If activity already exists, automaticly fill in the form
    if( [activity.address_city length] > 0 ) {
        self.cityField.text = activity.address_city;
    }
    if( [activity.address_street length] > 0 ) {
        self.streetField.text = activity.address_street;
    }
	
    //Make this controller the delegate for the map view.
    self.mapKit.delegate = self;
    
    // Ensure that you can view your own location in the map view.
    [self.mapKit setShowsUserLocation:YES];
    
    //Instantiate a location object.
    locationManager = [[CLLocationManager alloc] init];
    
    //Make this controller the delegate for the location manager.
    [locationManager setDelegate:self];
    
    //Set some parameters for the location object.
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
    
    
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setActivity:(Activity*)currentActivity
{
    activity = currentActivity;
}

- (NSMutableArray *) validateForm
{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    if( [self.streetField.text length] == 0 ) [errors addObject:@"Straat"];
    if( [self.cityField.text length] == 0 ) [errors addObject:@"Plaats"];
    
    return errors;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"toWhen"]) {
        
        NSMutableArray *errors = [self validateForm];
        BOOL segueShouldOccur = YES;
        
        if ( [errors count] > 0 ) {
            segueShouldOccur = NO;
        }
        
        NSString *errors_string = [errors componentsJoinedByString: @"\n"];
        NSString *message = [@"Het volgende veld is niet (correct) ingevuld: \n" stringByAppendingString:errors_string];
        
        // you determine this
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Niet alle velden zijn ingevuld"
                                         message: message
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    
    // by default perform the segue transition
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toWhen"])
    {
        activity.address_city = [self.cityField.text copy];
        activity.address_street = [self.streetField.text copy];
        
        ViewControllerActivityWhen *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    } else if ([[segue identifier] isEqualToString:@"toWhat"]) {
        activity.address_city = [self.cityField.text copy];
        activity.address_street = [self.streetField.text copy];
        
        ViewControllerActivityWhen *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}


- (IBAction)locationNow:(id)sender {
    
    
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    // Show Activity Indicator View
    //[self.activityIndicatorView startAnimating];
    
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // 100 m
    [locationManager startUpdatingLocation];
    
    //self.coordinatesLabel.text = [NSString stringWithFormat:@"%f, %f",  locationManager.location.coordinate.latitude, locationManager.location.coordinate.longitude];
    
    //Block address
    [self.geocoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error) {
         
         //Get address
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         
         NSLog(@"Placemark array: %@",placemark.addressDictionary );
         
         //String to address
         NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
         
         NSString *street = [placemark.addressDictionary valueForKey:@"Street"];
         NSString *city = [placemark.addressDictionary valueForKey:@"City"];
         
         //Print the location in the console
         NSLog(@"Currently address is: %@",locatedaddress);
         
         
         
         if( self.streetField.text == nil )
         {
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test Message"
                                                             message:@"This is a test"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
             [alert show];
         }
         else
         {
             self.streetField.text = [NSString stringWithFormat:@"%@", street];
             self.cityField.text = [NSString stringWithFormat:@"%@", city];
         }
         
     }];
    
    
    
    
    
    MKCoordinateRegion newRegion;
    newRegion.center.latitude =  locationManager.location.coordinate.latitude;
    newRegion.center.longitude = locationManager.location.coordinate.longitude;
    newRegion.span.latitudeDelta = 0.008388;
    newRegion.span.longitudeDelta = 0.016243;
    
    
    [self.mapKit setRegion:newRegion animated:YES];
    
    
    // ANNOTATION zetten :-)
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:locationManager.location.coordinate];
    [annotation setTitle:@"Test"];
    //[self.mapKit removeAnnotation:self.mapKit.annotations];
    
    for (int index = 0; index < [[[self mapKit] annotations] count]; index++) {
        if ([[[[self mapKit] annotations] objectAtIndex:index] isKindOfClass:[MKPointAnnotation class]]) {
            [[self mapKit] removeAnnotation:[[[self mapKit] annotations] objectAtIndex:index]];
        }
    }
    
    [self.mapKit addAnnotation:annotation];
    
    
    
    
    
    // Hide Activity Indicator View
    //[self.activityIndicatorView stopAnimating];
}

#pragma mark -
#pragma mark Actions
- (IBAction)fetchCoordinates:(id)sender {
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    
    // Make location string with default country; Netherlands
    NSString *address = [NSString stringWithFormat:@"%@ %@ Netherlands", self.streetField.text, self.cityField.text];
    
    // Disable Button
    self.fetchCoordinatesButton.hidden = YES;
    self.fetchCoordinatesButton.enabled = NO;
    
    // Show Activity Indicator View
    //[self.activityIndicatorView startAnimating];
    
    // Get geo code by address
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        // Placemark found? Go!
        if ([placemarks count] > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            CLLocation *location = placemark.location;
            CLLocationCoordinate2D coordinate = location.coordinate;
            
            
            // Get address
            
            [self.geocoder reverseGeocodeLocation: placemark.location completionHandler:
             ^(NSArray *placemarks, NSError *error) {
                 
                 //Get address
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 
                 NSLog(@"Placemark array: %@",placemark.addressDictionary );
                 
                 //String to address
                 NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
                 
                 //Print the location in the console
                 NSLog(@"Currently address is: %@",locatedaddress);
                 
                 
                 
             }];
            
            
            
            // Set coordinates label
            //self.coordinatesLabel.text = [NSString stringWithFormat:@"%f, %f", coordinate.latitude, coordinate.longitude];
            
            MKCoordinateRegion newRegion;
            newRegion.center.latitude = coordinate.latitude;
            newRegion.center.longitude = coordinate.longitude;
            newRegion.span.latitudeDelta = 0.008388;
            newRegion.span.longitudeDelta = 0.016243;
            
            [self.mapKit setRegion:newRegion animated:YES];
            
            
            // Set annotation
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            [annotation setCoordinate:coordinate];
            [annotation setTitle:@"Activiteit"];
            
            
            for (int index = 0; index < [[[self mapKit] annotations] count]; index++) {
                if ([[[[self mapKit] annotations] objectAtIndex:index] isKindOfClass:[MKPointAnnotation class]]) {
                    [[self mapKit] removeAnnotation:[[[self mapKit] annotations] objectAtIndex:index]];
                }
            }
            
            [self.mapKit addAnnotation:annotation];
            
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Helaas.."
                                                            message:@"Waarschijnlijk heb je het adres verkeerd ingevuld.."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Probeer opnieuw!"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        // Enable Button
        self.fetchCoordinatesButton.hidden = NO;
        self.fetchCoordinatesButton.enabled = YES;
        
        // Hide Activity Indicator View
        //[self.activityIndicatorView stopAnimating];
    }];
}

/*
 * A simple way to dismiss the message text view:
 * whenever the user clicks outside the view.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.streetField isFirstResponder] && (self.streetField != touch.view)) {
        [self.streetField resignFirstResponder];
    } else if ([self.cityField isFirstResponder] && (self.cityField != touch.view)) {
        [self.cityField resignFirstResponder];
    } else if ([self.fetchCoordinatesButton isFirstResponder] && (self.fetchCoordinatesButton != touch.view)) {
        [self.fetchCoordinatesButton resignFirstResponder];
    }
    
}

/*
 When push on the screen, get the coordinates from the MapView.
 After that, you
 */

- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if (!self.geocoder) {
            self.geocoder = [[CLGeocoder alloc] init];
        }
        
        // Get coordinates
        CLLocationCoordinate2D coordinate = [self.mapKit convertPoint:[gestureRecognizer locationInView:self.mapKit] toCoordinateFromView:self.mapKit];
        
        // Set place in the middle
        [self.mapKit setCenterCoordinate:coordinate animated:YES];
        
        // Set coordinates
        CLLocation *location = [[CLLocation alloc]
                                initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        
        // Get address by Geo codes
        [self.geocoder reverseGeocodeLocation: location completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             
             //Get address
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             
             NSLog(@"Placemark array: %@",placemark.addressDictionary );
             
             //String to address
             NSString *locatedaddress = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             
             //Print the location in the console
             NSLog(@"Currently address is: %@",locatedaddress);
             
             // Fill textfields with street and city
             NSString *street = [placemark.addressDictionary valueForKey:@"Street"];
             NSString *city = [placemark.addressDictionary valueForKey:@"City"];
             
             if( [street length] == 0 )
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Helaas.."
                                                                 message:@"Bij deze locatie is geen adres gevonden.. Maar je kunt wel verder!"
                                                                delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
             }
             else
             {
                 self.streetField.text = [NSString stringWithFormat:@"%@", street];
                 self.cityField.text = [NSString stringWithFormat:@"%@", city];
             }
             
             
         }];
        
        
        
        MKCoordinateRegion newRegion;
        newRegion.center.latitude =  coordinate.latitude;
        newRegion.center.longitude = coordinate.longitude;
        newRegion.span.latitudeDelta = 0.0025f;
        newRegion.span.longitudeDelta = 0.001f;
        
        
        [self.mapKit setRegion:newRegion  animated:YES];
        
        
        // ANNOTATION zetten :-)
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:coordinate];
        [annotation setTitle:@"Test"];
        
        for (int index = 0; index < [[[self mapKit] annotations] count]; index++) {
            if ([[[[self mapKit] annotations] objectAtIndex:index] isKindOfClass:[MKPointAnnotation class]]) {
                [[self mapKit] removeAnnotation:[[[self mapKit] annotations] objectAtIndex:index]];
            }
        }
        
        [self.mapKit addAnnotation:annotation];
        
        
        
        //self.coordinatesLabel.text = [NSString stringWithFormat:@"%f, %f",  coordinate.latitude, coordinate.longitude];
        
        // Do anything else with the coordinate as you see fit in your application
        
    }
}
@end
