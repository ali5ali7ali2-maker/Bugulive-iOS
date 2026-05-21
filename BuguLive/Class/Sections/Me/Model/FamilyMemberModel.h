//
//  FamilyMemberModel.h
//  BuguLive
//
//  Created by 王珂 on 16/9/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyMemberModel : NSObject

@property (nonatomic, copy) NSString *user_id; //公会成员ID
@property (nonatomic, copy) NSString *nick_name; //公会成员昵称
@property (nonatomic, copy) NSString * sex;  //公会成员性别
@property (nonatomic, copy) NSString *head_image; //公会成员头像
@property (nonatomic, assign) NSInteger user_level; //等级
@property (nonatomic, copy) NSString *v_icon; //公会成员认证图标
@property (nonatomic, assign) NSInteger v_type; //公会成员认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString *signature; //

@end
