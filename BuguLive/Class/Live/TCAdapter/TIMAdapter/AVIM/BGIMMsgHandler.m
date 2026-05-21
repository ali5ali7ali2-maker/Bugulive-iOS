//
//  BGIMMsgHandler.m
//  BugoLive
//
//  Created by xfg on 16/11/24.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BGIMMsgHandler.h"
#import "V2TIMMessage+CY.h"
@interface BGIMMsgHandler()<V2TIMAdvancedMsgListener>

@end
@implementation BGIMMsgHandler

- (void)dealloc
{
    _sharedRunLoopRef = nil;
}

BogoSingletonM(Instance);

- (id)init
{
    @synchronized (self)
    {
        self = [super init];
        if (self)
        {
            _BuguLive = [GlobalVariables sharedInstance];
            _newMsgMArray = [NSMutableArray array];
            // 为了不影响视频，runloop线程优先级较低，可根据自身需要去调整
            _sharedRunLoopRef = [AVIMRunLoop sharedAVIMRunLoop];
            
            _msgCacheLock = OS_SPINLOCK_INIT;
            
            TIMManager *manager = [TIMManager sharedInstance];
            //[manager setMessageListener:self];
            [manager addMessageListener:self];
            //V2TIMSDKListener V2TIMGroupListener
//            [[V2TIMManager sharedInstance] addIMSDKListener:self];
//            [[V2TIMManager sharedInstance] addGroupListener:self];
            
            [[V2TIMManager sharedInstance] addAdvancedMsgListener:self];
            [[V2TIMManager sharedInstance] addGroupListener:self];
        }
        return self;
    }
}

#pragma mark - ----------------------- 接收并处理消息 -----------------------
#pragma mark 从缓存中取出maxDo条数据处理

//系统消息
- (void)onReceiveRESTCustomData:(NSString *)groupID data:(NSData *)data
{
    V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:data];
    [msg qmui_bindObject:groupID forKey:@"groupID2"];
//    [msg setValue:groupID forKey:@"groupID"];
//    if (_liveItem)  // 直播间内的群消息
//    {
//        if([groupID isEqualToString:[_liveItem liveIMChatRoomId]])
//        {
//            // 处理群聊天消息
//            [_newMsgMArray addObject:msg];
//
//        }
//    }
//    else
//    {
//        [self onRecvMsg:msg msgType:V2TIM_GROUP];
//    }
    
    [self onRecvMsg:msg msgType:TIM_SYSTEM];

    
}
- (void)onHandleMyNewMessage:(NSInteger)maxDo
{
    NSInteger myIndex = 0;
    
    while ([_newMsgMArray count]>0)
    {
        TIMMessage *msg = [_newMsgMArray firstObject];
        [_newMsgMArray removeObject:msg];
        
        [self onRecvMsg:msg msgType:TIM_GROUP];
        myIndex ++;
        if (myIndex == maxDo)
        {
            return;
        }
    }
}

#pragma mark 循环消息处
- (void)onNewMessage:(NSArray *)msgs
{
//    [self performSelector:@selector(onHandleNewMessage:) onThread:_sharedRunLoopRef.thread withObject:msgs waitUntilDone:NO];
}

- (void)onRecvNewMessage:(V2TIMMessage *)msg
{
    [self performSelector:@selector(onHandleNewMessageV2:) onThread:_sharedRunLoopRef.thread withObject:msg waitUntilDone:NO];
}

#pragma mark 循环消息处理时收到消息后判断消息类型
- (void)onHandleNewMessageV2:(V2TIMMessage *)msg
{
 
    [SIMMsgObj maybeIMChatMsg:msg];
    
    NSString *rid = [msg userID];
    
    if(rid != nil)
    {
        [self onRecvMsg:msg msgType:V2TIM_C2C];
    }
    else
    {
        if (_liveItem)  // 直播间内的群消息
        {
            //大群消息在这里处理
            NSLog(@"[msg groupID] 收到的群组消息 群ID :%@",[msg groupID]);
            NSLog(@"[GlobalVariables sharedInstance].appModel.on_line_group_id 大群id %@",[GlobalVariables sharedInstance].appModel.on_line_group_id);
            if([[msg groupID] isEqualToString:[GlobalVariables sharedInstance].appModel.on_line_group_id] || [[msg groupID] isEqualToString:[GlobalVariables sharedInstance].appModel.full_group_id])
            {
                [self onRecvMsg:msg msgType:V2TIM_GROUP];
            }
            
            if([[msg groupID] isEqualToString:[_liveItem liveIMChatRoomId]])
            {
                // 处理群聊天消息
                [_newMsgMArray addObject:msg];
            }
        }
        else    // 预留其它群消息
        {
            [self onRecvMsg:msg msgType:V2TIM_GROUP];
        }
    }
//    switch (conType)
//    {
//        case TIM_C2C:       // 一对一消息
//        {
//            [self onRecvMsg:msg msgType:TIM_C2C];
//        }
//            break;
//
//        case TIM_GROUP:     // 群消息
//        {
//            if (_liveItem)  // 直播间内的群消息
//            {
//                if([[msg.getConversation getReceiver] isEqualToString:[_liveItem liveIMChatRoomId]])
//                {
//                    // 处理群聊天消息
//                    [_newMsgMArray addObject:msg];
//                }
//            }
//            else    // 预留其它群消息
//            {
//                [self onRecvMsg:msg msgType:TIM_GROUP];
//            }
//        }
//            break;
//
//        case TIM_SYSTEM:    // 系统消息
//        {
//            [self onRecvMsg:msg msgType:TIM_SYSTEM];
//        }
//            break;
//
//        default:
//            break;
//    }
    
}


/*
#pragma mark 循环消息处理时收到消息后判断消息类型
- (void)onHandleNewMessage:(NSArray *)msgs
{
    for(TIMMessage *msg in msgs)
    {
        [SIMMsgObj maybeIMChatMsg:msg];
        
        TIMConversationType conType = msg.getConversation.getType;
        
        switch (conType)
        {
            case TIM_C2C:       // 一对一消息
            {
                [self onRecvMsg:msg msgType:TIM_C2C];
            }
                break;
                
            case TIM_GROUP:     // 群消息
            {
                if (_liveItem)  // 直播间内的群消息
                {
                    if([[msg.getConversation getReceiver] isEqualToString:[_liveItem liveIMChatRoomId]])
                    {
                        // 处理群聊天消息
                        [_newMsgMArray addObject:msg];
                    }
                }
                else    // 预留其它群消息
                {
                    [self onRecvMsg:msg msgType:TIM_GROUP];
                }
            }
                break;
                
            case TIM_SYSTEM:    // 系统消息
            {
                [self onRecvMsg:msg msgType:TIM_SYSTEM];
            }
                break;
                
            default:
                break;
        }
    }
}
*/
#pragma mark 解析IM消息
- (void)onRecvMsg:(V2TIMMessage *)msg msgType:(V2TIMConversationType)msgType
{
    V2TIMTextElem *textElem = msg.textElem;
    V2TIMCustomElem *customElem = nil;
    V2TIMCustomElem *Elem = (V2TIMCustomElem *) textElem.nextElem;
    
    if([Elem  isKindOfClass:V2TIMCustomElem.class])
    {
        customElem = Elem;
    }else
    {
        customElem = msg.customElem;
    }
    //如果是debug，打印msg.customElem
#if DEBUG
    NSLog(@"customElem = >>>>%@",[msg.customElem.data mj_JSONString]);
#endif
//
//    V2TIMTextElem *textElem = msg.textElem;
//    V2TIMCustomElem *customElem = msg.customElem;
//    V2TIMGroupTipsElem *groupSystemElem = msg.groupTipsElem;

    
    if (msg)
    {
        //：identifier、nickname、faceURL、customInfo
        TIMUserProfile *profil = [[TIMUserProfile alloc] init];
        profil.identifier = (msg.userID == nil)?msg.groupID:msg.userID;
        
        
        NSString *g2 = [msg qmui_getBoundObjectForKey:@"groupID2"];
        if(g2 !=nil)
        {
            profil.identifier = g2;
        }
        
        profil.nickname = msg.nickName;
        
        id<IMUserAble> profile = profil;
//        if (!profile)
//        {
//            if (msgType == TIM_C2C)
//            {
//                NSString *recv = msg.userID;
//                profile = [self syncGetC2CUserInfo:recv];
//            }
//            else if (msgType == TIM_GROUP)
//            {
//                profile = [msg getSenderGroupMemberProfile];
//            }
//        }
//        if(msg.elemType == V2TIM_ELEM_TYPE_CUSTOM)
//        {
//
//        }
//        for(int index = 0; index < [msg elemCount]; index++)
//        {
//            TIMElem *elem = [msg getElem:index];
//            if([elem isKindOfClass:[TIMTextElem class]])
//            {
//                textElem = (TIMTextElem *)elem;
//            }
//            else if([elem isKindOfClass:[TIMCustomElem class]])
//            {
//                customElem = (TIMCustomElem *)elem;
//            }
//            else if([elem isKindOfClass:[TIMGroupSystemElem class]])
//            {
//                groupSystemElem = (TIMGroupSystemElem *)elem;
//            }
//        }
        
        // 脏字库过滤
        if (msgType == TIM_C2C && customElem)               // 一对一消息
        {
            if (textElem)
            {
                [self onRecvC2CSender:profile customMsg:customElem textMsg:textElem.text];
            }
            else
            {
                [self onRecvC2CSender:profile customMsg:customElem textMsg:@""];
            }
        }
        else if (msgType == TIM_GROUP && customElem)        // 群自定义消息
        {
            if (textElem)
            {
                [self onRecvGroupSender:profile groupId:msg.groupID customMsg:customElem textMsg:textElem.text];
            }
            else
            {
                if (profile) {
                    
                }
                [self onRecvGroupSender:profile groupId:msg.groupID customMsg:customElem textMsg:@""];
            }
        }
        else if (msgType == TIM_SYSTEM )  // 群系统消息
        {
            NSString *g2 = [msg qmui_getBoundObjectForKey:@"groupID2"];
            
            NSString *sysGroupID = g2;
            if (![BGUtils isBlankString:sysGroupID])
            {
                if (textElem)
                {
                    [self onRecvSystepGroupSender:profile groupId:sysGroupID customMsg:msg.customElem textMsg:textElem.text];
                }
                else
                {
                    [self onRecvSystepGroupSender:profile groupId:sysGroupID customMsg:msg.customElem textMsg:@""];
                }
            }
        }
    }
}

#pragma mark - ----------------------- 发送自定义消息 -----------------------
#pragma mark 组装TIMCustomElem
- (TIMCustomElem *)getCustomElemWith:(CustomMessageModel *)customMessageModel
{
    SenderModel *sender = [[SenderModel alloc]init];
    sender.user_id = [IMAPlatform sharedInstance].host.imUserId;
    sender.nick_name = [IMAPlatform sharedInstance].host.imUserName;
    sender.head_image = [IMAPlatform sharedInstance].host.imUserIconUrl;
    sender.user_level = (int)[[IMAPlatform sharedInstance].host getUserRank];
    sender.sort_num = [IMAPlatform sharedInstance].host.sort_num;
    sender.v_icon = [[IMAPlatform sharedInstance].host.customInfoDict toString:@"v_icon"];
    sender.v_type = [[IMAPlatform sharedInstance].host.customInfoDict toInt:@"v_type"];
    
//    sender.noble_car_name = [IMAPlatform sharedInstance].host.car_name;
    sender.car_svga = [IMAPlatform sharedInstance].host.car_svga;
    sender.has_car = [[IMAPlatform sharedInstance].host.has_car intValue];
    
    NSDictionary *dic = [IMAPlatform sharedInstance].host.customInfoDict;
    sender.noble_vip_type = [dic objectForKey:@"noble_vip_type"];
    sender.noble_stealth = [dic objectForKey:@"noble_stealth"];
    sender.noble_avatar = [dic objectForKey:@"noble_avatar"];
    sender.noble_icon = [dic objectForKey:@"noble_icon"];
    sender.noble_is_avatar = [dic objectForKey:@"noble_is_avatar"];
    sender.noble_car_url = sender.car_svga;
    sender.noble_car_name = [dic objectForKey:@"noble_car_name"];
    sender.is_guardian = customMessageModel.is_guardian;
    sender.guardianModel = customMessageModel.guardianModel;
    sender.guardian_broadcast = customMessageModel.guardianModel.guardian_broadcast;
    sender.guardian_remind = customMessageModel.guardianModel.guardian_remind;
    sender.guardian_skin = customMessageModel.guardianModel.guardian_skin;
    sender.guardian_gift = customMessageModel.guardianModel.guardian_gift;
    sender.guardian_img = customMessageModel.guardianModel.guardian_img;
    sender.guardian_kick = customMessageModel.guardianModel.guardian_kick;
    sender.guardian_icon = customMessageModel.guardianModel.guardian_icon;
    
    sender.is_vip = [dic objectForKey:@"is_vip"];
    
    
    
    
    
    NSString *is_noble_mysterious = [dic objectForKey:@"is_noble_mysterious"];
    //是否是神秘人
    if ([is_noble_mysterious integerValue] == 1){
        //如果是
        sender.head_image = [dic valueForKey:@"mysterious_picture"];
        sender.nick_name = [dic valueForKey:@"mysterious_name"];
    }
    sender.is_noble_mysterious = [dic objectForKey:@"is_noble_mysterious"];
    customMessageModel.sender = sender;
    
    NSMutableDictionary *stuDict = customMessageModel.mj_keyValues;
    if ([stuDict objectForKey:@"avimMsgShowSize"])
    {
        [stuDict removeObjectForKey:@"avimMsgShowSize"];
    }
         [stuDict removeObjectsForKeys:@[@"debugDescription", @"description", @"hash", @"superclass"]];
    if ([stuDict objectForKey:@"sender"])
    {
        [[stuDict objectForKey:@"sender"] removeObjectsForKeys:@[@"debugDescription", @"description", @"hash", @"superclass"]];
    }
    
    NSString *sendMessage = [BGUtils dataTOjsonString:stuDict];
    
    TIMCustomElem* messageElem = [[TIMCustomElem alloc] init];
    messageElem.data = [sendMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    return messageElem;
}

#pragma mark - 发送pk消息

- (void)sendCustomC2CMsg:(SendCustomMsgModel *)sCMM widthPID:(NSString *)pid succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (sCMM.msgReceiver)
    {
        CustomMessageModel *customMessageModel = [[CustomMessageModel alloc] init];
        customMessageModel.pk_id = pid;
        customMessageModel.type = sCMM.msgType;
        if (sCMM.msgType == MSG_RECEIVE_MIKE)
        {
            customMessageModel.push_rtmp2 = sCMM.push_rtmp2;
            customMessageModel.play_rtmp_acc = sCMM.play_rtmp_acc;
        }
        else if (sCMM.msgType == MSG_REFUSE_MIKE)
        {
            customMessageModel.msg = sCMM.msg;
        }
        
        TIMCustomElem* messageElem = [self getCustomElemWith:customMessageModel];
        
        TIMMessage* timMsg = [[TIMMessage alloc] init];
        [timMsg addElem:messageElem]; 
        if (sCMM.msgType == MSG_TEXT && _BuguLive.appModel.has_dirty_words == 1)
        {
            TIMTextElem *textElem = [[TIMTextElem alloc]init];
            textElem.text = sCMM.msg;
            [timMsg addElem:textElem];
        }
        
        V2TIMCustomElem *messageElemV2 = [[V2TIMCustomElem alloc] init];
        messageElemV2.data = messageElem.data;
        V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:messageElem.data];
        msg.isExcludedFromUnreadCount = YES;
        if (sCMM.msgType == MSG_TEXT && _BuguLive.appModel.has_dirty_words == 1)
        {
            V2TIMTextElem *textElem = [[V2TIMTextElem alloc]init];
            textElem.text = sCMM.msg;
            [msg.customElem appendElem:textElem];
        }
        
        
        [[V2TIMManager sharedInstance] sendMessage:msg receiver:[sCMM.msgReceiver imUserId] groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
            
        } succ:^{
            if(succ)
            {
                succ();
            }
        } fail:^(int code, NSString *desc) {
            if(fail)
            {
                fail(code, desc);

            }
        }];
        
//        TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[sCMM.msgReceiver imUserId]];
//
//        [conv sendMessage:timMsg succ:succ fail:^(int code, NSString *msg)
//         {
//             DebugLog(@"发送消息失败：%@", timMsg);
//             if (fail)
//             {
//                 fail(code, msg);
//             }
//         }];
    }
}


#pragma mark 发送自定义一对一消息
- (void)sendCustomC2CMsg:(SendCustomMsgModel *)sCMM succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (sCMM.msgReceiver)
    {
        CustomMessageModel *customMessageModel = [[CustomMessageModel alloc] init];
        customMessageModel.type = sCMM.msgType;
        customMessageModel.link_mic_user_id = sCMM.link_mic_user_id;
        if (sCMM.msgType == MSG_RECEIVE_MIKE)
        {
            customMessageModel.push_rtmp2 = sCMM.push_rtmp2;
            customMessageModel.play_rtmp_acc = sCMM.play_rtmp_acc;
        }
        else if (sCMM.msgType == MSG_REFUSE_MIKE)
        {
            customMessageModel.msg = sCMM.msg;
        }else if (sCMM.msgType == MSG_REQEUST_PK){
            customMessageModel.pkid = sCMM.pkid;
        }
        
        TIMCustomElem* messageElem = [self getCustomElemWith:customMessageModel];
        
        TIMMessage* timMsg = [[TIMMessage alloc] init];
        [timMsg addElem:messageElem];
        if (sCMM.msgType == MSG_TEXT && _BuguLive.appModel.has_dirty_words == 1)
        {
            TIMTextElem *textElem = [[TIMTextElem alloc]init];
            textElem.text = sCMM.msg;
            [timMsg addElem:textElem];
        }
        
//        TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[sCMM.msgReceiver imUserId]];
//
//        [conv sendMessage:timMsg succ:succ fail:^(int code, NSString *msg)
//         {
//             DebugLog(@"发送消息失败：%@", timMsg);
//             if (fail)
//             {
//                 fail(code, msg);
//             }
//         }];
        
        
        
        V2TIMCustomElem *messageElemV2 = [[V2TIMCustomElem alloc] init];
        messageElemV2.data = messageElem.data;
        V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:messageElem.data];
        msg.isExcludedFromUnreadCount = YES;
        if (sCMM.msgType == MSG_TEXT && _BuguLive.appModel.has_dirty_words == 1)
        {
            V2TIMTextElem *textElem = [[V2TIMTextElem alloc]init];
            textElem.text = sCMM.msg;
            [msg.customElem appendElem:textElem];
        }
        
        
        [[V2TIMManager sharedInstance] sendMessage:msg receiver:[sCMM.msgReceiver imUserId] groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
            
        } succ:^{
            if(succ)
            {
                succ();
            }
        } fail:^(int code, NSString *desc) {
            if(fail)
            {
                fail(code, desc);

            }
        }];
        
    }
}

#pragma mark 发送自定义群消息
- (void)sendCustomGroupMsg:(SendCustomMsgModel *)sCMM succ:(TIMSucc)succ fail:(TIMFail)fail
{
    if (_chatRoomConversation)
    {
        CustomMessageModel *customMessageModel = [[CustomMessageModel alloc] init];
        customMessageModel.type = sCMM.msgType;
        customMessageModel.chatGroupID = sCMM.chatGroupID;
        
        if (sCMM.msgType == MSG_LIVING_MESSAGE)
        {   //直播消息
            customMessageModel.desc = sCMM.msg;
        }
        else if(sCMM.msgType == MSG_RECEIVE_MIKE)
        {
            customMessageModel.link_mic_user_id = sCMM.link_mic_user_id;
            customMessageModel.push_rtmp2 = sCMM.push_rtmp2;
            customMessageModel.play_rtmp_acc = sCMM.play_rtmp_acc;
        }
        else if (sCMM.msgType == MSG_BREAK_MIKE)
        {
            customMessageModel.link_mic_user_id = sCMM.link_mic_user_id;
            
        }
        else if(sCMM.msgType == MSG_LIGHT)
        {   //点亮
            customMessageModel.imageName = sCMM.msg;
            if (sCMM.isShowLight)
            {
                customMessageModel.showMsg = 1;
            }
            else
            {
                customMessageModel.showMsg = 0;
            }
            customMessageModel.is_guardian = sCMM.is_guardian;
            customMessageModel.is_vip = sCMM.is_vip;
            customMessageModel.guardianModel = sCMM.guardianModel;
        }else if (sCMM.msgType == MSG_VIEWER_JOIN || sCMM.msgType == MSG_TEXT){
            customMessageModel.is_guardian = sCMM.is_guardian;
            customMessageModel.noble_icon = sCMM.noble_icon;
            customMessageModel.is_vip = sCMM.is_vip;
            customMessageModel.text = sCMM.msg;
            customMessageModel.guardianModel = sCMM.guardianModel;
            customMessageModel.guardian_icon = sCMM.guardian_icon;
            customMessageModel.guardian_gift = sCMM.guardian_gift;
            customMessageModel.guardian_skin = sCMM.guardian_skin;
            customMessageModel.guardian_img = sCMM.guardian_img;
            customMessageModel.guardian_broadcast = sCMM.guardian_broadcast;
            
            
        }
        else if(sCMM.msgType == MSG_LianMai_Mute)
        {
            customMessageModel.to_user_id = sCMM.to_user_id;
            customMessageModel.mute_status = sCMM.mute_status;
            
        }
        else if(sCMM.msgType == MSG_SEND_EMOTION)
        {
            customMessageModel.faceUrl = sCMM.faceUrl;
        }
        else
        {
            customMessageModel.text = sCMM.msg;
        }
        
        if (sCMM.msgType == MSG_SHOP_SAY_TYPE) {
            customMessageModel.shopModel = sCMM.shopModel;
        }
        customMessageModel.guardianModel = sCMM.guardianModel;
        
        
        customMessageModel.guardian_icon = sCMM.guardian_icon;
        customMessageModel.guardian_gift = sCMM.guardian_gift;
        customMessageModel.guardian_skin = sCMM.guardian_skin;
        customMessageModel.guardian_img = sCMM.guardian_img;
        customMessageModel.guardian_broadcast = sCMM.guardian_broadcast;
        
        
        TIMCustomElem* messageElem = [self getCustomElemWith:customMessageModel];
        
        V2TIMCustomElem *messageElemV2 = [[V2TIMCustomElem alloc] init];
        messageElemV2.data = messageElem.data;
        V2TIMMessage *msg = [[V2TIMManager sharedInstance] createCustomMessage:messageElem.data];
//        msg.cloudCustomData = messageElem.data;
        
//        TIMMessage* timMsg = [[TIMMessage alloc] init];
//        [timMsg addElem:messageElem];
//        if (sCMM.msgType == MSG_TEXT && _BuguLive.appModel.has_dirty_words == 1)
//        {
//            TIMTextElem *textElem = [[TIMTextElem alloc]init];
//            textElem.text = sCMM.msg;
//            [timMsg addElem:textElem];
//        }
        
        
        [[V2TIMManager sharedInstance] sendMessage:msg receiver:nil groupID:sCMM.chatGroupID priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
            
        } succ:^{
            [self onRecvGroupSender:[IMAPlatform sharedInstance].host groupId:sCMM.chatGroupID customMsg:msg.customElem textMsg:@""];

        } fail:^(int code, NSString *desc) {
            
        }];
        
        
        /*[_chatRoomConversation sendMessage:timMsg succ:^{
            
            // 防止频繁切换房间时把消息发送给了下一个直播间
            if ([customMessageModel.chatGroupID isEqualToString:[_liveItem liveIMChatRoomId]])
            {
                // 需要在直播间聊天列表中显示的消息就加进来
                [self onRecvGroupSender:[IMAPlatform sharedInstance].host groupId:sCMM.chatGroupID customMsg:messageElem textMsg:@""];
            }
            if (succ)
            {
                succ();
            }
        } fail:^(int code, NSString *msg) {
            
            if (code == 80001)
            {
                [FanweMessage alert:ASLocalizedString(@"该词被禁用")];
            }else if (code == 10017 || code == 20012)
            {
                [FanweMessage alert:ASLocalizedString(@"您已被禁言")];
            }
            DebugLog(@"发送消息失败：%@", timMsg);
            if (fail)
            {
                fail(code, msg);
            }
        }];*/
    }
    else
    {
        if (fail)
        {
            fail(-1,ASLocalizedString( @"TIMConversation 为空"));
        }
    }
}

#pragma mark - ----------------------- 设置是否支持缓存模式 -----------------------
- (void)setIsCacheMode:(BOOL)isCacheMode
{
    _isCacheMode = isCacheMode;
    if (_isCacheMode)
    {
        [self createMsgCache];
    }
    else
    {
        [self releaseMsgCache];
    }
}

@end


#pragma mark - ======================= 供子类重写 =======================
@implementation BGIMMsgHandler (ProtectedMethod)

- (id<IMUserAble>)syncGetC2CUserInfo:(NSString *)identifier
{
    if (_liveItem)
    {
        if ([[[_liveItem liveHost] imUserId] isEqualToString:identifier])
        {
            // 主播发过来的消息
            return [_liveItem liveHost];
        }
        else
        {
            TIMUserProfile *profile = [[TIMUserProfile alloc] init];
            profile.identifier = identifier;
            return profile;
        }
    }
    else
    {
        TIMUserProfile *profile = [[TIMUserProfile alloc] init];
        profile.identifier = identifier;
        return profile;
    }
}

#pragma mark - ----------------------- 解析消息后处理对应的代理事件 -----------------------
#pragma mark 收到C2C自定义消息
- (void)onRecvC2CSender:(id<IMUserAble>)sender customMsg:(V2TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    id<AVIMMsgAble> c2cMsg = [self getCustomMsgModel:sender groupId:@"" customMsg:msg textMsg:textMsg];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (c2cMsg && _liveItem)
        {
            [_iMMsgListener onIMHandler:self recvCustomC2C:c2cMsg];
        }
    });
}

#pragma mark 收到群自定义消息处理
- (void)onRecvGroupSender:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(V2TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    id<AVIMMsgAble> cachedMsg = [self getCustomMsgModel:sender groupId:groupId customMsg:msg textMsg:textMsg];
    NSLog(@"tttyypppee %ld",(long)[cachedMsg msgType]);
    if (cachedMsg && _liveItem)
    {

        if ([cachedMsg msgType] == MSG_TEXT || [cachedMsg msgType] == MSG_VIEWER_JOIN || [cachedMsg msgType] == MSG_SEND_GIFT_SUCCESS || [cachedMsg msgType] == UPDATE_PK_TICKET)
        {
            [self enCache:cachedMsg noCache:^{}];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_iMMsgListener onIMHandler:self recvCustomGroup:cachedMsg];
        });
    }
    
//    if ([cachedMsg msgType] == MSG_RECEIVE_BROADCAST) {
//        NSDictionary *resposeDict = [NSJSONSerialization JSONObjectWithData:msg.data options:NSJSONReadingAllowFragments error:nil];
//        CustomMessageModel *customMessageModel = [CustomMessageModel mj_objectWithKeyValues:resposeDict];
//
//        [self showGlobalViewWithModel:customMessageModel];
//
//    }
//
//    return;
//    if ([cachedMsg msgType] == MSG_OPEN_VIP_TYPE) {
//        NSDictionary *resposeDict = [NSJSONSerialization JSONObjectWithData:msg.data options:NSJSONReadingAllowFragments error:nil];
//        CustomMessageModel *customMessageModel = [CustomMessageModel mj_objectWithKeyValues:resposeDict];
//        
//        customMessageModel.sender.text = [resposeDict valueForKeyPath:@"broadcash_msg_content"];
//        [self showGlobalViewWithModel:customMessageModel];
//    }
}

-(void)showGlobalViewWithModel:(CustomMessageModel *)customMessageModel{
    
//    self.globalView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];

    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.globalView) {
            self.globalView = [[MGGlobalVipView alloc]initWithFrame:CGRectMake(kScreenW, FD_Top_Height + 120, 230, 40)];
        }
        // 判断是否有悬浮窗
        UIView *tmpView = [AppDelegate sharedAppDelegate].sus_window.rootViewController ? [AppDelegate sharedAppDelegate].sus_window : [AppDelegate sharedAppDelegate].window;

        UIView *inView = [AppDelegate sharedAppDelegate].sus_window.isSmallSusWindow ? [AppDelegate sharedAppDelegate].window : tmpView;
        
        
        // 超时自动消失
        // [hud hideAnimated:YES afterDelay:kRequestTimeOutTime];
        
        
        self.globalView.model = customMessageModel;
        [inView addSubview:self.globalView];
        [inView bringSubviewToFront:self.globalView];
        
        FWWeakify(self)
        [UIView animateWithDuration:10.0f animations:^{
            FWStrongify(self)
            self.globalView.left = -kScreenW;
        } completion:^(BOOL finished) {
            FWStrongify(self)
            self.globalView.left = kScreenW;
        }];
    });
}

#pragma mark 收到群系统消息
- (void)onRecvSystepGroupSender:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(V2TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    id<AVIMMsgAble> systepGroup = [self getSystemGroupMsgModel:sender groupId:groupId customMsg:msg textMsg:textMsg];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (systepGroup && _liveItem && [groupId isEqualToString:[_liveItem liveIMChatRoomId]])
        {
            [_iMMsgListener onIMHandler:self recvCustomGroup:systepGroup];
        }
    });
}

#pragma mark - ----------------------- 解析消息 -----------------------
#pragma mark 解析自定义消息
- (id<AVIMMsgAble>)getCustomMsgModel:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(V2TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    return [self getMsgModel:sender groupId:groupId customMsg:msg.data textMsg:textMsg];
}

#pragma mark 解析群系统消息
- (id<AVIMMsgAble>)getSystemGroupMsgModel:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(V2TIMCustomElem *)msg textMsg:(NSString *)textMsg
{
    
#ifdef DEBUG
    //    NSString *jsonStr = [[NSString alloc]initWithData:msg.userData encoding:NSUTF8StringEncoding];
    //    NetHttpsManager *http = [NetHttpsManager manager];
    //    NSMutableDictionary *dic = [NSMutableDictionary new];
    //    [dic setObject:jsonStr forKey:@"test_system_im"];
    //    [dic setObject:@"pushTest" forKey:@"act"];
    //    [dic setObject:@"games" forKey:@"ctl"];
    //    [http POSTWithParameters:dic SuccessBlock:^(NSDictionary *responseJson) {
    //        NSLog(@"%@",[responseJson toString:@"status"]);
    //    } FailureBlock:^(NSError *error) {
    //        NSLog(@"%@",error);
    //    }];
#endif
    
    return [self getMsgModel:sender groupId:groupId customMsg:msg.data textMsg:textMsg];
}

#pragma mark 解析消息，获取消息实体
- (id<AVIMMsgAble>)getMsgModel:(id<IMUserAble>)sender groupId:(NSString *)groupId customMsg:(NSData *)data textMsg:(NSString *)textMsg
{
    CustomMessageModel *customMessageModel;
    
    NSDictionary *resposeDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"getMsgModel %@",resposeDict);
    if (resposeDict && [resposeDict isKindOfClass:[NSDictionary class]])
    {
        if ([resposeDict count])
        {
            customMessageModel = [CustomMessageModel mj_objectWithKeyValues:resposeDict];
            customMessageModel.dicData = resposeDict;
            SenderModel *tmpSender = [SenderModel mj_objectWithKeyValues:[resposeDict objectForKey:@"sender"]];
            if (!StrValid(tmpSender.noble_stealth)) {
                tmpSender.noble_stealth = tmpSender.is_noble_stealth;
            }
            customMessageModel.sender = tmpSender;
            customMessageModel.chatGroupID = groupId;
            
            if (tmpSender.user_level > [[IMAPlatform sharedInstance].host getUserRank])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[IMAPlatform sharedInstance].host getMyInfo:^(AppBlockModel *blockModel) {
                        
                        // 判断当前用户的等级能否发言了
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLiveRoomCanSendMessage object:nil];
                        
                    }];
                    
                });
            }
            
            if (customMessageModel.type == MSG_LIVE_STOP)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 刷新首页（主要为了删除首页已经退出的直播间）
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRefreshHomeItem object:resposeDict];
                });
            }
            
            if (textMsg && ![textMsg isEqualToString:@""])
            {
                customMessageModel.text = textMsg;
            }
        }
    }
    
    [customMessageModel prepareForRender];
    
    return customMessageModel;
}


@end


#pragma mark - ======================= 缓存相关 =======================
@implementation BGIMMsgHandler (CacheMode)

- (void)createMsgCache
{
    if (_msgCache)
    {
        _msgCache = nil;
    }
    _msgCache = [NSMutableDictionary dictionary];
    [_msgCache setObject:[[AVIMCache alloc] initWith:1000] forKey:kRoomTableViewMsgKey];
    
    [_msgCache setObject:[[AVIMCache alloc] initWith:10] forKey:@(MSG_LIGHT)];
}

- (void)resetMsgCache
{
    [self createMsgCache];
}
- (void)releaseMsgCache
{
    _msgCache = nil;
}

- (void)enCache:(id<AVIMMsgAble>)msg noCache:(FWVoidBlock)noCacheblock;
{
    if (!_isCacheMode)
    {
        if (noCacheblock)
        {
            noCacheblock();
        }
    }
    else
    {
        if (msg)
        {
            OSSpinLockLock(&_msgCacheLock);
            
            AVIMCache *cache;
            if ([msg msgType] == MSG_LIGHT)
            {
                cache = [_msgCache objectForKey:@([msg msgType])];
            }
            else
            {
                cache = [_msgCache objectForKey:kRoomTableViewMsgKey];
            }
            if (cache)
            {
                [cache enCache:msg];
            }
            else
            {
                if (noCacheblock)
                {
                    noCacheblock();
                }
            }
            OSSpinLockUnlock(&_msgCacheLock);
        }
    }
    
}

- (NSDictionary *)getMsgCache
{
    OSSpinLockLock(&_msgCacheLock);
    NSDictionary *dic = _msgCache;
    
    OSSpinLockUnlock(&_msgCacheLock);
    
    return dic;
}

@end


#pragma mark - ======================= 直播间调用的方法 =======================
@implementation BGIMMsgHandler (LivingRoom)

#pragma mark 设置群监听
- (void)setGroupChatListener:(id<FWShowLiveRoomAble>)liveItem block:(CommonBlock)block
{
    DebugLog(@"========：setGroupChatListener");
    _liveItem = liveItem;
    [[V2TIMManager sharedInstance] getConversation:[NSString stringWithFormat:@"c2c_%d",liveItem.liveAVRoomId] succ:^(V2TIMConversation *conv) {
        _chatRoomConversation = conv;
        self.isCacheMode = kSupportIMMsgCache;
        block(nil);
    } fail:^(int code, NSString *desc) {
        
    }];
    
    
}

#pragma mark 移除群监听
- (void)removeGroupChatListener
{
    DebugLog(@"========：removeGroupChatListener");
    _liveItem = nil;
    _chatRoomConversation = nil;
    
    self.isCacheMode = NO;
    [_newMsgMArray removeAllObjects];
}


@end
