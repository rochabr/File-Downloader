//
//  FileDownloader.h
//  EBX Group
//
//  Created by Fernando Rocha Silva on 26/09/11.
//  Copyright 2011 P_Cers Entretenimento Digital LTDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloader : NSObject {
    
    NSFileHandle *handle;
    NSString* url_;
    
    NSString* filePath;
    BOOL onDownload;
    
    NSMutableData *receivedData;
    double receivedLength;
}

- (FileDownloader *)initWithString:(NSString*)url filename:(NSString*)name cookie:(NSString*)cookie;

- (void)startDownloadingURL;

@end
