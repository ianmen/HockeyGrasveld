//
//  ViewControllerListCategories.m
//  TafelPoot
//
//  Created by Jochem Rommens on 07-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerListCategories.h"
#import "CustomCell.h"

@interface ViewControllerListCategories ()

@end

@implementation ViewControllerListCategories

@synthesize categoryTable;
@synthesize categoriesMutableArray;
@synthesize alphabeticMutableArray;
@synthesize distanceMutableArray;
@synthesize timeMutableArray;
@synthesize backgroundImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentArray == @"categories") {
        return [categoriesMutableArray count];
    }
    else if (currentArray == @"alphabetic") {
        return [alphabeticMutableArray count];
    }
    else if (currentArray == @"distance") {
        return [distanceMutableArray count];
    }
    else if (currentArray == @"time") {
        return [timeMutableArray count];
    }
    else {
        return [categoriesMutableArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"categoryCell";
    
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // configure your cell here...
    
    NSString *categoryName = [categoriesMutableArray objectAtIndex:indexPath.row];
    
    if (currentArray == @"categories") {
        categoryName = [categoriesMutableArray objectAtIndex:indexPath.row];
    }
    else if (currentArray == @"alphabetic") {
        categoryName = [alphabeticMutableArray objectAtIndex:indexPath.row];
    }
    else if (currentArray == @"distance") {
        categoryName = [distanceMutableArray objectAtIndex:indexPath.row];
    }
    else if (currentArray == @"time") {
        categoryName = [timeMutableArray objectAtIndex:indexPath.row];
    }
    else {
        categoryName = [categoriesMutableArray objectAtIndex:indexPath.row];
    }
    
    
    NSString *imageName = [NSString stringWithFormat:@"categoryIcon_%@.png", categoryName];
    
    cell.NameLabel.text = categoryName;
    
    cell.CategoryImage.image = [UIImage imageNamed:imageName];
    
    return cell;
}

- (void)viewDidLoad
{
    categoriesMutableArray = [[NSMutableArray alloc] initWithObjects:
                              @"Muziek",
                              @"Eten",
                              @"Sport",
                              @"Kunst & Cultuur",
                              @"Reizen",
                              @"Games",
                              @"Natuur & Milieu",
                              @"Gezondheid & Uiterlijk",
                              @"Uitgaan & Evenementen",
                              @"Foto & Film",
                              @"Boeken",
                              @"Dieren",
                              @"Bouwen & Ondernemen",
                              nil];
    
    alphabeticMutableArray = [[NSMutableArray alloc] initWithObjects:
                              @"Voetballen",
                              @"Tompoezen eten",
                              @"Gitaarspelen op het plein",
                              nil];
    distanceMutableArray = [[NSMutableArray alloc] initWithObjects:
                              @"Tompoezen eten",
                              @"Voetballen",
                              @"Gitaarspelen op het plein",
                              nil];
    timeMutableArray = [[NSMutableArray alloc] initWithObjects:
                              @"Gitaarspelen op het plein",
                              @"Tompoezen eten",
                              @"Voetballen",
                              nil];
    
    currentArray = @"categories";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sortCategories:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundCategorie"];
    currentArray = @"categories";
    [self.categoryTable reloadData];
}

- (IBAction)sortAlphabetic:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundAlfabetisch"];
    currentArray = @"alphabetic";
    [self.categoryTable reloadData];
}

- (IBAction)sortDistance:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundAfstand"];
    currentArray = @"distance";
    [self.categoryTable reloadData];
}

- (IBAction)sortTime:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundTijd"];
    currentArray = @"time";
    [self.categoryTable reloadData];
}
@end
