//
//  GuildDetailModel.h
//
//
//  Created by JSONConverter on 2021/09/28.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GuildDetailModelFamily_info;
@class GuildDetailModelLists;

@interface GuildDetailModel: NSObject
@property (nonatomic, copy) NSString *apply;
@property (nonatomic, strong) GuildDetailModelFamily_info *family_info;
@property (nonatomic, strong) NSArray<GuildDetailModelLists *> *lists;

/// -1是未加入，0是申请中，1是已通过
@property(nonatomic, copy) NSString *join_status;
@property(nonatomic, copy) NSString *user_family_id;
@end

@interface GuildDetailModelLists: NSObject
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *sums;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *user_level;
@property (nonatomic, copy) NSString *signature;
@property (nonatomic, copy) NSString *family_chieftain;
//公会贡献榜需要以下字段
@property (nonatomic, copy) NSString *order;
@end

@interface GuildDetailModelFamily_info: NSObject
@property (nonatomic, copy) NSString *create_time;
@property (nonatomic, copy) NSString *family_id;
@property (nonatomic, copy) NSString *family_logo;
@property (nonatomic, copy) NSString *family_manifesto;
@property (nonatomic, copy) NSString *family_name;
@property (nonatomic, copy) NSString *head_image;
@property (nonatomic, copy) NSString *memo;
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *user_count;
@property (nonatomic, copy) NSString *user_id;

/// 加入公会的验证方式【1会长同意；2申请即加入】
@property (nonatomic, copy) NSString *family_type;
/// 加入公会的验证方式【1会长同意；2申请即加入】
@property (nonatomic, copy) NSString *type;

//公会排行榜需要以下字段
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *family_level;
@property(nonatomic, copy) NSString *sums;
@property(nonatomic, copy) NSString *order;
//"id": "57", //公会id
//            "family_level": "3", //公会等级
//            "sums": "0.68",//积分
//            "order": 1 //排名
@end
