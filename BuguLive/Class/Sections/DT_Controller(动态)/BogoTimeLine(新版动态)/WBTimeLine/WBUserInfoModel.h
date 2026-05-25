//
//  WBUserInfoModel.h
//  UniversalApp
//
//  Created by bogokj on 2019/11/22.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WBUserInfoModel : NSObject

//    "id":'用户id',
//    "avatar":"用户头像",
//    "user_nickname":"静",
//    "sex":2,
//    "level":2,
//    "coin":0,
//    "user_status":2,
//    "is_auth":0,
//    "is_online":'1在线 0否',
//    "link_id":'渠道号',
//    "signature":"我",
//    'age':'年龄',
//    'province':'省',
//    'city':'市',

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *user_nickname;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *level;
@property(nonatomic, copy) NSString *coin;
@property(nonatomic, copy) NSString *user_status;
@property(nonatomic, copy) NSString *is_auth;
@property(nonatomic, copy) NSString *is_online;
@property(nonatomic, copy) NSString *link_id;
@property(nonatomic, copy) NSString *signature;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *city;

@end

NS_ASSUME_NONNULL_END
