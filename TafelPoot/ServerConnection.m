//
//  ServerConnection.m
//  TafelPoot
//
//  Created by Jeffrey on 10/23/12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "ServerConnection.h"

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

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([self.responseString rangeOfString:@"ERROR"].location != NSNotFound) {
        self.responseCode = 404;
        self.responseStatus = @"";
    }
    
    self.responseData = data;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    self.responseCode = error.code;
    
    self.responseString = [error localizedDescription];
    
    [delegate performSelector:@selector(serverResponse)];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
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

