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
    
    // If activity already exists, automaticly fill in the form
    if( [activity.startTime length] > 0 ) {
        self.startTime.text = activity.startTime;
    }
    if( [activity.endTime length] > 0 ) {
        self.endTime.text = activity.endTime;
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


- (NSMutableArray *) validateForm
{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    if( [self.startTime.text length] == 0 ) [errors addObject:@"Begintijd"];
    if( [self.endTime.text length] == 0 ) [errors addObject:@"Eindtijd"];
    
    return errors;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"toWho"]) {
        
        NSMutableArray *errors = [self validateForm];
        BOOL segueShouldOccur = YES;
        
        if ( [errors count] > 0 ) {
            segueShouldOccur = NO;
        }
        
        NSString *errors_string = [errors componentsJoinedByString: @"\n"];
        NSString *message = [@"Het volgende veld is niet (correct) ingevuld: \n" stringByAppendingString:errors_string];
        
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


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toWho"])
    {
        activity.startTime = [self.startTime.text copy];
        activity.endTime = [self.endTime.text copy];
        activity.startDate = [self.date.date copy];
        
        ViewControllerActivityWho *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    } else if ([[segue identifier] isEqualToString:@"toWhere"])
    {
        activity.startTime = [self.startTime.text copy];
        activity.endTime = [self.endTime.text copy];
        activity.startDate = [self.date.date copy];
        
        ViewControllerActivityWho *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    }
}
@end
