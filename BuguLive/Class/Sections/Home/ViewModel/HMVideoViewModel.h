//
//  HMVideoViewModel.h
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMVideoViewModel : NSObject

/**
 网络请求
 */
@property (nonatomic, strong) NetHttpsManager *httpsManager;

@property (nonatomic, assign) BOOL  hasMore;

@property (nonatomic, assign) BOOL isPushed;

- (void)refreshNewListWithSuccess:(void(^)(NSArray *list))success
                          failure:(void(^)(NSError *error))failure WithRequestDict:(NSDictionary *)dict;

- (void)refreshMoreListWithSuccess:(void(^)(NSArray *list))success
                           failure:(void(^)(NSError *error))failure WithRequestDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
