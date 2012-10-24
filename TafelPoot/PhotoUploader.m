//
//  PhotoUploader.m
//  TafelPoot
//
//  Created by Bob Van hees on 22-10-12.
//  Copyright (c) 2012 Avans Hogeschool. All rights reserved.
//

#import "PhotoUploader.h"
#import "UIImage+Resize.h"

@implementation PhotoUploader{
    
    NSURLConnection *connection;
}

@synthesize url;

- (void)uploadPhoto:(UIImage *)image{
    
    //Do get the image which provided

    //if()
    
    //Check if there is an image
    CGImageRef cgref = [image CGImage];
    CIImage *cim = [image CIImage];
    
    if (cim == nil && cgref == NULL)
    {
        NSLog(@"ERROR-----------");
        NSLog(@"PhotoUploader - No image data received");
        
    }else{
            
    //Resize the image to 500X500 no scaling, this for faster uploading
    UIImage *croppedImage = [self centerAndResizeImage:image scaledToSize:CGSizeMake(500, 500)];
        
    #define DataDownloaderRunMode @"myapp.run_mode"
	NSString *urlString = @"http://klanten.deictprins.nl/school/postImage.php";
    NSURL *url2 = [[NSURL alloc] initWithString:urlString];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url2
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
    
    [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    // make the connection to the web
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
}

- (UIImage *)centerAndResizeImage:(UIImage *)theImage scaledToSize:(CGSize)newSize
{
    //Handle the resizing by an external lib
    return [theImage resizedImageToFitInSize:CGSizeMake(500, 500) scaleIfSmaller:NO];
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
    
    //Set the url property
    self.url = [NSURL URLWithString:returnString];
    
    //Notify the caller the uploading is done
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoUploadDone" object:nil];
    
        
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // Handle the error properly
    
    NSLog(@"=== ERROR ===");
    NSLog(@"Error bij het uploaden van het bestand");
    
    //Notify the caller there was an error
    [[NSNotificationCenter defaultCenter] postNotificationName:@"photoUploadError" object:nil];
    
}


@end
