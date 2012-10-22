//
//  PhotoUploader.m
//  TafelPoot
//
//  Created by Bob Van hees on 22-10-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "PhotoUploader.h"

@implementation PhotoUploader{
    
    NSURLConnection *connection;
}

- (void)uploadPhoto:(UIImage *)image{
    
    //Do get the image which provided

    if()
    
    //TODO: Resize the image
    
    //Set the image of the imageview
    //imageView1.image = image;
    
    //Remove the foto choser
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    #define DataDownloaderRunMode @"myapp.run_mode"
	NSString *urlString = @"http://klanten.deictprins.nl/school/postImage.php";
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:60];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"----WebKitFormBoundarycC4YiaUFwM44F6rT";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[@"Content-Disposition: form-data; name='attachment[file]';filename='image.png'\r\n"dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [body appendData:[[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // make the connection to the web
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

//The posting is password protected
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    
    
    NSURLCredential *cred = [[NSURLCredential alloc]initWithUser:@"bredapp" password:@"breda01!avans" persistence:NSURLCredentialPersistenceForSession];
    
    [[challenge sender] useCredential:cred forAuthenticationChallenge:challenge];
    
}

//Did get an response back from the webserver 
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",returnString);
    
}


@end
