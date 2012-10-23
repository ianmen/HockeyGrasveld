//
//  PhotoUploader.h
//  TafelPoot
//
//  Created by Bob Van hees on 22-10-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoUploader : NSObject

- (void)uploadPhoto:(UIImage *)image;
- (UIImage *)centerAndResizeImage:(UIImage *)theImage toBounds:(CGRect)bounds;

@property(nonatomic,strong) NSURL *url;
@end
