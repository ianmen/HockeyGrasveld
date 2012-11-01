//
//  FacebookViewController.m
//  XMLLijst
//
//  Created by Jochem Rommens on 04-10-12.
//  Copyright (c) 2012 Jochem Rommens. All rights reserved.
//

#import "FacebookViewController.h"
#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *postMessageTextView;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postCaptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *postDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *loginFBOutlet;

@end

NSString *const kPlaceholderPostMessage = @"Ik heb net de activiteit \"...\" toegevoegd in BredApp! Check het op de Facebookpagina: https://www.facebook.com/pages/Testpagina";

@implementation FacebookViewController

@synthesize postParams = _postParams;
@synthesize imageData = _imageData;
@synthesize imageConnection = _imageConnection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"https://developers.facebook.com/ios", @"link",
     @"https://developers.facebook.com/attachment/iossdk_logo.png", @"picture",
     @"BredApp", @"name",
     @"Creëer, Vind en Deel activiteiten!", @"caption",
     @"In de gemeente Breda.", @"description",
     //@"Ik heb net de activiteit \"...\" toegevoegd in BredApp! Check het op de Facebookpagina: https://www.facebook.com/pages/Testpagina", @"message",
     nil];
    
	// Do any additional setup after loading the view.
    
    // Show placeholder text
    [self resetPostMessage];
    // Set up the post information, hard-coded for this sample
    self.postNameLabel.text = [self.postParams objectForKey:@"name"];
    self.postCaptionLabel.text = [self.postParams objectForKey:@"caption"];
    [self.postCaptionLabel sizeToFit];
    self.postDescriptionLabel.text = [self.postParams objectForKey:@"description"];
    [self.postDescriptionLabel sizeToFit];
    
    // Kick off loading of image data asynchronously so as not
    // to block the UI.
    self.imageData = [[NSMutableData alloc] init];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL: [NSURL URLWithString: @"https://developers.facebook.com/attachment/iossdk_logo.png"]];
    self.imageConnection = [[NSURLConnection alloc] initWithRequest: imageRequest delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetPostMessage
{
    self.postMessageTextView.text = kPlaceholderPostMessage;
    self.postMessageTextView.textColor = [UIColor blackColor];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    // Clear the message text when the user starts editing
    if ([textView.text isEqualToString:kPlaceholderPostMessage]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    // Reset to placeholder text if the user is done editing and no message has been entered.
    if ([textView.text isEqualToString:@""]) {
        [self resetPostMessage];
    }
}

/*
 * A simple way to dismiss the message text view:
 * whenever the user clicks outside the view.
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.postMessageTextView isFirstResponder] && (self.postMessageTextView != touch.view))
    {
        [self.postMessageTextView resignFirstResponder];
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data{
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    self.postImageView.image = [UIImage imageWithData: [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

- (IBAction)cancelButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareButtonAction:(id)sender {
    // Hide keyboard if showing when button clicked
    if ([self.postMessageTextView isFirstResponder]) {
        [self.postMessageTextView resignFirstResponder];
    }
    // Add user message parameter if user filled it in
    if (![self.postMessageTextView.text isEqualToString:@""]) {
        [self.postParams setObject:self.postMessageTextView.text forKey:@"message"];
    }
    
    // Ask for publish_actions permissions in context
    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
        // No permissions found in session, ask for it
        [FBSession.activeSession reauthorizeWithPublishPermissions: [NSArray arrayWithObject:@"publish_actions"] defaultAudience:FBSessionDefaultAudienceFriends completionHandler:^(FBSession *session, NSError *error) {
             if (!error) {
                 NSLog(@"Geen Error tot nu");
                 // If permissions granted, publish the story
                 [self publishStory];
             }
         }];
    } else {
        NSLog(@"hier ook niet");
        // If permissions present, publish the story
        [self publishStory];
    }
}

- (IBAction)logIn:(id)sender {
    
}

- (void)viewDidUnload {
    [self setPostMessageTextView:nil];
    [self setPostImageView:nil];
    [self setPostNameLabel:nil];
    [self setPostCaptionLabel:nil];
    [self setPostDescriptionLabel:nil];
    [self setLoginFBOutlet:nil];
    [super viewDidUnload];
    
    if (self.imageConnection) {
        [self.imageConnection cancel];
        self.imageConnection = nil;
    }
}

- (void)publishStory
{
    [FBRequestConnection startWithGraphPath:@"me/feed" parameters:self.postParams HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat: @"error: domain = %@, code = %d", error.domain, error.code];
         } else {
             alertText = [NSString stringWithFormat: @"Posted action, id: %@", [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result" message:alertText delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil]
          show];
     }];
}

- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
