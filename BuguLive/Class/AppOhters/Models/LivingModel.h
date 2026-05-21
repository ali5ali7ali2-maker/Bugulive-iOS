//
//  LivingModel.h
//  BuguLive
//
//  Created by xfg on 16/5/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LivingModel : NSObject

@property (nonatomic, assign) int           room_id;
@property (nonatomic, copy) NSString        *group_id;
@property (nonatomic, copy) NSString        *user_id;       // 直播者ID

@property (nonatomic, copy) NSString        *id;
//首页-最新
@property (nonatomic, copy) NSString        *city;
@property (nonatomic, copy) NSString        *user_level;
@property (nonatomic, copy) NSString        *head_image;
@property (nonatomic, copy) NSString        *thumb_head_image;
@property (nonatomic, copy) NSString        *live_image;
@property (nonatomic, assign) NSInteger     live_in;        // 当前视频状态，对应的枚举为：FW_LIVE_STATE
@property (nonatomic, assign) NSInteger     sdk_type;       // SDK类型 对应的枚举是：FW_LIVESDK_TYPE
@property (nonatomic, assign) NSInteger     room_type;      // 1:私密直播;3:直播 xponit

@property (nonatomic, assign) float         xponit;         // 经度
@property (nonatomic, assign) float         yponit;         // 维度
@property (nonatomic, assign) float         distance;       // 距离

@property (nonatomic, strong) NSString      *today_create;  // 新人标识（1.是 0.否）
@property (nonatomic, strong) NSString      *is_live_pay;   // 付费直播（1.是 0.否）

//鲜肉
@property (nonatomic, copy) NSString *fans_count;            //粉丝数
@property (nonatomic, copy) NSString *focus_count;           //关注数
@property (nonatomic, copy) NSString *is_authentication;     //是否认证
@property (nonatomic, copy) NSString *nick_name;
@property (nonatomic, copy) NSString *title;



@property (nonatomic, copy) NSString *watch_number;

@property (nonatomic, copy) NSString *game_name;
@property (nonatomic, copy) NSString *is_gaming;
@property (nonatomic, copy) NSString *live_pay_type;//直播类型按场还是按时
@property (nonatomic, copy) NSString *live_fee;

@property (nonatomic, copy) NSString *is_video_pk;

@property(nonatomic, strong) NSString *labels;
@property(nonatomic, strong) NSString *lable_title;
@property(nonatomic, strong) NSString *lable_color;

@property(nonatomic, strong) NSString *password;
@property(nonatomic, assign) BOOL is_voice;
@end
