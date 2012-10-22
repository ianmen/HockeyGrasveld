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

    
    //Check if there is an image
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    
    if (cim == nil && cgref == NULL)
    {
        NSLog(@"ERROR-----------");
        NSLog(@"PhotoUploader - No image data received");
        
    }else{
    
    //Crop the image
    UIImage *croppedImage = [self centerAndResizeImage:image toBounds:CGRectMake(0, 0, 280, 280)];
        
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
    
    NSData *imageData = UIImageJPEGRepresentation(croppedImage, 1.0);
    
    [body appendData:[[NSString stringWithString:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // make the connection to the web
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (UIImage *)centerAndResizeImage:(UIImage *)theImage toBounds:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect(theImage.CGImage, bounds);
    
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    
    return croppedImage;
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

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // Handle the error properly
    
    NSLog(@"ERROR -------");
    NSLog(@"Error bij het uploaden van het bestand");   
}


@end
