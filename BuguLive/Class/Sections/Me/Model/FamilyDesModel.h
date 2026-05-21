//
//  FamilyDesModel.h
//  BuguLive
//
//  Created by 王珂 on 16/9/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyDesModel : NSObject
@property (nonatomic, copy) NSString * family_id;                //公会ID
@property (nonatomic, copy) NSString * family_logo;           //公会logo
@property (nonatomic, copy) NSString * family_name;           //公会名称
@property (nonatomic, copy) NSString * create_time;        //创建时间
@property (nonatomic, copy) NSString * family_manifesto;      //公会宣言
@property (nonatomic, copy) NSString * memo;               //备注
@property (nonatomic, copy) NSString * status;             //审核状态
@property (nonatomic, copy) NSString * nick_name;          //公会族长昵称
@property (nonatomic, copy) NSString * user_count;        //公会人数
@end
