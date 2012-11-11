//
//  ViewControllerListCategories.m
//  TafelPoot
//
//  Created by Jochem Rommens on 07-11-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ViewControllerListCategories.h"
#import "ViewControllerViewActivity.h"
#import "CustomCell.h"
#import "AppDelegate.h"
#import "ActivityCD.h"
#import <CoreLocation/CoreLocation.h>

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
        return [alphabeticMutableArray count];
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
        
        ActivityCD *aCD = [alphabeticMutableArray objectAtIndex:indexPath.row];
        Title = aCD.activityName;
        
        //Sett the image
        NSString *imageName = [NSString stringWithFormat:@"categoryIcon_%@.png",aCD.category];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];

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
    
//    distanceMutableArray = [[NSMutableArray alloc] initWithObjects:
//                              @"Tompoezen eten",
//                              @"Voetballen",
//                              @"Gitaarspelen op het plein",
//                              nil];

    
    currentArray = @"categories";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    //Update the list
    [self updateList];
    
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
        
        //TODO : if switch if the device is an iphony
        
        //Time to update each item on the distance
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        for(ActivityCD *aCD in fetchedObjects){
            
                //Update each and every one of them
            
        }
        
    
    }
    else if (currentArray == @"time") {
        
        //Load them in Time
        
        // Load all activities in an array
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES selector:@selector(compare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        alphabeticMutableArray = [NSArray arrayWithArray:fetchedObjects];

        
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
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"showDetails"])
    {
        ViewControllerViewActivity *vc = [segue destinationViewController];
        NSIndexPath *p = [self.categoryTable indexPathForSelectedRow];
        
        ActivityCD *act = [alphabeticMutableArray objectAtIndex: p.row];
        
        [vc setActivity: act];
    }
}
@end
