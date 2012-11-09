//
//  ViewControllerListCategories.m
//  TafelPoot
//
//  Created by Jochem Rommens on 07-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerListCategories.h"
#import "CustomCell.h"
#import "AppDelegate.h"
#import "ActivityCD.h"

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
    
    NSString *Title;
    
    if (currentArray == @"categories") {
        Title = [categoriesMutableArray objectAtIndex:indexPath.row];
        
        NSString *imageName = [NSString stringWithFormat:@"categoryIcon_%@.png",Title];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];
    }
    else if (currentArray == @"alphabetic") {
        ActivityCD *aCD = [alphabeticMutableArray objectAtIndex:indexPath.row];
        Title = aCD.activityName;
        
        //Sett the image
        NSString *imageName = [NSString stringWithFormat:@"categoryIcon_%@.png",aCD.category];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];
    }
    else if (currentArray == @"distance") {
        Title = [distanceMutableArray objectAtIndex:indexPath.row];
    }
    else if (currentArray == @"time") {
        Title = [timeMutableArray objectAtIndex:indexPath.row];
    }
    else {
        Title = [categoriesMutableArray objectAtIndex:indexPath.row];
    }
    

    cell.NameLabel.text = Title;
    
    return cell;
}

- (void)viewDidLoad
{
    categoriesMutableArray = [[NSMutableArray alloc] initWithObjects:
                              @"Muziek",
                              @"Eten",
                              @"Sport",
                              @"Kunst en Cultuur",
                              @"Reizen",
                              @"Games",
                              @"Natuur en Milieu",
                              @"Gezondheid en Uiterlijk",
                              @"Uitgaan en Evenementen",
                              @"Foto en Film",
                              @"Boeken",
                              @"Dieren",
                              @"Bouwen en Ondernemen",
                              nil];
    
//    alphabeticMutableArray = [[NSMutableArray alloc] initWithObjects:
//                              @"Voetballen",
//                              @"Tompoezen eten",
//                              @"Gitaarspelen op het plein",
//                              nil];
//    distanceMutableArray = [[NSMutableArray alloc] initWithObjects:
//                              @"Tompoezen eten",
//                              @"Voetballen",
//                              @"Gitaarspelen op het plein",
//                              nil];
//    timeMutableArray = [[NSMutableArray alloc] initWithObjects:
//                              @"Gitaarspelen op het plein",
//                              @"Tompoezen eten",
//                              @"Voetballen",
//                              nil];
    
    currentArray = @"categories";
    
    [self updateList];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


//Method for updating the different lists
-(void)updateList {
    
    //Get the DB connection
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //Sett the entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ActivityCD" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;

    
    if (currentArray == @"categories") {
       
    }
    else if (currentArray == @"alphabetic") {
        
        //Load them in alphabetic

        // Load all activities in an array
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"activityName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        alphabeticMutableArray = [NSArray arrayWithArray:fetchedObjects];
 
    }
    else if (currentArray == @"distance") {
        
    }
    else if (currentArray == @"time") {
        
    }
   

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sortCategories:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundCategorie"];
    currentArray = @"categories";
    
    //Clean the list
    alphabeticMutableArray = nil;
    
    [self updateList];
    [self.categoryTable reloadData];
}

- (IBAction)sortAlphabetic:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundAlfabetisch"];
    currentArray = @"alphabetic";
    
    //Clean the list
    alphabeticMutableArray = nil;
    
    [self updateList];
    [categoryTable reloadData];
}

- (IBAction)sortDistance:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundAfstand"];
    currentArray = @"distance";
    
    //Clean the list
    alphabeticMutableArray = nil;
    
    [self updateList];
    [self.categoryTable reloadData];
}

- (IBAction)sortTime:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundTijd"];
    currentArray = @"time";
    
    //Clean the list
    alphabeticMutableArray = nil;
    
    [self updateList];
    [self.categoryTable reloadData];
}
@end
