//
//  ViewControllerActivityWhere.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWhere.h"
#import "ViewControllerActivityWhen.h"
#import "Activity.h"

@interface ViewControllerActivityWhere ()
{
    Activity *activity;
}
@end

@implementation ViewControllerActivityWhere


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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"toWhen"])
    {
        activity.address = [self.activityAddress.text copy];
        
        ViewControllerActivityWhen *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}


- (IBAction)locationNow:(id)sender {
}

- (IBAction)fetchCoordinates:(id)sender {
}
@end
