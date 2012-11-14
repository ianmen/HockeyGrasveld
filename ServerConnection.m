//
//  ServerConnection.m
//  TafelPoot
//
//  Created by Jeffrey on 10/24/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ServerConnection.h"
#import "Activity.h"
#import "GDataXMLNode.h"
#import "ActivityCD.h"
#import "AppDelegate.h"

@implementation ServerConnection
{
    NSURLConnection *connection;
    int responseCode;
    NSString *responseString;
    NSString *responseStatus;
    NSData *responseData;
    NSString *urlString;
}

@synthesize delegate;
@synthesize responseCode;
@synthesize responseString;
@synthesize responseStatus;
@synthesize responseData;


-(void)loadActivities
{
    
NSURLRequest *req = [NSURLRequest requestWithURL: [NSURL URLWithString:[NSString stringWithFormat:@"http://klanten.deictprins.nl/school/getData.php?actie=activiteiten"]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
NSURLConnection *con = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    
}

-(void)parseActivities
{
    NSError *error;
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:responseData
                                                           options:0 error:&error];
    
    int acitivityId;
    NSString *name;
    NSString *category;
    NSString *tags;
    NSString *locationDescription;
    NSDate *startDate;
    NSDate *endDate;
    NSString *activityDescription;
    NSString *locationStreet;
    NSString *locationCity;
    double longitude;
    double latitude;
    NSURL *imagePath;
    NSURL *imagePathThumbnail;
    
    
    //=====
    
    
    
    //Check if the item allready is in the local database
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    //Sett the entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSFetchRequest *fetchRequest2 = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ActivityCD"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    [fetchRequest2 setEntity:entity];
    
    //Settings
    NSError *error2;
    
    //Loop for all id's
    NSMutableArray *idsFromServer = [[NSMutableArray alloc] init];
    

    
    
    NSArray *activiteitsMembers = [doc nodesForXPath:@"//bredapp/activities/activity" error:nil];
    for (GDataXMLElement *activity in activiteitsMembers) {
        
        if([activity childCount] > 0)
        {
            
            // ID
			NSArray *activityIDs = [activity elementsForName:@"id"];
			if (activityIDs.count > 0) {
				acitivityId = [[(GDataXMLElement *) [activityIDs objectAtIndex:0] stringValue] intValue];
			} else continue;
            
			// Name
			NSArray *names = [activity elementsForName:@"title"];
			if (names.count > 0) {
				name = [(GDataXMLElement *) [names objectAtIndex:0] stringValue];
			} else continue;
			
			// Category
			NSArray *categories = [activity elementsForName:@"categorytype"];
			if (categories.count > 0) {
				category = [(GDataXMLElement *) [categories objectAtIndex:0] stringValue];
			} else continue;
            
			// Description
			NSArray *descriptions = [activity elementsForName:@"description"];
			if (descriptions.count > 0) {
				locationDescription = [(GDataXMLElement *) [descriptions objectAtIndex:0] stringValue];
			} else continue;
            
			// Dates
			GDataXMLElement* dateElements = (GDataXMLElement*)[[activity elementsForName:@"datetime"] objectAtIndex:0];
            
			// Start date
			NSArray *startDates = [dateElements elementsForName:@"startdate"];
			if (startDates.count > 0) {
				NSString *tmp = [(GDataXMLElement *) [startDates objectAtIndex:0] stringValue];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				NSDate *dateFromString = [[NSDate alloc] init];
				startDate = [dateFormatter dateFromString:tmp];
			} else continue;
            
			// End date
			NSArray *endDates = [dateElements elementsForName:@"enddate"];
			if (endDates.count > 0) {
				NSString *tmp = [(GDataXMLElement *) [endDates objectAtIndex:0] stringValue];
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
				NSDate *dateFromString = [[NSDate alloc] init];
				endDate = [dateFormatter dateFromString:tmp];
			} else continue;
            
			// Location information
			GDataXMLElement* locationElements = (GDataXMLElement*)[[activity elementsForName:@"location"] objectAtIndex:0];
            
			// Location street
			NSArray *locationDescriptions = [locationElements elementsForName:@"locationstreet"];
			if (locationDescriptions.count > 0) {
				locationStreet = [(GDataXMLElement *) [locationDescriptions objectAtIndex:0] stringValue];
			} else continue;
            
			// Location city
			NSArray *locationCities = [locationElements elementsForName:@"locationcity"];
			if (locationCities.count > 0) {
				locationCity = [(GDataXMLElement *) [locationCities objectAtIndex:0] stringValue];
			} else continue;
            
			// Longitude
			NSArray *longitudes = [locationElements elementsForName:@"longitude"];
			if (longitudes.count > 0) {
				longitude = [[(GDataXMLElement *) [longitudes objectAtIndex:0] stringValue] doubleValue];
			} else continue;
            
			// Latitude
			NSArray *latitudes = [locationElements elementsForName:@"latitude"];
			if (latitudes.count > 0) {
				latitude = [[(GDataXMLElement *) [latitudes objectAtIndex:0] stringValue]doubleValue];
			} else continue;
			
			// Real image
			NSArray *imagePaths = [activity elementsForName:@"photo"];
			if (imagePaths.count > 0) {
				imagePath = [[NSURL alloc] initWithString:[(GDataXMLElement *) [imagePaths objectAtIndex:0] stringValue]];
			} else continue;
			
			// Thumbnail
			NSArray *imagePathThumbnails = [activity elementsForName:@"thumbnail"];
			if (imagePathThumbnails.count > 0) {
				imagePathThumbnail = [[NSURL alloc] initWithString:[(GDataXMLElement *) [imagePathThumbnails objectAtIndex:0] stringValue]];
			} else continue;
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(uID == %i)", acitivityId];
            [idsFromServer addObject:[NSString stringWithFormat:@"%i",acitivityId]];
            
            //Fetch them
            [fetchRequest setPredicate:predicate];
            NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error2];
            
            //Count
            if ([fetchedObjects count] == 0){
                
                //Item staat dus nog niet in de database, toevoegen
                
                
                ActivityCD *aCD = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"ActivityCD"
                                   inManagedObjectContext:context];
                
                //Save the actual data the CD object
                aCD.uID = [NSNumber numberWithInt:acitivityId];
                aCD.activityName = name;
                aCD.category = category;
                aCD.activityDescription = locationDescription;
                aCD.startDate = startDate;
                aCD.endDate = endDate;
                aCD.address_street = locationStreet;
                aCD.address_city = locationCity;
                aCD.longitude = [NSNumber numberWithDouble:longitude];
                aCD.latitude = [NSNumber numberWithDouble:latitude];
                aCD.imagePath = [imagePath absoluteString];
                //aCD.imagePathThumbnails = [imagePathThumbnail absoluteString];
                
                aCD.address_street = locationStreet;
                NSError *error;
                if (![context save:&error]) {
                    NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
                }
                
            }

            
            
		}
	}
    
    
    //Remove the items that wheren't found in the list
    NSArray *fetchedObjects2 = [context executeFetchRequest:fetchRequest2 error:&error2];
    
    for (ActivityCD *Acd in fetchedObjects2){
        
        //Debug test
 //       NSLog(@"%@", Acd.activityName);
//        NSLog(@"%@",Acd.endDate);
//        NSLog(@"%@", Acd.address_city);
//        NSLog(@"%@", Acd.longitude);
        
        if(![idsFromServer containsObject:[NSString stringWithFormat:@"%@",Acd.uID]]){
            //ID is in the local database but not in the file pulled from the server\\
            
            //Remove the object
            [context deleteObject:Acd];
            
            //Save
            NSError *error3;
            if (![context save:&error3]) {
                NSLog(@"Whoops, couldn't save: %@", [error3 localizedDescription]);
            }
            
        }
        
        
    }
    
    //Send a done back
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"DownloadingDone"
     object:self];
}

-(NSArray*)loadAllActivitiesFromDb
{
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
                                               
    // Sett the entity
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ActivityCD" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
                                               
    NSError *error;
                                               
    // Load all activities in an array
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];

    NSMutableArray *parsedDataArray;
    [parsedDataArray addObjectsFromArray:fetchedObjects];
    
     return fetchedObjects;
}

-(void)xmlPostActivity:(Activity*)activity
{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    
    NSDateComponents *dateComps = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    ////[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
  //  NSLog(@"Current date: %@",  [dateFormatter stringFromDate:[cal dateFromComponents:dateComps]]);
   // [dateComps setHour:activity.startTime];
  //  NSLog(@"Custom date: %@",  [dateFormatter stringFromDate:[cal dateFromComponents:dateComps]]);
    
    //NSLog(@"%@", [NSTimeZone knownTimeZoneNames]);
    
  //  NSDate *myDate = [NSDate date];
  //  NSString *strDate = [dateFormatter stringFromDate:myDate];
  //  NSLog(@"[%@]", strDate);
    
    //NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // NSDateComponents *dateComps = [cal components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    //NSTimeZone *pacificTime = [NSTimeZone timeZoneWithName:@"Europe/Amsterdam"];
    //[dateComps year];
    //[dateComps setCalendar:cal];
    //[dateComps setYear:2007];
    //[dateComps setMonth:1];
    //[dateComps setDay:9];
    // [dateComps setTimeZone:pacificTime];
    // [dateComps setHour:9]; // keynote started at 9:00 am
    // [dateComps setMinute:0]; // default value, can be omitted
    // [dateComps setSecond:0]; // default value, can be omitted
        
    //NSDate *dateOfKeynote = [cal dateFromComponents:dateComps];
    
    // NSLog(@"[%@]", dateOfKeynote);
    
    //    //prepare request
    //    NSString *urlString = [NSString stringWithFormat:@"http://klanten.deictprins.nl/school/postData.php"];
    //    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //    [request setURL:[NSURL URLWithString:urlString]];
    //    [request setHTTPMethod:@"POST"];
    //
    //    //set headers
    //    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    //    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    //
    
    if(activity.imagePath == nil)
    {
        NSLog(@"IFs");
       activity.imagePath = [[NSURL alloc] initWithString:@"NO_IMAGE"];
    }
    
    // Current date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    //prepare request
    urlString = [NSString stringWithFormat:@"http://klanten.deictprins.nl/school/postData.php"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];

    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/xml"];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];

    //create the body
    NSMutableData *postBody = [NSMutableData data];
    [postBody appendData:[[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<bredapp>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<activiteiten>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<activiteit>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<naam>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:activity.activityName] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</naam>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<categorie>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:activity.category] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</categorie>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<omschrijving>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:activity.activityDescription] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</omschrijving>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<datumtijd>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<begindatum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:[dateFormatter stringFromDate:activity.startDate]] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</begindatum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<einddatum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:[dateFormatter stringFromDate:activity.endDate]] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</einddatum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</datumtijd>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<locatie>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<locatiestraat>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:activity.address_street] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</locatiestraat>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<locatieplaats>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:activity.address_city] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</locatieplaats>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<long>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat: [NSString stringWithFormat:@"%f",activity.longitude]] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</long>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<lat>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:[NSString stringWithFormat:@"%f",activity.latitude]] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</lat>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</locatie>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<foto>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:[activity.imagePath absoluteString]] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</foto>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<datum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:currentDate] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</datum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</activiteit>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</activiteiten>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</bredapp>"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //post
    [request setHTTPBody:postBody];
    
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    if ([challenge previousFailureCount] > 3)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error"
                                                        message:@"Too many unsuccessul BredApp server login attempts."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSURLCredential *cred = [[NSURLCredential alloc]initWithUser:@"bredapp" password:@"breda01!avans" persistence:NSURLCredentialPersistenceForSession];
        
        [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    self.responseCode = [httpResponse statusCode];
    self.responseStatus = [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]];
}

-(void)connection:(NSURLConnection *)connection2 didReceiveData:(NSData *)data
{
    self.responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSString *a =  [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    if ([self.responseString rangeOfString:@"ERROR"].location != NSNotFound) {
        self.responseCode = 404;
        self.responseStatus = @"";
    } else if ([self.responseString rangeOfString:@"OK"].location != NSNotFound)
    {
        self.responseCode = 200;
        self.responseStatus = @"";
    }
    
    self.responseData = data;
    
   
    NSString *url3 = connection2.originalRequest.URL.absoluteString;
    if([url3 rangeOfString:@"postData"].location == NSNotFound){
        
       [self parseActivities];
        
        
    }else{
         
    }
    
  
    
    [delegate performSelector:@selector(serverResponse)];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    self.responseCode = error.code;
    
    self.responseString = [error localizedDescription];
    
    [delegate performSelector:@selector(serverResponse)];
}

-(NSString *)dateToStr:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter stringFromDate:date];
}

-(NSDate *)strToDate:(NSString *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [dateFormatter dateFromString:date];
}

@end
