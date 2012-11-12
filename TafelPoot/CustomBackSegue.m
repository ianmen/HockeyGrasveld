//
//  CustomBackSegue.m
//  TafelPoot
//
//  Created by Bob Van hees on 01-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "CustomBackSegue.h"
#import "ViewControllerActivityWhat.h"
#import "ViewControllerActivityWhere.h"
#import "ViewControllerActivityWhen.h"
#import "Activity.h"

@implementation CustomBackSegue

@synthesize appDelegate=_appDelegate;

-(void) perform{
    
    UIViewController *dst = [self destinationViewController];
    UIViewController *src = [self sourceViewController];
    [dst viewWillAppear:NO];
    [dst viewDidAppear:NO];
    [src.view addSubview:dst.view];
    
    CGRect original = dst.view.frame;

  dst.view.frame = CGRectMake(0-dst.view.frame.size.width, original.origin.y-20, dst.view.frame.size.width, dst.view.frame.size.height);


    //dst.view.frame = CGrectMake
    
    [UIView beginAnimations:nil context:nil];
    dst.view.frame = CGRectMake(original.origin.x, original.origin.y-20, original.size.height, original.size.width);
    [UIView commitAnimations];
    
    [self performSelector:@selector(animationDone:) withObject:dst afterDelay:0.2f];
    
    [self restoreUserTypedData];
}
- (void)animationDone:(id)vc{
    UIViewController *dst = (UIViewController*)vc;
    UINavigationController *nav = [[self sourceViewController] navigationController];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:dst animated:NO];
  //  [[self sourceViewController] release];
}

-(void)restoreUserTypedData
{
    UIViewController *src = [self sourceViewController];
    NSString *a = [src.title lowercaseString];
    if ([[src.title lowercaseString] rangeOfString:@"adress"].location != NSNotFound)
    {
        ViewControllerActivityWhat *dst = [self destinationViewController];
        Activity *activity = dst.activity;
        dst.name.text = activity.activityName;
        dst.category.text = activity.category;
        dst.tags.text = activity.tags;
        dst.description.text = activity.activityDescription;
    }
    else if ([[src.title lowercaseString] rangeOfString:@"when"].location != NSNotFound)
    {
        ViewControllerActivityWhere *dst = [self destinationViewController];
        Activity *activity = dst.activity;
        
        NSString *a = [activity.address_street copy];
        dst.streetField.text = [activity.address_street copy];
        dst.cityField.text = [activity.address_city copy];
        
    }
    else if ([[src.title lowercaseString] rangeOfString:@"who"].location != NSNotFound)
    {
        ViewControllerActivityWhen *dst = [self destinationViewController];
        Activity *activity = dst.activity;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        dst.startDate.text = [dateFormatter stringFromDate:activity.startDate];
        dst.endDate.text = [dateFormatter stringFromDate:activity.endDate];
    }
}

@end


