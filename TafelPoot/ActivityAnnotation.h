//
//  ActivityAnnotation.h
//  TafelPoot
//
//  Created by Mark on 12/11/2012.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ActivityAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString* title;
	NSString* subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* subtitle;

@end
