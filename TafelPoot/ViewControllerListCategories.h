//
//  ViewControllerListCategories.h
//  TafelPoot
//
//  Created by Jochem Rommens on 07-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerListCategories : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSMutableArray *categoriesArray;
    NSString *currentArray;
    NSString *currentCategory;
}

@property (strong, nonatomic) IBOutlet UITableView *categoryTable;
@property (nonatomic, retain) NSMutableArray *categoriesMutableArray;
@property (nonatomic, retain) NSMutableArray *alphabeticMutableArray;
@property (nonatomic, retain) NSMutableArray *distanceMutableArray;
@property (nonatomic, retain) NSMutableArray *timeMutableArray;
@property (nonatomic, retain) NSMutableArray *selectedCategoryMutableArray;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

- (IBAction)sortCategories:(id)sender;
- (IBAction)sortAlphabetic:(id)sender;
- (IBAction)sortDistance:(id)sender;
- (IBAction)sortTime:(id)sender;

@end
