//
//  ViewControllerActivityMap.h
//  TafelPoot
//
//  Created by Mark on 12/11/2012.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ActivityAnnotation.h"

@interface ViewControllerActivityMap : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end
