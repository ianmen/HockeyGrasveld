//
//  ViewControllerActivityWhat.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;

@interface ViewControllerActivityWhat : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *category;
@property (strong, nonatomic) IBOutlet UITextField *tags;
@property (strong, nonatomic) IBOutlet UITextView *description;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)addPhoto:(id)sender;
@end
