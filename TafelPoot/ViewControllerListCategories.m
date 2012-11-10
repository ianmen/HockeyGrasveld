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

@interface ViewControllerListCategories ()

@end

@implementation ViewControllerListCategories

@synthesize categoryTable;
@synthesize categoriesMutableArray;
@synthesize alphabeticMutableArray;
@synthesize distanceMutableArray;
@synthesize timeMutableArray;
@synthesize selectedCategoryMutableArray;
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
    else if (currentArray == @"selectedCategory") {
        return [selectedCategoryMutableArray count];
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
        
        NSString *imageName = [NSString stringWithFormat:@"catIconLarge_%@.png",Title];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];
    }
    else if (currentArray == @"alphabetic") {
        ActivityCD *aCD = [alphabeticMutableArray objectAtIndex:indexPath.row];
        Title = aCD.activityName;
        
        //Set the image
        NSString *imageName = [NSString stringWithFormat:@"catIconLarge_%@.png",aCD.category];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];
    }
    else if (currentArray == @"distance") {
        Title = [distanceMutableArray objectAtIndex:indexPath.row];
    }
    else if (currentArray == @"time") {
        Title = [timeMutableArray objectAtIndex:indexPath.row];
    }
    else if (currentArray == @"selectedCategory") {
        ActivityCD *aCD = [selectedCategoryMutableArray objectAtIndex:indexPath.row];
        Title = aCD.activityName;
        
        //Set the image
        NSString *imageName = [NSString stringWithFormat:@"catIconLarge_%@.png",aCD.category];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];
    }
    else {
        Title = [categoriesMutableArray objectAtIndex:indexPath.row];
    }
    

    cell.NameLabel.text = Title;
    
    return cell;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    // When current array is categories, detailview should not be shown. Instead load the list according to the selected category.
    if ([identifier isEqualToString:@"showDetails"] && currentArray == @"categories") {
        // prevent segue from occurring
        return NO;
    }
    // by default perform the segue transition
    return YES;
}
- (void)tableView:(CustomCell *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentArray == @"categories") {
        CustomCell *cell = (CustomCell *)[categoryTable cellForRowAtIndexPath:indexPath];
        currentCategory = cell.NameLabel.text;
        
        NSLog(@"%@", currentCategory);
        
        currentArray = @"selectedCategory";
        
        //Clean the list
        alphabeticMutableArray = nil;
        
        [self updateList];
        [categoryTable reloadData];
    }
    else {
        currentCategory = nil;
    }
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
    else if (currentArray == @"selectedCategory") {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(category LIKE[c] %@)", currentCategory];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"activityName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        NSLog(@"Fetched Objects: %@", fetchedObjects);
        
        selectedCategoryMutableArray = [NSArray arrayWithArray:fetchedObjects];
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
