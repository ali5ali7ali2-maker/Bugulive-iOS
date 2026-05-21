//
//  DownloadHelper.h
//  BuguLive
//
//  Created by voidcat on 2024/5/22.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadHelper : NSObject
+ (DownloadHelper *)sharedInstance;

- (void)downloadOrFetchFromCache:(NSString *)urlString completion:(void(^)(NSString *filePath))completion;
@end

NS_ASSUME_NONNULL_END
