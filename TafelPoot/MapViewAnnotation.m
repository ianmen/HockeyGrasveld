//
//  MapViewAnnotation.m
//  TafelPoot
//
//  Created by Ime Pijnenborg on 12-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	title = ttl;
	coordinate = c2d;
	return self;
}

- (void)dealloc {

}

@end