//
//  ServerConnection.h
//  TafelPoot
//
//  Created by Jeffrey on 10/24/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Activity;

@protocol ServerConnectionDelegate <NSObject>

-(void) serverResponse;

@end

@interface ServerConnection : NSObject

@property (nonatomic,assign) id<ServerConnectionDelegate> delegate;

@property int responseCode;

@property (nonatomic,strong) NSString *responseString;

@property (nonatomic,strong) NSString *responseStatus;

@property (nonatomic,strong) NSData *responseData;

-(void)xmlPostActivity:(Activity*)activity;

-(void)loadActivities;


@end
