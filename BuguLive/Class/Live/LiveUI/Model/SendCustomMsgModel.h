//
//  SendCustomMsgModel.h
//  BugoLive
//
//  Created by xfg on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BogoShopKit.h"
#import "BogoGuardianModel.h"

@interface SendCustomMsgModel : NSObject

@property (nonatomic, assign) int               msgType;        // 消息类型(必填)
@property (nonatomic, copy) NSString            *msg;           // 消息
@property (nonatomic, copy) NSString            *chatGroupID;   // 如果是群消息必须带上群ID(群消息时必填)
@property (nonatomic, strong) id<IMUserAble>    msgReceiver;    // 消息接收者（C2C消息时必填）
@property (nonatomic, assign) BOOL              isShowLight;    // 是否显示点亮消息（点亮消息时必填）

// 连麦
@property (nonatomic, copy) NSString            *push_rtmp2;    // 小主播的 push_rtmp 推流地址
@property (nonatomic, copy) NSString            *play_rtmp_acc; // 大主播的 rtmp_acc 播放地址

@property (nonatomic, copy) NSString            *pkid; //pk的id
//@property (nonatomic, assign) NSInteger guardian;//守护状态,1是守护,2不是守护
@property (nonatomic, assign) NSInteger is_guardian;//守护状态,1是守护,2不是守护
@property (nonatomic, copy) NSString *noble_icon;

@property (nonatomic, copy) NSString *is_vip;//vip状态,1是vip

//商品详情model

@property(nonatomic, strong) BogoCommodityDetailModel *shopModel;
//守护权限model
@property(nonatomic, strong) BogoGuardianModel *guardianModel;
@property(nonatomic, strong) NSString *guardian_icon;//身份标识 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_gift;//专属礼物 1已开通 0没有权限
@property(nonatomic, strong) NSString *guardian_skin;//专属弹幕皮肤 1已开通 0没权限
@property(nonatomic, strong) NSString *guardian_img;//守护标识
@property(nonatomic, strong) NSString *guardian_broadcast;////开通守护全站广播 1 是
@property(nonatomic, strong) NSString *guardian_kick;
@property(nonatomic, strong) NSString *guardian_remind;
@property(nonatomic, strong) NSString *link_mic_user_id;
@property (nonatomic, assign) NSInteger         mute_status;// ==============方法================
@property (nonatomic, copy) NSString            *to_user_id;        // 礼物接收人（主播）
@property(nonatomic, strong) NSString *faceUrl;

@end
