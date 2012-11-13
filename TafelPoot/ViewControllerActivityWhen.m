//
//  ViewControllerActivityWhen.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerActivityWhen.h"
#import "ViewControllerActivityWho.h"
#import "ViewControllerActivityWhere.h"
#import "Activity.h"

@interface ViewControllerActivityWhen ()
{
    //Activity *activity;
}
@end

@implementation ViewControllerActivityWhen {
    UIActionSheet *pickerViewPopup;
    UIDatePicker *pickerView;
    
    UIToolbar *pickerToolbar;
    NSMutableArray *barItems;
}

@synthesize startDate;
@synthesize endDate;
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
    
    // If activity already exists, automaticly fill in the form
    if( [activity.startTime length] > 0 ) {
        self.startDate.text = activity.startTime;
    }
    if( [activity.endTime length] > 0 ) {
        self.endDate.text = activity.endTime;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)actionSheet {
    pickerViewPopup = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    
    pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
    //pickerView.datePickerMode = UIDatePickerModeDate;
    pickerView.hidden = NO;
    
    NSDate *currentTime = [NSDate date];
    
    pickerView.minimumDate = currentTime;
    // 86400 = precies 1 dag in seconden
    pickerView.maximumDate = [currentTime dateByAddingTimeInterval:86400];
    
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    
    barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
}

- (void)actionSheet2 {
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelButtonPressed:)];
    [barItems addObject:cancelBtn];
    
    [pickerToolbar setItems:barItems animated:YES];
    
    [pickerViewPopup addSubview:pickerToolbar];
    [pickerViewPopup addSubview:pickerView];
    [pickerViewPopup showInView:self.view];
    [pickerViewPopup setBounds:CGRectMake(0,0,320, 464)];
}

- (IBAction)beginTijd:(id)sender {
    [self actionSheet];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)];
    [barItems addObject:doneBtn];
    
    [self actionSheet2];
}

-(void)doneButtonPressed:(id)sender{
    //Do something here here with the value selected using [pickerView date] to get that value
    
    NSDate *date = pickerView.date;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    startDate.text = dateString;
    activity.startDate = date;
    
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)doneButtonPressed2:(id)sender{
    //Do something here here with the value selected using [pickerView date] to get that value
    
    NSDate *date = pickerView.date;
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"d MMMM HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    endDate.text = dateString;
    activity.endDate = date;
    
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}

-(void)cancelButtonPressed:(id)sender{
    [pickerViewPopup dismissWithClickedButtonIndex:1 animated:YES];
}

- (IBAction)eindTijd:(id)sender {
    [self actionSheet];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed2:)];
    [barItems addObject:doneBtn];
    
    [self actionSheet2];
}

- (IBAction)back:(id)sender {
}

- (void)setActivity:(Activity*)currentActivity
{
    activity = currentActivity;
}


- (NSMutableArray *) validateForm
{
    NSMutableArray *errors = [[NSMutableArray alloc] init];
    
    if( [self.startDate.text length] == 0 ) [errors addObject:@"Begintijd"];
    if( [self.endDate.text length] == 0 ) [errors addObject:@"Eindtijd"];
    
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
        ViewControllerActivityWho *vc = [segue destinationViewController];
        
        [vc setActivity:activity];
    } else if ([[segue identifier] isEqualToString:@"toWhere"])
    {
        activity.startDate = nil;
        activity.endDate = nil;
        
        ViewControllerActivityWhere *vc = [segue destinationViewController];

        [vc setActivity:activity];
    }
}
@end
