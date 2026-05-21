//
//  AppViewModel.m
//  BuguLive
//
//  Created by xfg on 16/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AppViewModel.h"

@implementation AppViewModel

#pragma mark 客户在线情况监测
/**
 提交在线、离线接口

 @param status Login：在线 Logout：离线
 */
+ (void)userStateChange:(NSString *)status
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }
    
    if (![BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.on_line_group_id])
    {
        if ([status isEqualToString:@"Login"])
        {
            [[V2TIMManager sharedInstance] joinGroup:[GlobalVariables sharedInstance].appModel.on_line_group_id msg:nil succ:^{
                NSLog(@"大群==成功");
            } fail:^(int code, NSString *desc) {
                
            }];
            
            /*[[TIMGroupManager sharedInstance] joinGroup:[GlobalVariables sharedInstance].appModel.on_line_group_id msg:nil succ:^{
                NSLog(ASLocalizedString(@"加入在线用户大群成功"));
            } fail:^(int code, NSString *msg) {
                NSLog(ASLocalizedString(@"加入在线用户大群失败，错误码：%d，错误原因：%@"),code,msg);
            }];*/
        }
        else if ([status isEqualToString:@"Logout"])
        {
            if (![BGUtils isBlankString:[GlobalVariables sharedInstance].appModel.on_line_group_id]) {
//                [[TIMGroupManager sharedInstance] quitGroup:[GlobalVariables sharedInstance].appModel.on_line_group_id succ:^{
//                    NSLog(ASLocalizedString(@"退出在线用户大群成功"));
//                } fail:^(int code, NSString *msg) {
//                    NSLog(ASLocalizedString(@"退出在线用户大群失败，错误码：%d，错误原因：%@"),code,msg);
//                }];
                
                [[V2TIMManager sharedInstance] quitGroup:[GlobalVariables sharedInstance].appModel.on_line_group_id succ:^{
                    
                } fail:^(int code, NSString *desc) {
                    
                }];
            }
        }
    }
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"state_change" forKey:@"act"];
    [mDict setObject:status forKey:@"action"];
    
    [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma mark 上传当前用户设备号
+ (void)updateApnsCode
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }
    
    GlobalVariables *BuguLive = [GlobalVariables sharedInstance];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"user" forKey:@"ctl"];
    [mDict setObject:@"apns" forKey:@"act"];
    if (![BGUtils isBlankString:BuguLive.deviceToken])
    {
        [mDict setObject:BuguLive.deviceToken forKey:@"apns_code"];
        
        [[NetHttpsManager manager] POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
            
            NSLog(@"===:%@",responseJson);
            
        } FailureBlock:^(NSError *error) {
            
        }];
    }
}

#pragma mark 重新加载初始化接口
+ (void)loadInit
{
    GlobalVariables *BuguLive = [GlobalVariables sharedInstance];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"app" forKey:@"ctl"];
    [parmDict setObject:@"init" forKey:@"act"];
    
    NSString *postUrl;
    
#if kSupportH5Shopping
    postUrl = H5InitUrlStr;
#else
    postUrl = BuguLive.currentDoMianUrlStr;
#endif
    
    [[NetHttpsManager manager] POSTWithUrl:postUrl paramDict:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         BuguLive.appModel = [AppModel mj_objectWithKeyValues:responseJson];
         if (BuguLive.listMsgMArray)
         {
             [BuguLive.listMsgMArray removeAllObjects];
         }
         
         NSArray *listmsg = [responseJson objectForKey:@"listmsg"];
         if (listmsg && [listmsg isKindOfClass:[NSArray class]])
         {
             for (NSDictionary *tmpDic in listmsg)
             {
                 CustomMessageModel *customMessageModel = [CustomMessageModel mj_objectWithKeyValues:tmpDic];
                 [customMessageModel prepareForRender];
                 [BuguLive.listMsgMArray addObject:customMessageModel];
             }
         }
         
     } FailureBlock:^(NSError *error) {
         
     }];
}

@end
