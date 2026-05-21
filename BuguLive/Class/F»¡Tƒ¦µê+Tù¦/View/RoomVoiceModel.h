//
//  RoomVoiceModel.h
//  UniversalApp
//
//  Created by bogokj on 2019/8/7.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RoomWheatTypeModel : NSObject

//        "wheat_id":"上麦位置",
//        "type":'1设置申请上麦0直接上麦'

@property(nonatomic, copy) NSString *wheat_id;
@property(nonatomic, copy) NSString *type;

@end

@interface RoomVoiceModel : NSObject

//user_nickname":"开启语音房间人昵称",
//"avatar":"开启语音房间人头像",
//"title":"开启语音房间标题",
//"id":'房间id',
//"group_id":'群组id',
//"user_id":'用户id',
//'voice_bg_image':'房间背景图片路径',
//'voice_status':'0无1密码房间',
//'voice_psd':'密码',
//'voice_avatar':'房间缩略图',
//'announcement':'房间公告',
//'voice_type':'语音房间类型id',

@property(nonatomic, copy) NSString *user_nickname;
@property(nonatomic, copy) NSString *user_id;
@property(nonatomic, copy) NSString *avatar;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *group_id;
@property(nonatomic, copy) NSString *voice_bg_image;
@property(nonatomic, copy) NSString *voice_status;
@property(nonatomic, copy) NSString *voice_psd;
@property(nonatomic, copy) NSString *voice_avatar;
//@property(nonatomic, strong) NSArray *wheat_type;
@property(nonatomic, copy) NSString *voice_type;
@property(nonatomic, copy) NSString *announcement;
@property(nonatomic, copy) NSString *is_focus;
@property(nonatomic, copy) NSString *luck;
@property(nonatomic, copy) NSString *type;
@property(nonatomic, copy) NSString *live_in;
@property(nonatomic, copy) NSString *online_number;
@property(nonatomic, copy) NSString *online_count;
@property(nonatomic, copy) NSString *voice_label;

@property(nonatomic, copy) NSString *host_more_voice_ratio;

@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *watch_number;
@property(nonatomic, assign) BOOL is_collect;//收藏

@property(nonatomic, copy) NSString *room_type;//1交友 2派单


@end

NS_ASSUME_NONNULL_END
