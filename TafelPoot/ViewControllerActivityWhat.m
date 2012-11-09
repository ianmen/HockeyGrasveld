//
//  ViewControllerActivityWhat.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

//Framework import
#import <QuartzCore/QuartzCore.h>


#import "ViewControllerActivityWhat.h"
#import "ViewControllerActivityWhere.h"
#import "Activity.h"
#import "PhotoUploader.h"
#import "MBProgressHUD.h"
#import "ActivityCD.h"
#import "AppDelegate.h"

@interface ViewControllerActivityWhat ()

@end

@implementation ViewControllerActivityWhat
{
    Activity *activity;
    MBProgressHUD *hud;
    PhotoUploader *up;
    UIImage *imageDone;
    NSArray *categories;
}

@synthesize imageView;
@synthesize picker;
@synthesize accessoryView = _accessoryView;
@synthesize customInput = _customInput;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// naar boven schuiven annimatie
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideUpView:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideDownView:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)slideDownView:(NSNotification*)notification
{
	[[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[[notification userInfo] objectForKey:UIKeyboardWillShowNotification] getValue:&keyboardFrame];
    
	[UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurve
                     animations:^{
                         self.view.frame = CGRectMake(0, 0, 320, 480);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Slide down Done..!");
                     }];
}

-(void)slideUpView:(NSNotification*)notification
{
    [[[notification userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[[notification userInfo] objectForKey:UIKeyboardWillShowNotification] getValue:&keyboardFrame];
	
	[UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:animationCurve
                     animations:^{
                         self.view.frame = CGRectMake(0, -keyboardFrame.size.height - 55, 320, 416);
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Slide up Done..!");
                     }];
}

//categorie picker

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.category setDelegate: self];
    [self.description setDelegate: self];
    
    categories = [[NSArray alloc] initWithObjects: @"", @"Muziek", @"Sport", @"Eten", @"Reizen", @"Games", @"Kunst en Cultuur", @"Natuur en Milieu", @"Gezondheid en Uiterlijk", @"Bouwen en Ondernemen", @"Uitgaan en Evenementen", @"Foto en Film", @"Boeken", @"Dieren", nil];

    
    // If activity already exists, automaticly fill in the form
    if( [activity.activityName length] > 0 ) {
        self.name.text = activity.activityName;
        self.category.text = activity.category;
        self.tags.text = activity.tags;
        self.description.text = activity.activityDescription;
    } else {
        activity = [[Activity alloc] init];
    }
    
   }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    
    if ([self.name isFirstResponder] && (self.name != touch.view)) {
        [self.name resignFirstResponder];
    } else if ([self.category isFirstResponder] && (self.category != touch.view)) {
        [self.category resignFirstResponder];
    } else if ([self.tags isFirstResponder] && (self.tags != touch.view)) {
        [self.tags resignFirstResponder];
    } else if ([self.description isFirstResponder] && (self.description != touch.view)) {
        [self.description resignFirstResponder];
    }
}

- (void)setActivity:(Activity*)currentActivity
{
    activity = currentActivity;
}

- (NSMutableArray *) validateForm
{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    NSString *placeholder = @"Beschrijving";
    
    if( [self.name.text length] == 0 ) [errors addObject:@"Naam"];
    if( [self.category.text length] == 0 ) [errors addObject:@"Categorie"];
    if( [self.tags.text length] == 0 ) [errors addObject:@"Tags"];
    if( [self.description.text length] == 0 ) {
        [errors addObject:@"Beschrijving"];
    } else if( [self.description.text isEqualToString: placeholder] ) {
        [errors addObject:@"Beschrijving"];
    }
    
    return errors;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    if ([identifier isEqualToString:@"toWhere"]) {
        
        NSMutableArray *errors = [self validateForm];
        BOOL segueShouldOccur = YES;
        
        if ( [errors count] > 0 ) {
            segueShouldOccur = NO;
        }
        
        NSString *errors_string = [errors componentsJoinedByString: @"\n"];
        NSString *message = [@"De volgende velden zijn niet (correct) ingevuld: \n" stringByAppendingString:errors_string];
        
        // you determine this
        if (!segueShouldOccur) {
            UIAlertView *notPermitted = [[UIAlertView alloc]
                                         initWithTitle:@"Niet alle velden zijn ingevuld"
                                         message: message
                                         delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            // shows alert to user
            [notPermitted show];
            
            // prevent segue from occurring
            return NO;
        }
    }
    


    
    // by default perform the segue transition
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toWhere"])
    {
        NSURL *imagePath = [[NSURL alloc] init];
        imagePath = [up.url copy];

        activity.activityName = [self.name.text copy];
        activity.category = [self.category.text copy];
        activity.tags = [self.tags.text copy];
        activity.activityDescription = [self.description.text copy];
        activity.imagePath = imagePath;

        ViewControllerActivityWhere *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
        
  }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //Did finisch picking the media
    //Save the image
    UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    
    //activity
    
    //Remove the view from the screen
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //Create an new object for the image uploader
    up = [[PhotoUploader alloc] init];
    
    //Load the spinner
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Uploaden";
    
    //Start the notifications
    //Set the notification for finisch
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadingDone) name:@"photoUploadDone" object:nil];
    
    //Set the notification for error
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadingError) name:@"photoUploadError" object:nil];
    
    //Start the upload
    [up uploadPhoto:image];
    
    //Save the image
    imageDone = image;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //Did cancel the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)selectCategoryFromPicker:(id)sender {
    [self.pickerView setHidden:YES];
    UIImage *icon;
    
    if ( [self.category.text isEqualToString: @"Muziek"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_music.png"];
    } else if ( [self.category.text isEqualToString: @"Sport"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_sport.png"];
    } else if ( [self.category.text isEqualToString: @"Eten"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_food.png"];
    } else if ( [self.category.text isEqualToString: @"Reizen"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_travel.png"];
    } else if ( [self.category.text isEqualToString: @"Games"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_games.png"];
    } else if ( [self.category.text isEqualToString: @"Kunst en Cultuur"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_culture.png"];
    } else if ( [self.category.text isEqualToString: @"Natuur en Milieu"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_nature.png"];
    } else if ( [self.category.text isEqualToString: @"Gezondheid en Uiterlijk"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_health.png"];
    } else if ( [self.category.text isEqualToString: @"Bouwen en Ondernemen"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_building.png"];
    } else if ( [self.category.text isEqualToString: @"Uitgaan en Evenementen"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_events.png"];
    } else if ( [self.category.text isEqualToString: @"Foto en Film"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_photo.png"];
    } else if ( [self.category.text isEqualToString: @"Boeken"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_books.png"];
    } else if ( [self.category.text isEqualToString: @"Dieren"] ) {
        icon = [UIImage imageNamed:@"categoryIcon_animals.png"];
    }  else {
        icon = [UIImage imageNamed:@"categoryIcon_unknown.png"];
    }
    
    
    
    [self.category_icon setImage:icon];
}

- (IBAction)addPhoto:(id)sender {
    
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Kies uw bron" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Foto library",@"Foto camera", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    //[controller presentModalViewController: cameraUI animated: YES];
    return YES;
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
        UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
        mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        // Displays saved pictures and movies, if both are available, from the
        // Camera Roll album.
        mediaUI.mediaTypes =
        [UIImagePickerController availableMediaTypesForSourceType:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        // Hides the controls for moving & scaling pictures, or for
        // trimming movies. To instead show the controls, use YES.
        mediaUI.allowsEditing = NO;
        
        mediaUI.delegate = (id)self;
        
        [self presentViewController: mediaUI animated:YES completion:nil];
	} else if (buttonIndex == 1) {
		
        //Display the camera capture tool
        [self startCameraControllerFromViewController: self
                                        usingDelegate: (id)self];
    }
    
}

-(void)uploadingDone{
    
    //The uploading of the photo is done
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = @"Voltooid";
    
    //Save the url of the image
    //NSLog(@"%@",up.url);
    
    //Remove the spinner after a  delay
    [hud hide:YES afterDelay:2];

    //Set the rounded corners of the image
    imageView.layer.cornerRadius = 10.0f;
    imageView.layer.masksToBounds = YES;
    
    //Set a border color of the image
    imageView.layer.borderWidth = 2.0;
    imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    
    //Set the image on the location of the upload
    imageView.image = imageDone ;
    
    
}

-(void)uploadingError{
    
    //The uploading did not finisch, got an error.
    
    //Set the text
    hud.labelText = @"Error, probeer opnieuw";
    
    //remove the spinner from the view
    [hud hide:YES afterDelay:4];
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.name resignFirstResponder];
    [self.tags resignFirstResponder];
    [self.description resignFirstResponder];
    
    //If textfield is Category
    if( textField.tag == 2 ) {
        [self.pickerView setHidden: NO];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        
        self.category.inputAccessoryView = toolbar;
        
        
        return NO;
    } 
    
    return YES;
    
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *placeholder = @"Beschrijving";
    
    if( [self.description.text isEqualToString: placeholder] ) {
        self.description.text = @"";
        self.description.textColor = [UIColor blackColor];
    }    
    
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    if(self.description.text.length == 0){
        self.description.textColor = [UIColor lightGrayColor];
        self.description.text = @"Beschrijving";
        [self.description resignFirstResponder];
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return categories.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    return [categories objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.category.text = [categories objectAtIndex:row];
}




@end
