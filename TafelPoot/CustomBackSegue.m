//
//  CustomBackSegue.m
//  TafelPoot
//
//  Created by Bob Van hees on 01-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "CustomBackSegue.h"

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
}
- (void)animationDone:(id)vc{
    UIViewController *dst = (UIViewController*)vc;
    UINavigationController *nav = [[self sourceViewController] navigationController];
    [nav popViewControllerAnimated:NO];
    [nav pushViewController:dst animated:NO];
  //  [[self sourceViewController] release];
}

@end


