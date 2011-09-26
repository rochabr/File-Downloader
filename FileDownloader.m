//
//  FileDownloader.m
//  EBX Group
//
//  Created by Fernando Rocha Silva on 26/09/11.
//  Copyright 2011 P_Cers Entretenimento Digital LTDA. All rights reserved.
//

#import "FileDownloader.h"

@implementation FileDownloader
- (FileDownloader *)initWithString:(NSString*)url filename:(NSString*)name cookie:(NSString*)cookie
{
    [super init];
    
    url_=url;
    filePath=[name retain];
    
    onDownload = FALSE;
    return self;
}

- (void)dealloc
{
    [filePath release];
    [super dealloc];
}


- (void)startDownloadingURL
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL* url=[NSURL URLWithString:[url_ stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *downloadRequest=[NSMutableURLRequest requestWithURL:url
                                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                             timeoutInterval:60.0];
    
    NSURLConnection *downloadConnection=[[NSURLConnection alloc] initWithRequest:downloadRequest delegate:self];
    if (downloadConnection) {
        NSFileManager *manager = [NSFileManager defaultManager];
        
        if( [manager fileExistsAtPath:filePath] ){
            NSError *error = [[NSError alloc] init];
            
            [manager removeItemAtPath:filePath error:&error];
            [error release];
        }
        
        [manager createFileAtPath:filePath contents:nil attributes:nil];
        handle = [[NSFileHandle fileHandleForWritingAtPath:filePath] retain];
        
        receivedData =[[NSMutableData alloc] initWithLength:0];
        [downloadConnection start];
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        while (!onDownload)
        {
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    } 
}

#pragma mark auto called functions
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0]; 
    
    receivedLength = 0;   
    if (handle){
        [handle seekToEndOfFile];
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
    receivedLength = receivedLength + [data length];
    
    if(receivedData.length > 1){          
        [handle seekToEndOfFile];
        [handle writeData:receivedData];
        
        [receivedData release];
        receivedData =[[NSMutableData alloc] initWithLength:0];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [connection release];
    
    [handle release];
    NSLog(@"Connection failed! Error - %@", [error localizedDescription]);
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [handle closeFile]; 
    
    [connection release];
    onDownload = TRUE;
}

@end