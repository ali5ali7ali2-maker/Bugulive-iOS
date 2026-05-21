//
//  DownloadHelper.m
//  BuguLive
//
//  Created by voidcat on 2024/5/22.
//  Copyright © 2024 xfg. All rights reserved.
//

#import "DownloadHelper.h"

@implementation DownloadHelper
static DownloadHelper *sharedInstance;

+ (DownloadHelper *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DownloadHelper alloc] init];
    });
    return sharedInstance;
}

- (void)downloadOrFetchFromCache:(NSString *)urlString completion:(void(^)(NSString *filePath))completion {
    [[BGHUDHelper sharedInstance] syncLoading];
    NSString *key = [urlString md5];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *cachedPath = [defaults objectForKey:key];

    if (cachedPath) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
        completion(cachedPath);
    } else {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLSessionDownloadTask *downloadTask = [[NSURLSession sharedSession]
            downloadTaskWithURL:url
            completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
                NSString *destinationPath = [documentsPath stringByAppendingPathComponent:response.suggestedFilename];

                NSError *fileError;
                [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:destinationPath] error:&fileError];
                if (!fileError) {
                    [defaults setObject:destinationPath forKey:key];
                    [[BGHUDHelper sharedInstance] syncStopLoading];
                    completion(destinationPath);
                }
            }
        ];
        [downloadTask resume];
    }
}


@end
