//
//  SenderModel.h
//  FanweApp
//
//  Created by xfg on 16/5/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BogoGuardianModel.h"
@interface SenderModel : NSObject<IMUserAble>

//座驾cycar
@property (nonatomic, copy) NSString            *noble_car_name; //座驾名称
@property (nonatomic, copy) NSString            *car_svga; //svga地址
@property (nonatomic, assign) int                 has_car; //svga地址
@property (nonatomic, copy) NSString                 *is_vip; //是否是vip


//is_stealth 这个是这个用户有没有隐身权限， is_noble_stealth这个是这个用户开没开启隐身
@property (nonatomic, strong) NSString *noble_stealth;//是否隐身
@property (nonatomic, strong) NSString *is_noble_stealth;//是否隐身



@property ( nonatomic, copy) NSString *noble_vip_type ;//  "0不是贵族1是贵族",
@property ( nonatomic, copy) NSString *noble_is_avatar;//  "0没有，1有；贵族头像",
@property ( nonatomic, copy) NSString *noble_car;//  "0没有，1有；贵族座驾",
@property ( nonatomic, copy) NSString *noble_special_effects;//  '0没有，1有；贵族特效' ,
@property ( nonatomic, copy) NSString *noble_medal;//  "0没有，1有；贵族勋章",
@property ( nonatomic, copy) NSString *noble_experience;//  "0没有，1有；经验加成",
@property ( nonatomic, copy) NSString *noble_barrage;//  "0没有，1有；贵族弹幕",
@property ( nonatomic, copy) NSString *noble_silence;//  "0没有，1有；贵族防禁言",
@property ( nonatomic, copy) NSString *noble_avatar;//  "贵族头像图片",
@property ( nonatomic, copy) NSString *noble_icon;//  "贵族图标",
@property(nonatomic, strong) NSString *noble_car_url;
@property (nonatomic, copy) NSString *user_id; //用户ID
@property (nonatomic, copy) NSString *nick_name; //昵称
@property (nonatomic, copy) NSString *head_image; //头像
@property(nonatomic, strong) NSString *text;
@property (nonatomic, assign) int user_level; //等级
@property (nonatomic, copy) NSString *v_icon; //认证图标
@property (nonatomic, assign) NSInteger v_type; //认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString *sort_num; //该观众在当前直播间的排序权重
@property (nonatomic, copy) NSString  *group_id;
@property (nonatomic, copy) NSString  *room_id;
@property (nonatomic, copy) NSString  *live_in;

//直播回看列表
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *begin_time_format;
@property (nonatomic, copy) NSString *watch_number_format;

//关注主页
@property (nonatomic, copy) NSString *signature;//个性签名
@property (nonatomic, copy) NSString *sex;//性别
@property (nonatomic, copy) NSString *follow_id;


//搜索话题
@property (nonatomic, copy) NSString *cate_id;
@property (nonatomic, copy) NSString *num;

//1是公会长0是成员
@property (nonatomic, copy) NSString * family_chieftain;
//@property (nonatomic, assign) NSInteger guardian;





@property(nonatomic, strong) NSString *mysterious_picture;//神秘人头像
@property(nonatomic, strong) NSString *mysterious_name;//神秘人昵称
@property(nonatomic, strong) NSString *is_noble_mysterious;//是否有权限开启神秘人0否1是

@property(nonatomic, strong) NSString *star_box;//贵族边框


@property(nonatomic, strong) NSString *guardian_icon;//身份标识 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_gift;//专属礼物 1已开通 0没有权限
@property(nonatomic, strong) NSString *guardian_skin;//专属弹幕皮肤 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_img;//守护标识
@property(nonatomic, strong) NSString *guardian_broadcast;////开通守护全站广播 1 是
@property(nonatomic, strong) NSString *guardian_kick;
@property(nonatomic, strong) NSString *guardian_remind;
@property(nonatomic, strong) NSString *guardian_name;




@property (nonatomic, assign) NSInteger is_guardian;
@property (nonatomic, strong) BogoGuardianModel *guardianModel;


//主播昵称
@property(nonatomic, strong) NSString *host_nickname;



@end

