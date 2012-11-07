//
//  ServerConnection.m
//  TafelPoot
//
//  Created by Jeffrey on 10/24/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ServerConnection.h"
#import "Activity.h"

@implementation ServerConnection
{
    NSURLConnection *connection;
    int responseCode;
    NSString *responseString;
    NSString *responseStatus;
    NSData *responseData;
}

@synthesize delegate;
@synthesize responseCode;
@synthesize responseString;
@synthesize responseStatus;
@synthesize responseData;

-(void)xmlPostActivity:(Activity*)activity
{
    NSDate *now = [NSDate date];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComps = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit | NSWeekCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:now];
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
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
    
    
    // Current date
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    //prepare request
    NSString *urlString = [NSString stringWithFormat:@"http://klanten.deictprins.nl/school/postData.php"];
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
    [postBody appendData:[[NSString stringWithFormat:[self dateToStr:activity.startDate]] dataUsingEncoding: NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"</begindatum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:@"<einddatum>"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[[NSString stringWithFormat:[self dateToStr:activity.startDate]] dataUsingEncoding: NSUTF8StringEncoding]];
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
    
    [delegate performSelector:@selector(serverResponse)];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([self.responseString rangeOfString:@"ERROR"].location != NSNotFound) {
        self.responseCode = 404;
        self.responseStatus = @"";
    }
    
    self.responseData = data;
    
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
