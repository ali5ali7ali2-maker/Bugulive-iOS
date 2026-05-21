//
//  CurrentLiveInfo.h
//  BuguLive
//
//  Created by xfg on 16/6/1.
//  Copyright © 2016年 xfg. All rights reserved.
//  获得当前直播的信息

#import <Foundation/Foundation.h>
#import "shareModel.h"
#import "PodcastModel.h"

#import "BogoShopKit.h"

#import "BogoGuardianModel.h"

@interface Even_wheat :NSObject
@property (nonatomic , assign) NSInteger              id;
@property (nonatomic , assign) NSInteger              gift_earnings;
@property (nonatomic , copy) NSString              * head_image;
@property (nonatomic , assign) NSInteger              video_id;
@property (nonatomic , assign) NSInteger              endtime;
@property (nonatomic , assign) NSInteger              is_kick_out;
@property (nonatomic , assign) NSInteger              addtime;
@property (nonatomic , copy) NSString              * nick_name;
@property (nonatomic , assign) NSInteger              user_id;
@property (nonatomic , assign) NSInteger              is_ban_voice;
@property (nonatomic , assign) NSInteger              location;
@property (nonatomic , assign) NSInteger              the_gift_earnings;
@property (nonatomic , assign) NSInteger              is_admin;
@property (nonatomic , assign) NSInteger              status;
@property(nonatomic, strong) NSString *avatar_frame_url;


@end

@interface Wheat_Type_List :NSObject
@property (nonatomic , copy) NSString              * wheat_id;
@property (nonatomic , assign) NSInteger              is_wheat;
@property (nonatomic , copy) NSString              * wheat_name;
@property (nonatomic , assign) NSInteger              type;
@property (nonatomic , strong) Even_wheat              * even_wheat;
@property(nonatomic, assign) NSUInteger totalVolume;
@property(nonatomic, strong) NSString *face_img;
@end

@interface CurrentLiveInfo : NSObject

@property(nonatomic, strong) BogoCommodityDetailShopModel *shop_goods;

@property (nonatomic, copy) NSString        *room_id;           // 房间ID
@property (nonatomic, copy) NSString        *user_id;           // 主播ID
@property (nonatomic, copy) NSString        *luck_num;          // 靓号
@property (nonatomic, copy) NSString        *group_id;          // 聊天群ID
@property (nonatomic, copy) NSString        *cont_url;          // 印票贡献榜地址
@property (nonatomic, assign) NSInteger     viewer_num;         // 当前房间人数
@property (nonatomic, assign) NSInteger     online_status;      // 1:主播在线；0：主播离开
@property (nonatomic, assign) NSInteger     live_in;            // 当前视频状态，对应的枚举为：FW_LIVE_STATE

@property (nonatomic, strong) PodcastModel  *podcast;           // 主播信息
@property (nonatomic, strong) ShareModel    *share;             // 分享信息
@property(nonatomic, strong) NSString *voice_bg_image;
@property (nonatomic, assign) NSInteger     pai_id;
@property (nonatomic, assign) NSInteger     game_log_id;        // 游戏轮数id
// 直播、回播
@property (nonatomic, copy) NSString        *play_url;          // 点播播放地址
@property (nonatomic, copy) NSString        *push_rtmp;         // 直播中主播推流地址
@property (nonatomic, copy) NSString        *push_url;          // 推流地址；主播时有效
@property (nonatomic, copy) NSString        *push_type;          // 推流地址；主播时有效
@property (nonatomic, assign) NSInteger     has_video_control;  // 点播时，视频控制操作（是否显示播放进度条等）
@property (nonatomic, assign) NSInteger     sdk_type;           // SDK类型 对应的枚举是：FW_LIVESDK_TYPE

@property (nonatomic, copy) NSString        *live_fee;          // 每场或者每分钟钻石数量
@property (nonatomic, assign) NSInteger     is_live_pay;        // 是否有付费直播 1：该直播间已经开启了付费直播
@property (nonatomic, assign) NSInteger     live_pay_type;      // 0：按时间付费直播 1:按场付费直播
@property (nonatomic, assign) NSInteger     is_pay_over;        // 该参数是否付费过 1:付费过 0:未付费
@property (nonatomic, assign) NSInteger     join_room_prompt;   // 是否可以发送“来了”消息

@property (nonatomic, assign) NSInteger     is_vip;             // 当前用户是否vip会员
@property (nonatomic, assign) NSInteger     create_type;        // 0：手机直播 1：pc直播

@property (nonatomic, copy) NSString        *video_title;       // 视频类型名称，显示在视频左上角（不为空的时候才显示，为空时按本地的逻辑）

@property (nonatomic, copy) NSString        *share_type;        // 分享类型
@property (nonatomic, copy) NSString        *is_private;        // 是否私密直播
@property (nonatomic, copy) NSString        *private_share;     // 私密key

@property (nonatomic, assign) NSInteger     has_lianmai;        // 1:显示连麦按钮; 0:不显示连麦按钮

@property (nonatomic, assign) NSInteger        is_guardian;           //是否是守护,1是守护,2不是守护

@property(nonatomic, strong) NSString *noble_icon;
@property(nonatomic, strong) NSString *total_num;

//守护权限model
@property(nonatomic, strong) BogoGuardianModel *guardianModel;
@property(nonatomic, strong) NSString *guardian_icon;//身份标识 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_gift;//专属礼物 1已开通 0没有权限
@property(nonatomic, strong) NSString *guardian_skin;//专属弹幕皮肤 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_img;//守护标识
@property(nonatomic, strong) NSString *guardian_broadcast;////开通守护全站广播 1 是
@property(nonatomic, strong) NSString *guardian_kick;
@property(nonatomic, strong) NSString *guardian_remind;
@property(nonatomic, strong) NSString *agora_token;

@property(nonatomic, strong) NSArray *wheat_type_list;

@property(nonatomic, strong) NSString *announcement;
@property(nonatomic, assign) int user_role;//1房主，2是管理员，3是普通用户
@end
