//
//  RoomUserInfo.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomUserInfo : NSObject

//    "id":'连麦id',
//    "voice_id":'房间id',
//    "user_id":'用户id',
//    "status":'0申请中1进行中2拒绝连麦3结束连麦',
//    "location":'位置',
//    "gift_earnings":'礼物收益',
//    "user_name":"用户昵称",
//    "user_img":"用户头像",
//    "addtime":'进入时间',
//    "endtime":'离开时间',

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *voice_id;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *status;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *gift_earnings;
@property(nonatomic, copy) NSString *gift_coin;
@property(nonatomic, copy) NSString *user_name;
@property(nonatomic, copy) NSString *user_img;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *endtime;

//"user_id":'语音房间右上角用户id',
//"user_nickname":"语音房间右上角用户名称",
//"sex":'语音房间右上角用户性别',
//"avatar":"语音房间右上角用户头像"

@property(nonatomic, copy) NSString *nick_name;
@property(nonatomic, copy) NSString *sex;
@property(nonatomic, copy) NSString *head_image;

//"id":'用户id',
//"user_nickname":"用户昵称",
//"avatar":"用户头像",
//"level":'用户等级',
//"sex":'1男2女',
//"signature":"个性签名",
//"address":"地址",
//"is_auth":'是否认证1已认证',
//"vip_end_time":'vip到期时间',
//"birthday":'生日',
//'focus':'0为关注1已关注',
@property(nonatomic, copy) NSString *level;
@property(nonatomic, copy) NSString *signature;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, copy) NSString *is_auth;
@property(nonatomic, copy) NSString *vip_end_time;
@property(nonatomic, copy) NSString *birthday;
//@property(nonatomic, copy) NSString *focus;
@property(nonatomic, assign) BOOL focus;

@property(nonatomic, assign) NSInteger attention_fans;

//@property(nonatomic, strong) NSString *attention_fans;


@property(nonatomic, copy) NSString *is_admin;
@property(nonatomic, copy) NSString *is_host;

@property(nonatomic, copy) NSString *is_kick_out;
@property(nonatomic, copy) NSString *is_black;

@property(nonatomic, assign) BOOL selected;

//'is_ban_voice':'是否禁止发音 1禁0否',
@property(nonatomic, copy) NSString *is_ban_voice;

//"total_diamonds":"贡献值",
//"coin":0,
//'ranking':'排名位置：0未上榜',
@property(nonatomic, copy) NSString *total_diamonds;
@property(nonatomic, copy) NSString *ranking;
@property(nonatomic, copy) NSString *total_ticket;

//"medal_id": 0,
//"medal_end_time": 0,
//"demal_icon": "",
//"demal_name": "",
//"demal_time": ""

@property(nonatomic, copy) NSString *medal_id;
@property(nonatomic, copy) NSString *medal_end_time;
@property(nonatomic, copy) NSString *medal_icon;
@property(nonatomic, copy) NSString *medal_name;
@property(nonatomic, copy) NSString *medal_time;

@property(nonatomic, copy) NSString *constellation;

@property(nonatomic, copy) NSString *face_img;

@property(nonatomic, assign) NSInteger volume;

@property(nonatomic, assign) BOOL isMuted;

//是否在房间
@property(nonatomic, copy) NSString *is_room;

//房间榜单
//title": "千城",
//"room_img": "http:\/\/videoline.qiniu.bugukj.com\/e8554201909031538233550.jpg",
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *room_img;
@property(nonatomic, copy) NSString *luck;

@property(nonatomic, copy) NSString *user_status;
@property(nonatomic, copy) NSString *coin;
@property(nonatomic, copy) NSString *is_online;
@property(nonatomic, copy) NSString *link_id;
@property(nonatomic, copy) NSString *audio_file;
@property(nonatomic, copy) NSString *city;
@property(nonatomic, copy) NSString *province;
@property(nonatomic, copy) NSString *visualize_name;
@property(nonatomic, copy) NSString *audio_time;
@property(nonatomic, copy) NSString *age;
@property(nonatomic, copy) NSString *charging_coin;

@property(nonatomic, strong) NSArray <RoomUserInfo *>*ranking_three;

@property(nonatomic, copy) NSString *income_level;

@property(nonatomic, copy) NSString *headwear_url;

@property(nonatomic, copy) NSString *is_voice_online;

@property(nonatomic, copy) NSString *is_vip;




//"ranking": 1,
//"coin_sum": "10.00"
@property(nonatomic, copy) NSString *coin_sum;


@property(nonatomic, copy) NSString *noble_img;

@property(nonatomic, copy) NSString *noble_name;

@property(nonatomic, copy) NSNumber *is_noble;

@property(nonatomic, strong) NSArray *privilege_id;


@property (nonatomic,copy) NSString *talker_level_name;/**<*/
@property (nonatomic,copy) NSString *talker_level_img;/**<*/
@property (nonatomic,copy) NSString *player_level_name;/**<*/
@property (nonatomic,copy) NSString *player_level_img;/**<*/

@property(nonatomic, strong) NSString *user_name_colors;

@property(nonatomic, strong) NSString * nickname_card_url;//昵称铭牌
@property(nonatomic, strong) NSString * business_card_url;//定制名片
//@property(nonatomic, strong) NSString * chat_bubble_url;//气泡
@property(nonatomic, strong) NSString * badge_url;//徽章

@property(nonatomic, strong) NSString * the_gift_earnings;//
@property(nonatomic, strong) NSString * mike_url;

//点单队列-主持
@property(nonatomic, assign) BOOL roomOrderHost;
@property(nonatomic, assign) BOOL roomOrder;

@property(nonatomic, strong) NSString *is_room_administrator;
//@property(nonatomic, strong) NSString *nick_name;
@end

NS_ASSUME_NONNULL_END
