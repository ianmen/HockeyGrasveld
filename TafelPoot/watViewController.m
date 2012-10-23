//
//  watViewController.m
//  TafelPoot
//
//  Created by Bob Van hees on 22-10-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "watViewController.h"
#import "PhotoUploader.h"

@interface watViewController ()

@end

@implementation watViewController

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

- (IBAction)testImage:(id)sender {
    
    PhotoUploader *up = [[PhotoUploader alloc] init];
    
    NSURL *url = [NSURL URLWithString:@"http://aeroclubsalland.nl/_img/nieuws/2008/mooi-weer.jpg"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
    
    [up uploadPhoto:image];
    
}
@end
