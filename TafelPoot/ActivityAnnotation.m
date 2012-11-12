//
//  ActivityAnnotation.m
//  TafelPoot
//
//  Created by Mark on 12/11/2012.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ActivityAnnotation.h"

@implementation ActivityAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (void)dealloc
{
	self.title = nil;
	self.subtitle = nil;
}

@end
