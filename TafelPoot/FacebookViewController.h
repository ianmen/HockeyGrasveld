//
//  FacebookViewController.h
//  XMLLijst
//
//  Created by Jochem Rommens on 04-10-12.
//  Copyright (c) 2012 Jochem Rommens. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FacebookViewController : UIViewController

@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)shareButtonAction:(id)sender;
- (IBAction)logIn:(id)sender;

@end
