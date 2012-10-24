//
//  ViewControllerActivityWho.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWho.h"
#import "Activity.h"
#import "ServerConnection.h"

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

- (IBAction)finished:(id)sender
{
   serverConn = [[ServerConnection alloc] init];

    [serverConn xmlPostActivity:activity];
}
@end
