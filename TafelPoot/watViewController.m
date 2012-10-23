//
//  watViewController.m
//  TafelPoot
//
//  Created by Bob Van hees on 22-10-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "watViewController.h"
#import "PhotoUploader.h"
#import "MBProgressHUD.h"

@interface watViewController ()

@end

@implementation watViewController{
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testImage:(id)sender {
    
    //Create an new object for the image uploader
    up = [[PhotoUploader alloc] init];

    //==== TEMP ====
    //Load in a image
    NSURL *url = [NSURL URLWithString:@"http://aeroclubsalland.nl/_img/nieuws/2008/mooi-weer.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
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

-(void)uploadingDone{
    
    //The uploading of the photo is done
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	hud.mode = MBProgressHUDModeCustomView;
	hud.labelText = @"Voltooid";
    
    //Save the url of the image

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
