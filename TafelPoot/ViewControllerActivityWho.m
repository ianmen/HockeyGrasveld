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

@interface ViewControllerActivityWho ()
{
    Activity *activity;
    ServerConnection *serverConn;
}
@end

@implementation ViewControllerActivityWho

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
    
    serverConn.delegate = self;
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

-(void)serverResponse {
    self.xmlStatusResponse.text = [NSString stringWithFormat:@"Response code: %d (%@)", serverConn.responseCode, serverConn.responseStatus];
    
    self.xmlResponseMsg.text = serverConn.responseString;
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
   serverConn = [[ServerConnection alloc] init];

    [serverConn xmlPostActivity:activity];
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
