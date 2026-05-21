//
//  VoiceHTTPManger.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/15.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "VoiceHTTPManger.h"

@implementation VoiceHTTPManger

//直接上麦

- (void)requestApplyWheat:(NSString *)wheat_id block:(CommonBlock)block{
    [[BGHUDHelper sharedInstance] syncLoading];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"apply_wheat" forKey:@"act"];
    [dict setValue:self.live_info.room_id forKey:@"room_id"];
    [dict setValue:wheat_id forKey:@"wheat_id"];
    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        block(responseJson);
        [self showError:responseJson];

        [[BGHUDHelper sharedInstance] syncStopLoading];
        
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
}


//

/*
  上下麦
 status

 wheat_id 暂时不用传了
 麦位状态：1上麦成功 2拒绝上麦 3结束上麦(下麦)
 
 */

- (void)requestUpdWheatUser:(NSString *)wheat_id toUserID:(NSString *)touid status:(NSString *)status block:(CommonBlock)block{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"upd_wheat_user" forKey:@"act"];
    [dict setValue:self.live_info.room_id forKey:@"room_id"];
    [dict setValue:touid forKey:@"to_user_id"];
    [dict setValue:status forKey:@"status"];
    
    [[BGHUDHelper sharedInstance] syncLoading];

    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        block(responseJson);
        [self showError:responseJson];

        [[BGHUDHelper sharedInstance] syncStopLoading];

    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
}


//禁止说话
/*
 second 禁止说话状态：0解除1禁止
 */
- (void)requestBanVoice:(NSString *)wheat_id toUserID:(NSString *)touid second:(NSString *)second block:(CommonBlock)block{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"user_ban_voice" forKey:@"act"];
    [dict setValue:self.live_info.room_id forKey:@"room_id"];
    [dict setValue:touid forKey:@"to_user_id"];
    [dict setValue:second forKey:@"second"];
    
    [[BGHUDHelper sharedInstance] syncLoading];

    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        block(responseJson);
        [self showError:responseJson];

        [[BGHUDHelper sharedInstance] syncStopLoading];

    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];

    }];
}

//等待申请列表
// type: 0=申请列表，1=已上麦人管理列表
- (void)requestWheatListType:(NSString *)type block:(CommonBlock)block{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"get_wheat_list" forKey:@"act"];
    [dict setValue:self.live_info.room_id forKey:@"room_id"];
    [dict setValue:type forKey:@"type"];
    [[BGHUDHelper sharedInstance] syncLoading];

    
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
        block(responseJson);
        [self showError:responseJson];

    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
}


/*
  修改麦位类型
 type

 麦位权限：0直接上麦 1申请上麦 2锁定上麦
 
 */

- (void)setWheatApplyTypeWheatId:(NSString *)wheat_id type:(NSString *)type block:(CommonBlock)block{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"wheat_apply" forKey:@"act"];
    [dict setValue:self.live_info.room_id forKey:@"room_id"];
    [dict setValue:wheat_id forKey:@"wheat_id"];
    [dict setValue:type forKey:@"type"];

    [[BGHUDHelper sharedInstance] syncLoading];

    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        block(responseJson);
        [[BGHUDHelper sharedInstance] syncStopLoading];
        [self showError:responseJson];
    } FailureBlock:^(NSError *error) {
        [[BGHUDHelper sharedInstance] syncStopLoading];
    }];
}

- (void)showError:(NSDictionary *)res {
    
    if (![res[@"error"] isEqualToString:@""])
    {
        [[BGHUDHelper sharedInstance] tipMessage:res[@"error"]];
    }
    

}
@end
