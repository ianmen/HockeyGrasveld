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
#import "ServerConnection.h"
#import "MBProgressHUD.h"

@interface ViewControllerListCategories ()

@end

@implementation ViewControllerListCategories{
    
    CLLocationManager *locationManager;
 
}

@synthesize categoryTable;
@synthesize categoriesMutableArray;
@synthesize alphabeticMutableArray;
@synthesize distanceMutableArray;
@synthesize timeMutableArray;
@synthesize selectedCategoryMutableArray;
@synthesize backgroundImage;
@synthesize backButton;

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
        NSLog(@"")
        return [distanceMutableArray count];
    }
    else if (currentArray == @"time") {
        
        return [alphabeticMutableArray count];
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
        
        //See the name of the activity
        ActivityCD *aCD = [alphabeticMutableArray objectAtIndex:indexPath.row];
        Title = aCD.activityName;
        
        //Sett the image
        NSString *imageName = [NSString stringWithFormat:@"categoryIcon_%@.png",aCD.category];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];
    }
    else if (currentArray == @"time") {
        
        ActivityCD *aCD = [alphabeticMutableArray objectAtIndex:indexPath.row];
        Title = aCD.activityName;
        
        //Sett the image
        NSString *imageName = [NSString stringWithFormat:@"catIconLarge_%@.png",aCD.category];
        cell.CategoryImage.image = [UIImage imageNamed:imageName];

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
    
//    distanceMutableArray = [[NSMutableArray alloc] initWithObjects:
//                              @"Tompoezen eten",
//                              @"Voetballen",
//                              @"Gitaarspelen op het plein",
//                              nil];

    
    currentArray = @"categories";
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //Reload the DB
    ServerConnection *svr = [[ServerConnection alloc] init];
    [svr loadActivities];
    
    //Update the list
    [self updateList];
    
}

-(void)viewWillAppear:(BOOL)animated{
    

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
        backButton.hidden = YES;
    }
    else if (currentArray == @"alphabetic") {
        
        //Load them in alphabetic

        // Load all activities in an array
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"activityName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        alphabeticMutableArray = [NSArray arrayWithArray:fetchedObjects];
        
        backButton.hidden = YES;
    }
    else if (currentArray == @"distance") {
        
        //TODO : if switch if the device is an iphony
        
        //Get the current location
        // Hier zijn we nu
        locationManager = [[CLLocationManager alloc] init];
        locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation; // 100 m
        [locationManager startUpdatingLocation];
        CLLocationCoordinate2D usercoord = locationManager.location.coordinate;
        
        //NSLog(@"Lat now: %f", usercoord.latitude);
        //NSLog(@"Long now: %f", usercoord.longitude);

        //Time to update each item on the distance
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        for(ActivityCD *aCD in fetchedObjects){
            
                //Update each and every one of them
            
            /// Waar gaan we heen?
            CLLocationCoordinate2D annocoord;
            annocoord.latitude = [aCD.latitude doubleValue];
            annocoord.longitude =  [aCD.latitude doubleValue];
            
            //NSLog(@"Lat heen: %f", annocoord.latitude);
            //NSLog(@"Long heen: %f", annocoord.longitude);
            
            // www.ikkanrekenen.nl
            static const double DEG_TO_RAD = 0.017453292519943295769236907684886;
            static const double EARTH_RADIUS_IN_METERS = 6372797.560856;
            
            double latitudeArc  = (annocoord.latitude - usercoord.latitude) * DEG_TO_RAD;
            double longitudeArc = (annocoord.longitude - usercoord.longitude) * DEG_TO_RAD;
            double latitudeH = sin(latitudeArc * 0.5);
            
            latitudeH *= latitudeH;
            double lontitudeH = sin(longitudeArc * 0.5);
            
            lontitudeH *= lontitudeH;
            double tmp = cos(annocoord.latitude*DEG_TO_RAD) * cos(annocoord.latitude*DEG_TO_RAD);
            
            double afstand = EARTH_RADIUS_IN_METERS * 2.0 * asin(sqrt(latitudeH + tmp*lontitudeH));
            int distance = (int)afstand;
            
            // We loggen de afstand
            
            //NSLog(@"DIST: %d meter", distance );
            
            //And we save the distance so we can sort on it later
            aCD.distance = [NSNumber numberWithInt:distance];
            
        }
        
        //Update the list
        // Load all activities in an array
         NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES selector:@selector(compare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest error:&error];
        
        alphabeticMutableArray = [NSArray arrayWithArray:fetchedObjects2];

        
        backButton.hidden = YES;
    }
    else if (currentArray == @"time") {
        
        //Load them in Time
        
        // Load all activities in an array
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:YES selector:@selector(compare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        alphabeticMutableArray = [NSArray arrayWithArray:fetchedObjects];

        backButton.hidden = YES;
    }
    else if (currentArray == @"selectedCategory") {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(category LIKE[c] %@)", currentCategory];
        [fetchRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"activityName" ascending:YES selector:@selector(caseInsensitiveCompare:)];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        selectedCategoryMutableArray = [NSArray arrayWithArray:fetchedObjects];
        
        backButton.hidden = NO;
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
    [categoryTable reloadData];
}

- (IBAction)sortTime:(id)sender {
    backgroundImage.image = [UIImage imageNamed:@"backgroundTijd"];
    currentArray = @"time";
    
    //Clean the list
    alphabeticMutableArray = nil;
    
    [self updateList];
    [self.categoryTable reloadData];
}

- (IBAction)backButton:(id)sender {
    NSLog(@"CATBACK");
    currentArray = @"categories";
    
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
        
        ActivityCD *act;
        
        if (currentArray == @"alphabetic") {
            act = [alphabeticMutableArray objectAtIndex: p.row];
        }
        else if (currentArray == @"distance") {
            act = [distanceMutableArray objectAtIndex: p.row];
        }
        else if (currentArray == @"time") {
            act = [timeMutableArray objectAtIndex: p.row];
        }
        else if (currentArray == @"selectedCategory") {
            act = [selectedCategoryMutableArray objectAtIndex: p.row];
        }
        else {
            act = [alphabeticMutableArray objectAtIndex: p.row];
        }
        
        [vc setActivity: act];
    }
}
@end
