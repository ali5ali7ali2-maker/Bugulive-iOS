//
//  FDOSSManager.h
//  FDNetworkObjC
//
//  Created by bogokj on 2020/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define kFDOSSManagerSendNoti @"kFDOSSManagerSendNoti"
#define kFDOSSManagerRecieveNoti @"kFDOSSManagerRecieveNoti"

typedef void(^fd_ossSetUpHandler)(void);

typedef void(^fd_ossProgressHandler)(float percent);

typedef void(^fd_ossSuccessHandler)(NSString *resultStr);

typedef void(^fd_ossFaliureHandler)(NSError *error);

@interface FDOSSManager : NSObject

+ (FDOSSManager *)defaultManager;

- (void)setup:(fd_ossSetUpHandler)finish;

- (void)UPLOAD:(NSData *)fileData progress:(fd_ossProgressHandler)progress success:(fd_ossSuccessHandler)success failure:(fd_ossFaliureHandler)faliure;

- (NSString *)getObjectKey;

@end

NS_ASSUME_NONNULL_END
