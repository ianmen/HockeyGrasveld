//
//  ViewControllerActivityWhat.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWhat.h"
#import "ViewControllerActivityWhere.h"
#import "Activity.h"
#import "PhotoUploader.h"
#import "MBProgressHUD.h"


@interface ViewControllerActivityWhat ()

@end

@implementation ViewControllerActivityWhat
{
    Activity *activity;
    MBProgressHUD *hud;
    PhotoUploader *up;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    activity = [[Activity alloc] init];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toWhere"])
    {
        activity.activityName = [self.name.text copy];
        activity.category = [self.category.text copy];
        activity.tags = [self.tags.text copy];
        activity.activityDescription = [self.description.text copy];
        activity.imagePath = [up.url copy];

        ViewControllerActivityWhere *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //Did finisch picking the media
    //Save the image
    UIImage *image = (UIImage *) [info objectForKey: UIImagePickerControllerOriginalImage];
    
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
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    //Did cancel the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    
}

-(void)uploadingError{
    
    //The uploading did not finisch, got an error.
    
    //Set the text
    hud.labelText = @"Error, probeer opnieuw";
    
    //remove the spinner from the view
    [hud hide:YES afterDelay:4];
}

@end
