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

@interface ViewControllerActivityWhat ()

@end

@implementation ViewControllerActivityWhat
{
    Activity *activity;
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
        
        ViewControllerActivityWhere *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}

@end
