//
//  VoiceHTTPManger.h
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/15.
//  Copyright © 2022 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceHTTPManger : NSObject
@property(nonatomic, strong) CurrentLiveInfo *live_info;
//请求上麦
- (void)requestApplyWheat:(NSString *)wheat_id block:(CommonBlock)block;

//上下麦
- (void)requestUpdWheatUser:(NSString *)wheat_id toUserID:(NSString *)touid status:(NSString *)status block:(CommonBlock)block;

//禁止说话
- (void)requestBanVoice:(NSString *)wheat_id toUserID:(NSString *)touid second:(NSString *)second block:(CommonBlock)block;

//修改麦位类型
- (void)setWheatApplyTypeWheatId:(NSString *)wheat_id type:(NSString *)type block:(CommonBlock)block;

//申请人列表
- (void)requestWheatListType:(NSString *)type block:(CommonBlock)block;
@end

NS_ASSUME_NONNULL_END
