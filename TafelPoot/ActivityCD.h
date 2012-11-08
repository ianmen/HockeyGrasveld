//
//  AcitivyCD.h
//  TafelPoot
//
//  Created by Bob Van hees on 07-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ActivityCD : NSManagedObject

@property (nonatomic, retain) NSNumber * uID;
@property (nonatomic, retain) NSString * activityName;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * activityDescription;
@property (nonatomic, retain) NSString * startTime;
@property (nonatomic, retain) NSString * endTime;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSString * address_city;
@property (nonatomic, retain) NSString * address_street;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationDescription;
@property (nonatomic, retain) NSString * imagePath;

@end
