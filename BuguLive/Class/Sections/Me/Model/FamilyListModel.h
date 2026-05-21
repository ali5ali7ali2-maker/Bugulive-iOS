//
//  FamilyListModel.h
//  BuguLive
//
//  Created by 王珂 on 16/9/27.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyListModel : NSObject

@property (nonatomic, copy) NSString * family_id;                    //公会ID
@property (nonatomic, copy) NSString * family_logo;              //公会logo
@property (nonatomic, copy) NSString * family_name;             //公会名称
@property (nonatomic, copy) NSString * user_id;             //公会长ID
@property (nonatomic, copy) NSString * nick_name;          //公会长昵称
@property (nonatomic, copy) NSString * create_time;       //创建时间
@property (nonatomic, copy) NSString * user_count;       //公会成员数量
@property (nonatomic, copy) NSString * is_apply;         //是否已经提交申请，1：已提交、0：未提交

@end
