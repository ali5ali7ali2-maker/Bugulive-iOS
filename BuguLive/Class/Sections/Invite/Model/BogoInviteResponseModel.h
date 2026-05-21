//
//  BogoInviteResponseModel.h
//
//
//  Created by JSONConverter on 2021/10/09.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BogoInviteResponseModelData;
@class BogoInviteResponseModelLists;
@class BogoInviteResponseModelReward;

@interface BogoInviteResponseModel: NSObject
@property (nonatomic, strong) BogoInviteResponseModelData *data;
@property (nonatomic, copy) NSString *error;
@property (nonatomic, strong) NSArray<BogoInviteResponseModelLists *> *lists;
@property (nonatomic, strong) BogoInviteResponseModelReward *reward;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *protal;
@end

@interface BogoInviteResponseModelData: NSObject
@property (nonatomic, copy) NSString *count;
@property (nonatomic, copy) NSString *total_money;
@property (nonatomic, copy) NSString *two_count;
@end

@interface BogoInviteResponseModelLists: NSObject
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *coin;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *uid;
@end

@interface BogoInviteResponseModelReward: NSObject
@property (nonatomic, copy) NSString *one;
@property (nonatomic, copy) NSString *two;
@end
