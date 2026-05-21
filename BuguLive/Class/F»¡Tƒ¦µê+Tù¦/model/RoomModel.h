//
//  RoomModel.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/7.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RoomVoiceModel.h"
#import "CurrentLiveInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface RoomUserModel : NSObject

@property(nonatomic, copy) NSString *is_kick_out;
@property(nonatomic, copy) NSString *is_admin;
@property(nonatomic, copy) NSString *is_host;
@property(nonatomic, copy) NSString *is_ban_voice;
@property(nonatomic, copy) NSString *level;
//"car_url":"http://videoline.qiniu.bugukj.com/'admin/20200116/9603c6acc1ab6dcab9290f04f211f0db.png'",
//"car_name":"奔驰1",
//"car_svga_url":"http://videoline.qiniu.bugukj.com/'admin/20200116/9a898aca6c951bb29fa9d63863bfdc72.svga'",
//"headwear_url":"http://videoline.qiniu.bugukj.com/'admin/20200116/45fe9125c9592c8b2daa2aac71a91306.png'",
//"headwear_name":"头饰1",
//"chat_bubble_url":"http://videoline.qiniu.bugukj.com/'admin/20200116/c3a8cb7026649f08324ec3b81a014735.png'",
//"chat_bubble_name":"气泡1"
@property(nonatomic, copy) NSString *car_url;
@property(nonatomic, copy) NSString *car_svga_url;
@property(nonatomic, copy) NSString *car_name;
@property(nonatomic, copy) NSString *d;
@property(nonatomic, copy) NSString *headwear_url;
@property(nonatomic, copy) NSString *headwear_name;
@property(nonatomic, copy) NSString *chat_bubble_url;
@property(nonatomic, copy) NSString *chat_bubble_name;

@property(nonatomic, copy) NSString *income_level;

@property(nonatomic, copy) NSString *is_vip;
@property(nonatomic, strong) NSString * noble_img; //贵族图标
@property(nonatomic, strong) NSString * user_name_colors;//昵称变色
@property(nonatomic, strong) NSString * entry_effects;//贵族特效

@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *user_nickname;

@property(nonatomic, strong) NSString * nickname_card_url;//昵称铭牌
@property(nonatomic, strong) NSString * business_card_url;//定制名片
//@property(nonatomic, strong) NSString * chat_bubble_url;//气泡
@property(nonatomic, strong) NSString * badge_url;//徽章

@end

@interface RoomModel : NSObject

//"code":1,
//"msg":"",
//"user_list":[{
//    "user_id":'语音房间右上角用户id',
//    "user_nickname":"语音房间右上角用户名称",
//    "sex":'语音房间右上角用户性别',
//    "avatar":"语音房间右上角用户头像"
//}],
//"user_list_sum":'语音房间右上角用户总人数',
//"even_wheat":[{
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
//}],
//"voice":{
//    "user_nickname":"开启语音房间人昵称",
//    "avatar":"开启语音房间人头像",
//    "title":"开启语音房间标题",
//    "id":'房间id',
//    "group_id":'群组id',
//    "user_id":'用户id',
//    'voice_bg_image':'房间背景图片路径',
//    "wheat_type":[{
//        "wheat_id":"上麦位置",
//        "type":'1设置申请上麦0直接上麦'
//    }]
//}

@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *msg;
@property(nonatomic, strong) NSArray *user_list;
@property(nonatomic, copy) NSString *user_list_sum;
@property(nonatomic, strong) NSArray *even_wheat;
@property(nonatomic, strong) RoomVoiceModel *voice;
@property(nonatomic, strong) RoomUserModel *user;
@property(nonatomic, copy) NSString *share_voice;
@property(nonatomic, strong)   NSString * dispatch_status;
@property(nonatomic, strong) NSArray<Wheat_Type_List *> *wheat_type_list;

@end

NS_ASSUME_NONNULL_END
