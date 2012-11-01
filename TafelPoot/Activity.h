//
//  Activity.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Spelen,
    Muziek,
    Picknikken
} Category;

@interface Activity : NSObject {
    
}

@property (nonatomic, strong) NSString *activityName;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *tags;
@property (nonatomic, strong) NSString *activityDescription;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) double longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, strong) NSString *locationDescription;
@property (nonatomic, strong) NSURL *imagePath;

@end