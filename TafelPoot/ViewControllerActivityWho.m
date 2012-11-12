//
//  ViewControllerActivityWho.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWho.h"
#import "ViewControllerActivityWhen.h"
#import "Activity.h"
#import "Twitter/TWTweetComposeViewController.h"
#import "FacebookViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/CALayer.h>

@interface ViewControllerActivityWho ()
{
    //Activity *activity;
    ServerConnection *serverConn;
    MBProgressHUD *hud;
}
@end

@implementation ViewControllerActivityWho

@synthesize activity;

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
    
    
    serverConn = [[ServerConnection alloc] init];
    
    self.imagePreview.layer.masksToBounds = YES;
    self.imagePreview.layer.borderColor = [UIColor redColor].CGColor;
    self.imagePreview.layer.borderWidth = 2;
    
    self.activityName.text = [activity.activityName copy];
    self.category.text = [activity.category copy];
    self.tags.text = [activity.tags copy];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM yyyy"];
    
    NSDateFormatter *timeFormatter=[[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];

    self.startDate.text = [NSString stringWithFormat:@"%@, %@", [dateFormatter stringFromDate:activity.startDate],[timeFormatter stringFromDate:activity.startDate]];
    self.endDate.text = [NSString stringWithFormat:@"%@, %@", [dateFormatter stringFromDate:activity.endDate],[timeFormatter stringFromDate:activity.endDate]];
    self.location.text = [NSString stringWithFormat:@"%@, %@", activity.address_street, activity.address_city];
    [self.imagePreview setImage:activity.image];
    
    serverConn.delegate = self;
    
    if (activity.image == nil)
    {
        self.imagePreview.image = [UIImage imageNamed:@"no_image"];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
	{
        Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
        
        if(tweeterClass != nil) {   // check for Twitter integration
            
            // check Twitter accessibility and at least one account is setup
            if([TWTweetComposeViewController canSendTweet]) {
                
                TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
                // set initial text
                [tweetViewController setInitialText:@"Ik heb net de activiteit \"...\" toegevoegd in BredApp! Check het in de Bredapp op je iPhone."];
                
                [self presentViewController:tweetViewController animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure you have at least one Twitter account setup and your device is using iOS5 or iOS6" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You must upgrade to iOS5.0 or 6.0 in order to send tweets from this application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if (buttonIndex == 1)
	{
        if (FBLoggedIn == 0)
        {
            NSLog(@"Nog niet ingelogd!");
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            // The user has initiated a login, so call the openSession method
            // and show the login UX if necessary.
            [appDelegate openSessionWithAllowLoginUI:YES];
            //if (FBLoggedIn == 1)
            //{
            [self performSegueWithIdentifier:@"gotoFB" sender:self];
            NSLog(@"FB!");
            //}
        }
        else if (FBLoggedIn == 1)
        {
            NSLog(@"Ingelogd!");
            [self performSegueWithIdentifier:@"gotoFB" sender:self];
            NSLog(@"FB!");
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setActivity:(Activity*)currentActivity
{
    activity = currentActivity;
}

- (IBAction)shareButton:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Delen" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Twitter", @"Facebook", @"Cancel", nil];
    [actionSheet showInView:self.view];
}

-(void)serverResponse {
    if (serverConn.responseCode == 200)
    {
        [self postingDone];
    } else {
        [self postingFailed];
    }
    
    self.xmlStatusResponse.text = [NSString stringWithFormat:@"Response code: %d (%@)", serverConn.responseCode, serverConn.responseStatus];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toWhen"])
    {   
        ViewControllerActivityWhen *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}

- (IBAction)finished:(id)sender
{
    //Load the spinner
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Toevoegen";

    [serverConn xmlPostActivity:activity];
}

-(void)postingDone
{
    //The posting of the activity is done
	hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] ;
	hud.labelText = @"Toegevoegd";
    
    //Remove the spinner after a  delay
    [hud hide:YES afterDelay:2];
}

-(void)postingFailed
{
    //The posting of the activity is done
	hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Cross.png"]] ;
	hud.labelText = @"Mislukt";
    
    //Remove the spinner after a  delay
    [hud hide:YES afterDelay:2];
}



//-(void)serverResponse {
//    self.xmlStatusResponse.text = [NSString stringWithFormat:@"Response code: %d (%@)", serverConn.responseCode, serverConn.responseStatus];
//    
//    self.xmlResponseMsg.text = serverConn.responseString;
//}
//
//- (IBAction)finished:(id)sender
//{
//   serverConn = [[ServerConnection alloc] init];
//
//    [serverConn xmlPostActivity:activity];
//}
@end
