//
//  ViewControllerActivityWhat.h
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Activity;
@class UIAlertView;

// Naar boven schuiven annimatie
NSTimeInterval animationDuration;
UIViewAnimationCurve animationCurve;
CGRect keyboardFrame;


@interface ViewControllerActivityWhat : UIViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate> {
    UIView *inputAccView;
    UIButton *btnDone;
    
}




@property (strong, nonatomic) IBOutlet UITextField *name;
@property (strong, nonatomic) IBOutlet UITextField *category;
@property (strong, nonatomic) IBOutlet UITextField *tags;
@property (strong, nonatomic) IBOutlet UITextView *description;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (nonatomic, retain) IBOutlet UIToolbar *accessoryView;
@property (nonatomic, retain) IBOutlet UIDatePicker *customInput;
@property (strong, nonatomic) IBOutlet UIView *pickerView;
@property (strong, nonatomic) IBOutlet UIImageView *category_icon;
- (IBAction)selectCategoryFromPicker:(id)sender;

- (IBAction)addPhoto:(id)sender;
- (IBAction)photoDone:(id)sender;

@end
