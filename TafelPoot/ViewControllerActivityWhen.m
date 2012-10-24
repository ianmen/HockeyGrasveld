//
//  ViewControllerActivityWhen.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWhen.h"
#import "ViewControllerActivityWho.h"
#import "Activity.h"

@interface ViewControllerActivityWhen ()
{
    Activity *activity;
}
@end

@implementation ViewControllerActivityWhen

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toWho"])
    {
        activity.startTime = [self.startTime.text copy];
        activity.endTime = [self.endTime.text copy];
        activity.startDate = [self.date.date copy];
        
        ViewControllerActivityWho *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}
@end
