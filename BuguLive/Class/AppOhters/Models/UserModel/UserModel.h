//
//  UserModel.h
//  FanweApp
//
//  Created by fanwe2014 on 16/5/30.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cuserModel.h"
#import "AVIMAble.h"
#import "AppAble.h"
#import "BogoGuardianModel.h"

@interface UserModel : NSObject<IMUserAble>

//是否需要绑定
@property (nonatomic, assign) NSInteger     need_bind_mobile;
@property (nonatomic, copy) NSString *access_token;


@property (nonatomic, assign) NSInteger     live_in;        // 当前视频状态，对应的枚举为：FW_LIVE_STATE
@property (nonatomic, copy) NSString        *ID;
@property (nonatomic, copy) NSString        *user_id;       // 用户ID
@property (nonatomic, copy) NSString        *luck_num;      // 用户靓号ID
@property (nonatomic, copy) NSString        *nick_name;     // 昵称
@property (nonatomic, copy) NSString        *signature;     // 我的个性签名
@property (nonatomic, copy) NSString        *sex;           // 性别 0:未知, 1-男，2-女
@property (nonatomic, copy) NSString        *city;          // 所在城市
@property (nonatomic, copy) NSString        *is_focus;      // 是否关注
@property (nonatomic, copy) NSString        *focus_count;   // 关注数
@property (nonatomic, copy) NSString        *head_image;    // 用户头像
@property (nonatomic, copy) NSString        *fans_count;    // 粉丝数
@property (nonatomic, copy) NSString        *ticket;        // 印票数
@property (nonatomic, copy) NSString        *use_ticket;    // 印票数
@property (nonatomic, copy) NSString        *user_level;    // 会员级别
@property (nonatomic, copy) NSString        *use_diamonds;  // 累计消费的钻石数
@property (nonatomic, copy) NSString        *diamonds;      // 钻石，只有查看自己时才有这个参数
@property (nonatomic, copy) NSString        *v_type;        // 认证类型:0: 未认证;1:普通认证;2:企业认证;
@property (nonatomic, copy) NSString        *v_icon;        // 认证图标
@property (nonatomic, copy) NSString        *v_explain;     // 认证说明
@property (nonatomic, copy) NSString        *home_url;      // 被查看的用户：个人主页地址
@property (nonatomic, copy) NSString        *num;           // 印票
@property (nonatomic, copy) NSString        *total_num;     // 总的印票
@property (nonatomic, copy) NSString        *title;         // title
@property (nonatomic, assign) BOOL          is_robot;

@property (nonatomic, copy) NSString        *sort_num;      // 该观众在当前直播间的排序权重
@property(nonatomic, strong) NSDictionary   *item;
@property (nonatomic, assign) NSInteger     sdk_type;       // SDK类型 对应的枚举是：FW_LIVESDK_TYPE

//主页的一些模型字段
@property (nonatomic, copy) NSString        *has_admin;
@property (nonatomic, copy) NSString        *has_focus;
@property (nonatomic, copy) NSString        *has_black;     //是否被拉黑
@property (nonatomic, copy) NSString        *show_admin;
@property (nonatomic, copy) NSString        *show_tipoff;
@property (nonatomic, copy) NSString        *status;
@property (nonatomic, strong) cuserModel    *user;          //user的信息

//检查直播状态
@property (nonatomic, copy) NSString        *room_id;
@property (nonatomic, copy) NSString        *group_id;
@property (nonatomic, copy) NSString        *content;

//编辑页面的
@property (nonatomic, copy) NSString        *is_authentication; // 是否认证 0指未认证  1指待审核 2指认证 3指审核不通过
@property (nonatomic, copy) NSString        *birthday;          // 生日
@property (nonatomic, copy) NSString        *emotional_state;   // 是否已婚
@property (nonatomic, copy) NSString        *province;
@property (nonatomic, copy) NSString        *job;
@property (nonatomic, copy) NSString        *is_edit_sex;

//地区界面的参数
@property (nonatomic, copy) NSString        *number;

//支付页面的网址
@property (nonatomic, copy) NSString        *pay_url;
@property (nonatomic, copy) NSString        *goods_name;
@property (nonatomic, copy) NSString        *goods_icon;
@property (nonatomic, copy) NSString        *order_sn;

//修改昵称提示信息
@property (nonatomic, copy) NSString        *nick_info;

//2.5服务端做量化处理
@property (nonatomic, copy) NSString        *n_fans_count;       // 粉丝数
@property (nonatomic, copy) NSString        *n_ticket;           // 印票数
@property (nonatomic, copy) NSString        *n_focus_count;      // 关注数
@property (nonatomic, copy) NSString        *n_use_diamonds;     // 累计消费的钻石数


//座驾
@property (nonatomic, copy) NSString            *car_name; //座驾名称
@property (nonatomic, copy) NSString            *car_svga; //svga地址
@property (nonatomic, assign) int                 has_car; //svga地址
@property(nonatomic, strong) NSString               *isvip;//是否是vip
@property(nonatomic, strong) NSString               *is_vip;//是否是vip


@property ( nonatomic, copy) NSString *is_noble_stealth ;//  是否隐身
@property ( nonatomic, copy) NSString *noble_vip_type ;//  "0不是贵族1是贵族",
@property ( nonatomic, copy) NSString *noble_is_avatar;//  "0没有，1有；贵族头像",
@property ( nonatomic, copy) NSString *noble_car;//  "0没有，1有；贵族座驾",
@property ( nonatomic, copy) NSString *noble_special_effects;//  '0没有，1有；贵族特效' ,
@property ( nonatomic, copy) NSString *noble_medal;//  "0没有，1有；贵族勋章",
@property ( nonatomic, copy) NSString *noble_experience;//  "0没有，1有；经验加成",
@property ( nonatomic, copy) NSString *noble_barrage;//  "0没有，1有；贵族弹幕",
@property ( nonatomic, copy) NSString *noble_silence;//  "0没有，1有；贵族防禁言",
@property ( nonatomic, copy) NSString *noble_stealth;//  "0没有，1有；贵族隐身",
@property ( nonatomic, copy) NSString *noble_avatar;//  "贵族头像图片",
@property ( nonatomic, copy) NSString *noble_icon;//  "贵族图标",
@property ( nonatomic, copy) NSString *noble_shop;//  "贵族图标",
@property ( nonatomic, copy) NSString *noble_name;//  "贵族名称",
@property ( nonatomic, copy) NSString *user_level_color;//  "用户等级颜色值",
@property ( nonatomic, copy) NSString *noble;//  "购买贵族会员h5链接",
@property ( nonatomic, copy) NSString *nobleid;

@property ( nonatomic, copy) NSString *members_url;//  "购买vip会员h5链接",
@property ( nonatomic, copy) NSString *luck_num_url;//  '在这个接口添加了 我的靓号地址链接',
@property ( nonatomic, copy) NSString *guardian_list_url;//:'守护h5页面链接地址',
@property(nonatomic, strong) NSString *noble_car_url;

@property(nonatomic, strong) NSString *pk_id;

@property (nonatomic, copy) NSString *noble_car_name;

@property(nonatomic, strong) NSString *star_box;//贵族明星框

@property(nonatomic, strong) NSString *is_noble_mysterious;
@property(nonatomic, strong) NSString *is_noble_ranking_stealth;

@property(nonatomic, strong) NSString *shop_status;


@property(nonatomic, assign) NSString *is_open_young;

//@property(nonatomic, strong) NSString *total_num;//贡献值

@property (nonatomic, assign) NSInteger is_guardian; //守护状态,1是守护,2不是守护
@property(nonatomic, strong) BogoGuardianModel *guardianModel;


@property(nonatomic, strong) NSString *guardian_icon;//身份标识 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_gift;//专属礼物 1已开通 0没有权限
@property(nonatomic, strong) NSString *guardian_skin;//专属弹幕皮肤 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_img;//守护标识
@property(nonatomic, strong) NSString *guardian_broadcast;////开通守护全站广播 1 是
@property(nonatomic, strong) NSString *guardian_kick;
@property(nonatomic, strong) NSString *guardian_remind;

@property(nonatomic, strong) NSString *avatar_frame_url;


@property(nonatomic, strong) NSString *country_code;
@property(nonatomic, strong) NSString *country_name;
@property(nonatomic, strong) NSString *country_img;

@property(nonatomic, strong) NSString *is_voice;
@property(nonatomic, strong) NSString *password;
@end
