//
//  HMVideoViewModel.m
//  BuguLive
//
//  Created by 范东 on 2018/12/27.
//  Copyright © 2018 xfg. All rights reserved.
//

#import "HMVideoViewModel.h"

@interface HMVideoViewModel ()

// 页码
@property (nonatomic, assign) NSInteger page;

@end

@implementation HMVideoViewModel

- (void)refreshNewListWithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure WithRequestDict:(nonnull NSDictionary *)dict{
    self.page = 1;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"svideo" forKey:@"ctl"];
    if (self.isPushed) {
        [parmDict setObject:@"video" forKey:@"act"];
    }else{
        [parmDict setObject:@"index" forKey:@"act"];
    }
    [parmDict setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    if (dict) {
        [parmDict setValuesForKeysWithDictionary:dict];
    }
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             //直播数组
             NSArray *listArray = [responseJson objectForKey:@"data"];
             !success ? : success(listArray);
         }
        
        
     } FailureBlock:^(NSError *error)
     {
         !failure ? : failure(error);
     }];
}

- (void)refreshMoreListWithSuccess:(void (^)(NSArray * _Nonnull))success failure:(void (^)(NSError * _Nonnull))failure WithRequestDict:(nonnull NSDictionary *)dict{
    self.page ++;
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"svideo" forKey:@"ctl"];
    if (self.isPushed) {
        [parmDict setObject:@"video" forKey:@"act"];
    }else{
        [parmDict setObject:@"index" forKey:@"act"];
    }
    [parmDict setObject:[NSNumber numberWithInt:self.page] forKey:@"page"];
    if (dict) {
        [parmDict setValuesForKeysWithDictionary:dict];
    }
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ([responseJson toInt:@"status"] == 1)
         {
             //直播数组
             NSArray *listArray = [responseJson objectForKey:@"data"];
             !success ? : success(listArray);
         }
     } FailureBlock:^(NSError *error)
     {
         !failure ? : failure(error);
     }];
}

- (NetHttpsManager *)httpsManager
{
    if (!_httpsManager)
    {
        _httpsManager = [NetHttpsManager manager];
    }
    return _httpsManager;
}

@end
