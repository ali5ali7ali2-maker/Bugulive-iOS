//
//  BGIMPrivateMsgHandler.m
//  BuguLive
//
//  Created by 朱庆彬 on 2017/8/2.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGIMPrivateMsgHandler.h"
#import "AFURLSessionManager.h"
#import "AVIMAble.h"
#import "FMDB.h"
#import "IMAMsg.h"
#import "Mwxpay.h"
#import "NSObject+myobj.h"
#import "TPAACAudioConverter.h"
#import "Util.h"
#import <ImSDK/TIMManager.h>
#import <QMapKit/QMapKit.h>
#import <StoreKit/StoreKit.h>
#import <objc/message.h>
#import <ImSDK_Plus/V2TIMManager+Conversation.h>
NSString *g_notif_chatmsg = @"g_notif_chatmsg";

@implementation BGIMPrivateMsgHandler
{
    TIMConversation *_tcConv;
}

BogoSingletonM(Instance);

@end

@interface SIMMsgObj () <TPAACAudioConverterDelegate>

@property (nonatomic, assign) AVIMCommand mTMsgType;

- (id)initWithTMsg:(V2TIMMessage *)TMsg;

@end

@implementation SIMMsgObj
{
    BOOL _bfetching;
    TPAACAudioConverter *_msgacccconvert;

    MYNSCondition *_condit;

    NSString *_converterr;
}

+ (NSString *)makeMsgDesc:(SIMMsgObj *)msg
{
    if (msg.mMsgType == 1)
    {
        return [msg.mTextMsg copy];
    }
    else if (msg.mMsgType == 2)
    {
        return ASLocalizedString(@"[图片]");
    }
    else if (msg.mMsgType == 3)
    {
        return ASLocalizedString(@"[语音]");
    }
    else if (msg.mMsgType == 4)
    {
        return ASLocalizedString(@"[礼物]");
    }

    return ASLocalizedString(@"未知消息");
}

+ (NSString *)makeMsgDescv2:(SIMMsgObj *)msg
{
    if (msg.mMsgType == 1)
    {
        return [msg.mTextMsg copy];
    }
    else if (msg.mMsgType == 2)
    {
        return ASLocalizedString(@"[图片]");
    }
    else if (msg.mMsgType == 3)
    {
        return ASLocalizedString(@"[语音]");
    }
    else if (msg.mMsgType == 4)
    {
        return ASLocalizedString(@"[礼物]");
    }

    return ASLocalizedString(@"未知消息");
}


+ (BOOL)maybeIMChatMsg:(V2TIMMessage *)itmsg
{
    SIMMsgObj *maybemsg = [[SIMMsgObj alloc] initWithTMsg:itmsg];
    if (maybemsg.mMsgType == -1)
    {
        return NO;
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:g_notif_chatmsg object:maybemsg];

    return NO;
}

+ (BOOL)saveData:(id)data forkey:(NSString *)key
{
    if (data == nil || key == nil)
        return NO;

    NSString *ss = [NSString stringWithFormat:@"%@_%@", key, [IMAPlatform sharedInstance].host.imUserId];
    NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
    NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:data];
    [st setObject:dat forKey:ss];
    return [st synchronize];
}

- (id)init
{
    self = [super init];

    if (self)
    { //如果创建信息消息,那么默认的发送ID就是我自己.
        self.mSenderId = [[IMAPlatform sharedInstance].host.imUserId intValue];
        self.is_robot = [IMAPlatform sharedInstance].host.is_robot;
    }
    return self;
}

- (id)initWithTMsg:(V2TIMMessage *)TMsg
{
    self = [super init];

    if (self)
    {
        [self fetchIt:TMsg];
    }

    return self;
}

- (void)fetchIt:(V2TIMMessage *)msg
{
    self.mCoreTMsg = msg;
    
//    V2TIMElem *elem = msg.;
//
//    if (msg.elemCount == 0)
//    {
//        self.mMsgType = -1;
//        NSLog(@"not have msg data");
//        return;
//    }
//    NSMutableArray *nextElem = [NSMutableArray array];
    V2TIMCustomElem *customel = (V2TIMCustomElem *) msg.customElem;
    V2TIMElem *customel2 = customel.nextElem;

    NSLog(@"customel className %@",[customel className]);
    
    V2TIMElem *elem = customel.nextElem;
//    while (elem != nil) {
//        // 判断 elem 类型
//        [nextElem addObject:elem];
//        elem = customel.nextElem;
//    }
    
    V2TIMImageElem *imageElem = (V2TIMImageElem *) msg.imageElem;
    if(imageElem != nil)
    {
        customel = imageElem.nextElem;
    }
    
    
    //判断是不是语音消息
    V2TIMSoundElem *soundElem = (V2TIMSoundElem *) msg.soundElem;
    if(soundElem != nil)
    {
        customel = soundElem.nextElem;
    }
//    if (![customel isKindOfClass:[V2TIMCustomElem class]])
//    {
//        customel = (V2TIMCustomElem *) customel.nextElem;
//        if (![customel isKindOfClass:[V2TIMCustomElem class]])
//        {
//            self.mMsgType = -1;
//            return;
//        }
//    }

    NSData *customdata = customel.data;

    if (customdata == nil)
    {
        self.mMsgType = -1;
        return;
    }

    NSDictionary *getdata = [NSJSONSerialization JSONObjectWithData:customdata options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",getdata);
    
    NSString *senderheadimg;
    int itsendid;
    if ([getdata objectForKey:@"sender"] && [getdata objectForKey:@"sender"] != nil && [[getdata objectForKey:@"sender"] count])
    {
        senderheadimg = [[getdata objectForKey:@"sender"] objectForKey:@"head_image"];
        itsendid = [[[getdata objectForKey:@"sender"] objectForKey:@"user_id"] intValue];
    }

    self.mSenderId = itsendid;
    self.is_robot = [[[getdata objectForKey:@"sender"] objectForKey:@"is_robot"] boolValue];

    NSString *senderid = [NSString stringWithFormat:@"%d", itsendid];

    NSString *nowuserid = [NSString stringWithFormat:@"%d", [[[IMAPlatform sharedInstance].host.profile.customInfo objectForKey:@"user_id"] intValue]];

    self.mIsSendOut = [senderid isEqualToString:nowuserid];

    self.mTMsgType = [[getdata objectForKey:@"type"] intValue];
    if (self.mTMsgType == MSG_PRIVATE_TEXT)
    {
        self.mTextMsg = [getdata objectForKey:@"text"];
        self.mMsgType = 1;
    }
    else if (self.mTMsgType == MSG_PRIVATE_VOICE)
    {
        
        V2TIMSoundElem *soundel = (V2TIMSoundElem *) soundElem;
//        if (![soundel isKindOfClass:[V2TIMSoundElem class]])
//        {
//            soundel = (V2TIMSoundElem *) [msg getElem:0];
//        }
//        if (![soundel isKindOfClass:[V2TIMSoundElem class]])
//        {
//            self.mMsgType = -1;
//            return;
//        }

        self.mMsgType = 3;

        id duration = [getdata objectForKey:@"duration"];
        if (duration != nil)
        {
            self.mDurlong = [duration floatValue] / 1000.0f;
        }
        else
        {
            self.mDurlong = self.mIsSendOut ? soundel.duration : soundel.duration / 1000.0f;
            
//            self.mDurlong = soundel.duration;

        }

        self.mVoiceData = [NSData dataWithContentsOfFile:soundel.path];
        self.mIsPlaying = NO;
         
    }
    else if (self.mTMsgType == MSG_PRIVATE_IMAGE)
    {
        
        
        V2TIMImageElem *imgel = imageElem;
//        if (![imgel isKindOfClass:[V2TIMImageElem class]])
//        {
//            imgel = (V2TIMImageElem *) [msg getElem:0];
//        }
//        if (![imgel isKindOfClass:[V2TIMImageElem class]])
//        {
//            self.mMsgType = -1;
//            return;
//        }

        self.mMsgType = 2;

        if (imgel.imageList.count != 0)
        {
            V2TIMImage *theimg = nil;
            
            
//            V2TIM_IMAGE_TYPE_ORIGIN                   = 0x01,  ///< 原图
//            V2TIM_IMAGE_TYPE_THUMB                    = 0x02,  ///< 缩略图
//            V2TIM_IMAGE_TYPE_LARGE                    = 0x04,  ///< 大图
            ///
            for (V2TIMImage *one in imgel.imageList)
            {
                if (one.type == V2TIM_IMAGE_TYPE_ORIGIN)
                {
                    theimg = one;
                    break;
                }
            }

            if (theimg == nil)
            {
                self.mMsgType = -1;
                return;
            }

            self.mPicURL = theimg.url;
            self.mPicW = theimg.width;
            self.mPicH = theimg.height;
            self.mImgObj = nil;
        }
        else
        {
            self.mMsgType = -1;
            return;
        }
         
        
        NSLog(@"图片消息");
    }
    else if (self.mTMsgType == MSG_PRIVATE_GIFT)
    {

        int gifid = [[getdata objectForKey:@"prop_id"] intValue];
        self.mGiftId = [NSString stringWithFormat:@"%d", gifid];
        self.mGiftIconURL = [getdata objectForKey:@"prop_icon"];
        self.mJyStr = [getdata objectForKey:@"from_score"];

        self.mMsgType = 4;
    }
    else
    {
        self.mMsgType = -1; //无效的
        return;
    }

    self.mMsgID = msg.msgID;
    self.mMsgStatus = 0;
    self.mMsgDate = msg.timestamp;
    self.mHeadImgUrl = senderheadimg;

    if (self.mTMsgType == MSG_PRIVATE_GIFT)
    {
        if (self.mIsSendOut)
        {
            self.mGiftDesc = [getdata objectForKey:@"from_msg"];
        }
        else
        {
            self.mGiftDesc = [getdata objectForKey:@"to_msg"];
        }
    }
}

#define T_VOICE_NAME @"voice_recode"

- (void)fetchMsgData:(void (^)(NSString *errmsg))block
{
    if (self.mMsgType == 3)
    { //语音消息
        if (_bfetching)
            return;
        _bfetching = YES;

        V2TIMSoundElem *soundel = (V2TIMSoundElem *) self.mCoreTMsg.soundElem;
        if (![soundel isKindOfClass:[V2TIMSoundElem class]])
        {
//            soundel = (V2TIMSoundElem *) [self.mCoreTMsg getElem:0];
            if (![soundel isKindOfClass:[V2TIMSoundElem class]])
            {
                block(ASLocalizedString(@"无效的数据"));
                _bfetching = NO;
                return;
            }
        }
        NSString *soundFileName = @"";

        if (soundel.uuid == nil)
        {
            return;
        }
        NSString *soundName = [NSString stringWithFormat:@"%@_%@", soundel.uuid, [IMAPlatform sharedInstance].host.imUserId];
        NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
        NSData *dat = [st objectForKey:soundName];
        if (dat != nil)
        {
            soundFileName = [NSKeyedUnarchiver unarchiveObjectWithData:dat];
            if (soundFileName && soundFileName.length)
            {
                self.mVoiceData = [NSData dataWithContentsOfFile:[SFriendObj makevoicesavepath:soundFileName]];
                if (self.mVoiceData)
                {
                    block(nil);
                    _bfetching = NO;
                    return;
                }
            }
        }

//        if (![soundel.path isEqualToString:@""] || soundel.path != nil)
//        {
//        NSString *uuid = soundElem.uuid;
//        NSString *soundPath = [NSTemporaryDirectory() stringByAppendingPathComponent:[NSString stringWithFormat: @"IMSound%@",uuid]];
//
//
        NSString *savePath = [SFriendObj makevoicesavepath:soundFileName];
            [soundel downloadSound:savePath progress:^(NSInteger curSize, NSInteger totalSize) {
                // 下载进度
                NSLog(@"下载语音进度：curSize：%lu,totalSize:%lu",curSize,totalSize);
                
                
                
            } succ:^{
                // 下载成功
                
                NSString *newfilename = [SFriendObj makevoicefilename];
//                NSString *newfullpath = [SFriendObj makevoicesavepath:newfilename];

//                if (soundel.path == nil || [soundel.path isEqualToString:@""])
//                {
//                    NSLog(@"path is null");
//                }
//                else
//                {
//                    NSData *data = [NSData dataWithContentsOfFile:soundel.path];
//
//                    [data writeToFile:newfullpath atomically:YES];
//                }

                dispatch_async(dispatch_get_global_queue(0, 0), ^{

                    NSString *desconvertfile = [savePath stringByAppendingString:@".out"];

                    _condit = MYNSCondition.new;

                    _msgacccconvert = [[TPAACAudioConverter alloc] initWithDelegate:self
                                                                             source:savePath
                                                                        destination:desconvertfile];

                    [_msgacccconvert start];
                    [_condit lock];
                    [_condit wait];
                    [_condit unlock];

                    _msgacccconvert = nil;
                    _condit = nil;

                    if (_converterr == nil)
                    {
                        self.mVoiceData = [NSData dataWithContentsOfFile:desconvertfile];

                        [SIMMsgObj saveData:[NSString stringWithFormat:@"%@_%@", soundel.uuid, [IMAPlatform sharedInstance].host.imUserId] forkey:soundel.uuid];
                    }

                    dispatch_async(dispatch_get_main_queue(), ^{

                        _bfetching = NO;
                        block(_converterr);
                        _converterr = nil;

                    });

                });

                
                NSLog(@"下载语音完成");
            } fail:^(int code, NSString *msg) {
                // 下载失败
                NSLog(@"下载语音失败：code：%d,msg:%@",code,msg);
                
                if (code == 10017 || code == 20012)
                {
                    [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
                    return;
                }
                _bfetching = NO;
                block(msg);
            }];
            

//            [soundel getSound:soundel.path
//                succ:^{
//
//                    NSString *newfilename = [SFriendObj makevoicefilename];
//                    NSString *newfullpath = [SFriendObj makevoicesavepath:newfilename];
//
//                    if (soundel.path == nil || [soundel.path isEqualToString:@""])
//                    {
//                        NSLog(@"path is null");
//                    }
//                    else
//                    {
//                        NSData *data = [NSData dataWithContentsOfFile:soundel.path];
//
//                        [data writeToFile:newfullpath atomically:YES];
//                    }
//
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//                        NSString *desconvertfile = [newfullpath stringByAppendingString:@".out"];
//
//                        _condit = MYNSCondition.new;
//
//                        _msgacccconvert = [[TPAACAudioConverter alloc] initWithDelegate:self
//                                                                                 source:newfullpath
//                                                                            destination:desconvertfile];
//
//                        [_msgacccconvert start];
//                        [_condit lock];
//                        [_condit wait];
//                        [_condit unlock];
//
//                        _msgacccconvert = nil;
//                        _condit = nil;
//
//                        if (_converterr == nil)
//                        {
//                            self.mVoiceData = [NSData dataWithContentsOfFile:desconvertfile];
//
//                            [SIMMsgObj saveData:newfilename forkey:soundel.uuid];
//                        }
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            _bfetching = NO;
//                            block(_converterr);
//                            _converterr = nil;
//
//                        });
//
//                    });
//
//                }
//                fail:^(int code, NSString *msg) {
//                    if (code == 10017 || code == 20012)
//                    {
//                        [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
//                        return;
//                    }
//                    _bfetching = NO;
//                    block(msg);
//
//                }];
        }
//        else
//        {
//
//            NSString *newfilename = [SFriendObj makevoicefilename];
//            NSString *newfullpath = [SFriendObj makevoicesavepath:newfilename];
//            [soundel getSound:newfullpath
//                succ:^{
//
//                    NSData *data = [NSData dataWithContentsOfFile:newfullpath];
//
//                    [data writeToFile:newfullpath atomically:YES];
//
//                    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//
//                        NSString *desconvertfile = [newfullpath stringByAppendingString:@".out"];
//
//                        _condit = MYNSCondition.new;
//
//                        _msgacccconvert = [[TPAACAudioConverter alloc] initWithDelegate:self
//                                                                                 source:newfullpath
//                                                                            destination:desconvertfile];
//
//                        [_msgacccconvert start];
//                        [_condit lock];
//                        [_condit wait];
//                        [_condit unlock];
//
//                        _msgacccconvert = nil;
//                        _condit = nil;
//
//                        if (_converterr == nil)
//                        {
//                            self.mVoiceData = [NSData dataWithContentsOfFile:desconvertfile];
//
//                            NSString *soundName = [NSString stringWithFormat:@"%@_%@", soundel.uuid, [IMAPlatform sharedInstance].host.imUserId];
//                            NSUserDefaults *st = [NSUserDefaults standardUserDefaults];
//                            NSData *dat = [NSKeyedArchiver archivedDataWithRootObject:newfilename];
//                            [st setObject:dat forKey:soundName];
//                        }
//
//                        dispatch_async(dispatch_get_main_queue(), ^{
//
//                            _bfetching = NO;
//                            block(_converterr);
//                            _converterr = nil;
//
//                        });
//
//                    });
//
//                }
//                fail:^(int code, NSString *msg) {
//                    if (code == 10017 || code == 20012)
//                    {
//                        [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
//                        return;
//                    }
//                    _bfetching = NO;
//                    block(msg);
//
//                }];
//        }
//    }
    /*else
    { //其他消息 没有需要填充的
        block(ASLocalizedString(@"获取消息数据失败"));
    }*/
}

- (void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter
{
    NSLog(@"AACAudioConverterDidFinishConversion ok");
    _converterr = nil;
    [_condit lock];
    [_condit signal];
    [_condit unlock];
}

- (void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError :%@", error);
    _converterr = ASLocalizedString(@"转换语音数据错误");
    [_condit lock];
    [_condit signal];
    [_condit unlock];
}

@end

@interface SFriendObj () <TPAACAudioConverterDelegate>

@end

@implementation SFriendObj
{
    V2TIMConversation *_tcConv;
    TPAACAudioConverter *_aacconvert;
    MYNSCondition *_condit;
    NSString *_converterrstr;
}

- (id)initWithUserId:(int)userid
{
    self = [super init];

    if (self)
    {
        self.mUser_id = userid;
//        _tcConv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[NSString stringWithFormat:@"%d", userid]];
         [[V2TIMManager sharedInstance] getConversation:[NSString stringWithFormat:@"%d", userid] succ:^(V2TIMConversation *conv) {
             _tcConv = conv;
        } fail:^(int code, NSString *desc) {
            
        }];
    }

    return self;
}

- (void)ignoreThisUnReadCount
{
    [[V2TIMManager sharedInstance] markC2CMessageAsRead:StringFromInt(self.mUser_id) succ:^{
        NSLog(@"设置已读成功");
    } fail:^(int code, NSString *desc) {
        
    }];
//    [[V2TIMManager sharedInstance] markC2CMessageAsRead:_tcConv];
//    [_tcConv setReadMessage:nil succ:nil fail:nil];
}

- (int)getUnReadCount
{
    return [_tcConv unreadCount];
}

- (TIMConversation *)getConv
{
    return _tcConv;
}

- (void)setConv:(V2TIMConversation *)conv
{
    _tcConv = conv;
}

- (void)setLMsg:(V2TIMMessage *)msg
{
    SIMMsgObj *sMsgObj = [[SIMMsgObj alloc] initWithTMsg:msg];
    sMsgObj.is_robot = _is_robot;
    self.mLastMsg = [SIMMsgObj makeMsgDesc:sMsgObj];
    self.mLastMsgDate = [msg.timestamp copy];
}

- (NSString *)getTimeStr
{
    return [BGUtils formatTime:self.mLastMsgDate];
}

- (NSAttributedString *)getLastMsg
{
    NSMutableAttributedString *ats = [[NSMutableAttributedString alloc] initWithString:ASLocalizedString(@"最近消息")];

    return ats;
}

+ (NSArray *)getFollowIds
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return [NSArray array];
    }
    
    NSLog(@"[][][][][]");
    NSMutableArray *retall = NSMutableArray.new;
    NSDictionary *dic = [SResBase postReqSync:@"my_follow" ctl:@"user" parm:nil];
    SResBase *ret = [[SResBase alloc] initWithObj:dic];
    NSLog(@"ioioioioiio");

    if (ret.msuccess)
    {
        NSArray *t = [ret.mdata objectForKey:@"list"];
        for (NSDictionary *one in t)
        {
            int userId = [[one objectForKeyMy:@"user_id"] intValue];
            if (userId)
                [retall addObject:[NSString stringWithFormat:@"%d", userId]];
        }
    }

    return retall;
}

// 获取我的列表
// bFollowed  2 好友  3 非好友
+ (void)getMyFriendMsgList:(int)bFollowed lastObj:(SFriendObj *)lastObj block:(void (^)(SResBase *resb, NSArray *all, int unReadNum))block
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *conversationList = NSMutableArray.new;
        
        [[V2TIMManager sharedInstance] getConversationList:0 count:50 succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
            
            NSLog(@"-----11111");
            if(list.count == 0)
            {
               
               dispatch_async(dispatch_get_main_queue(), ^{
                   
                   block([SResBase infoWithString:ASLocalizedString(@"暂无会话")], nil, 0);
                   
               });
                     
            }
            
            NSLog(@"-----22222");

            
            for (int i=0; i<list.count; i++) {
                V2TIMConversation *item = list[i];
                if([item type] == V2TIM_C2C)
                {
                    
                    NSLog(@"-----23232323");

                    [conversationList addObject:item];

                }
            }
            
            NSLog(@"-----vvffwesfwefw");

//            NSArray *follows = [self getFollowIds];
            
            NSMutableArray *array = NSMutableArray.new;
            NSMutableString *string = NSMutableString.new;
            int i = 0;
            for (V2TIMConversation *conversation in conversationList)
            {
                
                NSLog(@"-----2434343423");

                if ([conversation type] == V2TIM_C2C)
                {
                    NSString *thisuserid = [conversation conversationID];
                    if (bFollowed == 1)
                    {
                        continue;
                    }
                    
                    if (string.length)
                        [string appendString:@","];
                    
                    [string appendString:[conversation conversationID]];
                    i++;
                    if (i == 20)
                    {
                        break;
                    }
                }
                
                if (i == 100)
                {
                    [array addObject:string];
                    string = NSMutableString.new;
                    i = 0;
                }
            }
            
            if (string.length)
                [array addObject:string];
            
            if (0 == array.count)
            { // 没有
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    block([SResBase infoWithString:ASLocalizedString(@"暂无会话")], nil, 0);
                    
                });
                return;
            }
            
            // 获取用户信息
            NSMutableDictionary *allusers = NSMutableDictionary.new;
            SResBase *sResBase = nil;
           
            NSString *user_ids = [array componentsJoinedByString:@","];
            user_ids = [user_ids stringByReplacingOccurrencesOfString:@"c2c_" withString:@""];

            NSMutableDictionary * parmDict = [NSMutableDictionary dictionary];
            [parmDict setObject:@"user" forKey:@"ctl"];
            [parmDict setObject:@"baseinfo" forKey:@"act"];
            [parmDict setObject:user_ids forKey:@"user_ids"];
            
            [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
                
                if ([[responseJson valueForKey:@"status"]integerValue] == 1) {
                    
                    SResBase *sResBases = [SResBase modelWithJSON:responseJson];
                    sResBases.msuccess = YES;
//                    [_userArray removeAllObjects];
                    NSArray *listArr =  [responseJson valueForKey:@"list"];
                    

                    for (NSDictionary *onedic in [responseJson valueForKey:@"list"])
                    {
                        SFriendObj *oneobj = [[SFriendObj alloc] initWithObj:onedic];
                        oneobj.is_robot = [[onedic objectForKey:@"is_robot"] boolValue];
                        [allusers setObject:oneobj forKey:[NSString stringWithFormat:@"%d", oneobj.mUser_id]];
                    }

                    NSLog(@"-----333333");

                    
                    NSMutableArray *retusers = NSMutableArray.new;
                    int msgNum = 0;
                    // 获取最后一条消息
                    for (int j = 0; j < conversationList.count;j++)
                    {
                        V2TIMConversation *conversation = conversationList[j];
                        
                        NSString *user_ids2 = [[conversation conversationID] stringByReplacingOccurrencesOfString:@"c2c_" withString:@""];

 
                        SFriendObj *oneobj = [allusers objectForKey:user_ids2];
                        
                        if([user_ids2 isEqualToString:@"administrator"])
                         {
                             [[V2TIMManager sharedInstance] markC2CMessageAsRead:@"administrator" succ:^{
                                 NSLog(@"设置已读成功");
                             } fail:^(int code, NSString *desc) {
                                 
                             }];
                         }
                        
                        SIMMsgObj *sMsgObj = [[SIMMsgObj alloc] initWithTMsg:[conversation lastMessage]];

                        oneobj.mLastMsg = [SIMMsgObj makeMsgDescv2:sMsgObj];
                        
                        [[V2TIMManager sharedInstance] getC2CHistoryMessageList:user_ids2 count:20 lastMsg:nil succ:^(NSArray<V2TIMMessage *> *msgs) {
                            NSLog(@"用户未读--%@----%@---%ld",user_ids2,conversation.showName,[conversation unreadCount]);
                            for (V2TIMMessage *msg in msgs)
                            {
                                V2TIMTextElem *textElem = msg.textElem;
                                V2TIMCustomElem *customElem = nil;
                                V2TIMCustomElem *Elem = (V2TIMCustomElem *) textElem.nextElem;
                                if(![msg isRead])
                                {
                                    NSLog(@"%@",[msg.customElem.data jsonValueDecoded]);
                                }
                              
                            }
                        } fail:^(int code, NSString *desc) {
                            
                        }];
                        
                        if (oneobj == nil)
                            continue;
                        int unreadCount = [conversation unreadCount];
                        oneobj.unread_count = StringFromInt(unreadCount);
                        [retusers addObject:oneobj];
                        msgNum = msgNum + unreadCount;
                        
                    }

                    NSLog(@"-----444444");

                    
                    dispatch_async(dispatch_get_main_queue(), ^{

                        block(sResBases, retusers, msgNum);

                    });
                }

            } FailureBlock:^(NSError *error) {
                
            }];
       
            
            
        } fail:^(int code, NSString *desc) {
            
        }];
        
    });
}

// 删除消息
- (void)delThis:(void (^)(SResBase *resb))block
{
    [[V2TIMManager sharedInstance] deleteConversation:StringFromInt(self.mUser_id) succ:^{
        NSLog(@"删除消息成功");
    } fail:^(int code, NSString *desc) {
        
    }];
//    [[TIMManager sharedInstance] deleteConversation:TIM_C2C receiver:[_tcConv getReceiver]];
    block([SResBase infoWithOKString:ASLocalizedString(@"删除会话成功")]);
}

- (NSArray *)sortMsg:(NSArray *)aaaMsg
{
    return [aaaMsg sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {

        SIMMsgObj *objm1 = obj1;
        SIMMsgObj *objm2 = obj2;
        NSTimeInterval f1 = [objm1.mMsgDate timeIntervalSince1970];
        NSTimeInterval f2 = [objm2.mMsgDate timeIntervalSince1970];

        if (f1 < f2)
            return NSOrderedAscending;
        else if (f1 == f2)
            return NSOrderedSame;
        return NSOrderedDescending;

    }];
}

- (void)getMsgList:(BOOL)before posmsg:(SIMMsgObj *)posmsg block:(void (^)(SResBase *resb, NSArray *all))block
{
    NSString *user_id = [NSString stringWithFormat:@"%@",StringFromInt(self.mUser_id)];
    
    [[V2TIMManager sharedInstance] getC2CHistoryMessageList:user_id count:20 lastMsg:posmsg.mCoreTMsg succ:^(NSArray<V2TIMMessage *> *msgs) {
        NSMutableArray *all = NSMutableArray.new;
        ;
        for (V2TIMMessage *one in msgs)
        {
            SIMMsgObj *sMsgObj = [[SIMMsgObj alloc] initWithTMsg:one];
            if (sMsgObj.mMsgType < 0)
                continue;
            SIMMsgObj *obj = [[SIMMsgObj alloc] initWithTMsg:one];

            // mMsgStatus;//0 正常,1发送中,2发送失败,
            if (self.is_robot)
            {
                obj.mMsgStatus = 0;
            }
            else
            {
                obj.mMsgStatus = one.status - 1;
                if (one.status == 1)
                {
                    obj.mMsgStatus = 1;
                }
                if (one.status == 2)
                {
                    obj.mMsgStatus = 0;
                }
                if (one.status == 3)
                {
                    obj.mMsgStatus = 2;
                }
            }

            [all addObject:obj];
        }
        block([SResBase infoWithOKString:ASLocalizedString(@"获取消息成功")], [self sortMsg:all]);
    } fail:^(int code, NSString *desc) {
        if (code == 10017 || code == 20012)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
            return;
        }
        block([SResBase infoWithString:desc], nil);
    }];
    /*
    [_tcConv getMessage:20
        last:posmsg.mCoreTMsg
        succ:^(NSArray *msgs) {

            NSMutableArray *all = NSMutableArray.new;
            ;
            for (V2TIMMessage *one in msgs)
            {
                SIMMsgObj *sMsgObj = [[SIMMsgObj alloc] initWithTMsg:one];
                if (sMsgObj.mMsgType < 0)
                    continue;
                SIMMsgObj *obj = [[SIMMsgObj alloc] initWithTMsg:one];

                // mMsgStatus;//0 正常,1发送中,2发送失败,
                if (self.is_robot)
                {
                    obj.mMsgStatus = 0;
                }
                else
                {
                    obj.mMsgStatus = one.status - 1;
                    if (one.status == 1)
                    {
                        obj.mMsgStatus = 1;
                    }
                    if (one.status == 2)
                    {
                        obj.mMsgStatus = 0;
                    }
                    if (one.status == 3)
                    {
                        obj.mMsgStatus = 2;
                    }
                }

                [all addObject:obj];
            }
            block([SResBase infoWithOKString:ASLocalizedString(@"获取消息成功")], [self sortMsg:all]);

        }
        fail:^(int code, NSString *msg) {
            if (code == 10017 || code == 20012)
            {
                [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
                return;
            }
            block([SResBase infoWithString:msg], nil);

        }];*/
}

// 发送文字消息
- (SIMMsgObj *)sendTextMsg:(NSString *)text block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    __block SIMMsgObj *itmsg = SIMMsgObj.new;

    
    
    NSDictionary *makedat = @{
        @"type": @(MSG_PRIVATE_TEXT),
        @"text": text,
        @"sender": [IMAPlatform sharedInstance].host.customInfoDict,
    };

    V2TIMCustomElem *text_elem = [[V2TIMCustomElem alloc] init];

    text_elem.data = [NSJSONSerialization dataWithJSONObject:makedat options:NSJSONWritingPrettyPrinted error:nil];

    V2TIMMessage *msgforsend = [[V2TIMManager sharedInstance] createCustomMessage:text_elem.data];
//    V2TIMMessage *msgforsend = [[V2TIMMessage alloc] init];
//    msgforsend.customElem = text_elem;
//    [msgforsend addElem:text_elem];

    itmsg.mMsgID = msgforsend.msgID;
    itmsg.mMsgStatus = 1;
    itmsg.mHeadImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict objectForKey:@"head_image"];
    itmsg.mIsSendOut = YES;
    itmsg.mMsgType = 1;
    itmsg.mMsgDate = msgforsend.timestamp;
    itmsg.mTextMsg = text;
    itmsg.mCoreTMsg = msgforsend;
    
    NSString *groupId = nil;
    NSString *receiver = nil;
//    if([_tcConv getType] == TIM_C2C)
//    {
//        receiver = [_tcConv getReceiver];
//    }
//    else
//    {
//        groupId = [_tcConv getReceiver];
//    }
    
    [[V2TIMManager sharedInstance] sendMessage:msgforsend receiver:StringFromInt(self.mUser_id) groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
        
    } succ:^{
        itmsg.mMsgStatus = 0;
        block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
    } fail:^(int code, NSString *desc) {
        block([SResBase infoWithString:desc], itmsg);
    }];
    
//    [_tcConv sendMessage:msgforsend
//        succ:^{
//
//            itmsg.mMsgStatus = 0;
//            block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
//
//        }
//        fail:^(int code, NSString *msg) {
//            if (code == 10017 || code == 20012)
//            {
//                [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
//                return;
//            }
//            itmsg.mMsgStatus = 2;
//            if (_is_robot)
//            {
//                itmsg.mMsgStatus = 0;
//                block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
//            }
//            else
//            {
//                block([SResBase infoWithString:msg], itmsg);
//            }
//        }];
//
//    if (_is_robot)
//    {
//        itmsg.mMsgStatus = 0;
//    }
//
    return itmsg;
}

// 记住:文件不能记住全路径,每次APP运行中间的有一截路径不同
+ (NSString *)makepicsavepath
{
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    urlStr = [urlStr stringByAppendingPathComponent:[NSString stringWithFormat:@"picfile_%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]]];

    return urlStr;
}

+ (NSString *)makevoicesavepath:(NSString *)filename
{
    NSString *urlStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];

    NSString *ssss = filename;
    if (ssss.length == 0)
    {
        ssss = [NSString stringWithFormat:@"vociefile_%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]];
    }

    urlStr = [urlStr stringByAppendingPathComponent:ssss];

    return urlStr;
}

+ (NSString *)makevoicefilename
{
    return [NSString stringWithFormat:@"vociefile_%ld", (NSInteger)[[NSDate date] timeIntervalSince1970]];
}

- (SIMMsgObj *)sendPicMsg:(UIImage *)img block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    __block SIMMsgObj *itmsg = SIMMsgObj.new;

    NSString *iimgsavepath = [SFriendObj makepicsavepath];
    NSData *ddd = UIImageJPEGRepresentation(img, 0.9f);
    if (![ddd writeToFile:iimgsavepath atomically:YES])
    {
        block([SResBase infoWithString:ASLocalizedString(@"上传图片失败")], nil);
        return nil;
    }

    NSDictionary *makedat = @{
        @"type": @(MSG_PRIVATE_IMAGE),
        @"sender": [IMAPlatform sharedInstance].host.customInfoDict,
    };

    V2TIMCustomElem *text_elem = [[V2TIMCustomElem alloc] init];
    text_elem.data = [NSJSONSerialization dataWithJSONObject:makedat options:NSJSONWritingPrettyPrinted error:nil];

//    V2TIMMessage *msgforsend = [[V2TIMMessage alloc] init];
    
    V2TIMMessage *msgforsend = [[V2TIMManager sharedInstance] createImageMessage:iimgsavepath];

    
//    [msg ];

//    V2TIMImageElem *image_elem = [[V2TIMImageElem alloc] init];
//    image_elem.path = iimgsavepath;
//    image_elem.level = TIM_IMAGE_COMPRESS_LOW;
//    [msgforsend addElem:image_elem];

    [msgforsend.imageElem appendElem:text_elem];
    itmsg.mMsgID = msgforsend.msgID;
    itmsg.mMsgStatus = 1;
    itmsg.mHeadImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict objectForKey:@"head_image"];
    itmsg.mIsSendOut = YES;
    itmsg.mMsgType = 2;
    itmsg.mMsgDate = msgforsend.timestamp;
    itmsg.mImgObj = img;
    itmsg.mPicURL = [NSURL fileURLWithPath:iimgsavepath].absoluteString;

    itmsg.mCoreTMsg = msgforsend;

    
//    [[V2TIMManager sharedInstance] sendMessage:msgforsend receiver:StringFromInt(self.mUser_id) groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
//
//    } succ:^{
//        itmsg.mMsgStatus = 0;
//        block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
//    } fail:^(int code, NSString *desc) {
//        block([SResBase infoWithString:desc], itmsg);
//    }];
    
    [[V2TIMManager sharedInstance] sendMessage:msgforsend receiver:StringFromInt(self.mUser_id) groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
        
    } succ:^{
        itmsg.mMsgStatus = 0;
        block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
    } fail:^(int code, NSString *desc) {
        if (code == 10017 || code == 20012)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
            return;
        }
        itmsg.mMsgStatus = 2;
        if (_is_robot)
        {
            itmsg.mMsgStatus = 0;
            block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
        }
        else
        {
            block([SResBase infoWithString:desc], itmsg);
        }
    }];
    
//    [_tcConv sendMessage:msgforsend
//        succ:^{
//
//            itmsg.mMsgStatus = 0;
//            block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
//
//        }
//        fail:^(int code, NSString *msg) {
//            if (code == 10017 || code == 20012)
//            {
//                [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
//                return;
//            }
//            itmsg.mMsgStatus = 2;
//            if (_is_robot)
//            {
//                itmsg.mMsgStatus = 0;
//                block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
//            }
//            else
//            {
//                block([SResBase infoWithString:msg], itmsg);
//            }
//
//        }];
    if (_is_robot)
    {
        itmsg.mMsgStatus = 0;
    }

    return itmsg;
}

- (SIMMsgObj *)sendVoiceMsg:(NSURL *)voicepath duration:(NSTimeInterval)duration block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    __block SIMMsgObj *itmsg = SIMMsgObj.new;

    NSDictionary *makedat = @{
        @"type": @(MSG_PRIVATE_VOICE),
        @"sender": [IMAPlatform sharedInstance].host.customInfoDict,
        @"duration": @(duration * 1000.0f)
    };

    V2TIMCustomElem *text_elem = [[V2TIMCustomElem alloc] init];
    text_elem.data = [NSJSONSerialization dataWithJSONObject:makedat options:NSJSONWritingPrettyPrinted error:nil];


    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        
        V2TIMMessage *msgforsend = [[V2TIMManager sharedInstance] createSoundMessage:voicepath.path duration:duration];
//        [msgforsend addElem:text_elem];

        itmsg.mMsgID = msgforsend.msgID;
        itmsg.mMsgStatus = 1;
        itmsg.mHeadImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict objectForKey:@"head_image"];
        itmsg.mIsSendOut = YES;
        itmsg.mMsgType = 3;
        itmsg.mMsgDate = msgforsend.timestamp;
        [msgforsend.soundElem appendElem:text_elem];
        itmsg.mVoiceData = [NSData dataWithContentsOfURL:voicepath];
        itmsg.mDurlong = duration;

        itmsg.mCoreTMsg = msgforsend;
        
        NSString *srcfilepath = [NSString stringWithFormat:@"%s", voicepath.fileSystemRepresentation];
        NSString *desfilepath = [srcfilepath stringByAppendingString:@".out"];

        _condit = MYNSCondition.new;
        _aacconvert = [[TPAACAudioConverter alloc] initWithDelegate:self
                                                             source:[NSString stringWithFormat:@"%s", voicepath.fileSystemRepresentation]
                                                        destination:desfilepath];
        [_aacconvert start];

        [_condit lock];
        [_condit wait];
        [_condit unlock];

        _aacconvert = nil;
        _condit = nil;
        if (_converterrstr)
        {
            dispatch_async(dispatch_get_main_queue(), ^{

                block([SResBase infoWithString:_converterrstr], nil);
                _converterrstr = nil;

            });
        }
        else
        {
            [[V2TIMManager sharedInstance] sendMessage:msgforsend receiver:StringFromInt(self.mUser_id) groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
                
            } succ:^{
//                V2TIMSoundElem *sound_elem = (V2TIMSoundElem *) [itmsg.mCoreTMsg getElem:1];
                NSString *ssfile = [voicepath lastPathComponent];
                [SIMMsgObj saveData:ssfile forkey:msgforsend.soundElem.uuid];

                itmsg.mMsgStatus = 0;
                block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
                
            } fail:^(int code, NSString *desc) {
                if (code == 10017 || code == 20012)
                {
                    [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
                    return;
                }
                itmsg.mMsgStatus = 2;
                if (_is_robot)
                {
                    itmsg.mMsgStatus = 0;
                    block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
                }
                else
                {
                    block([SResBase infoWithString:desc], itmsg);
                }            }];
            
            /*V2TIMSoundElem *sound_elem = [[V2TIMSoundElem alloc] init];
            [sound_elem setPath:desfilepath];
            [sound_elem setSecond:duration];
            [msgforsend addElem:sound_elem];

            [_tcConv sendMessage:msgforsend
                succ:^{

                    V2TIMSoundElem *sound_elem = (V2TIMSoundElem *) [itmsg.mCoreTMsg getElem:1];
                    NSString *ssfile = [voicepath lastPathComponent];
                    [SIMMsgObj saveData:ssfile forkey:sound_elem.uuid];

                    itmsg.mMsgStatus = 0;
                    block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);

                }
                fail:^(int code, NSString *msg) {
                    if (code == 10017 || code == 20012)
                    {
                        [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
                        return;
                    }
                    itmsg.mMsgStatus = 2;
                    if (_is_robot)
                    {
                        itmsg.mMsgStatus = 0;
                        block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
                    }
                    else
                    {
                        block([SResBase infoWithString:msg], itmsg);
                    }
                }];*/
        }
    });
    if (_is_robot)
    {
        itmsg.mMsgStatus = 0;
    }
    return itmsg;
}

- (void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter
{
    NSLog(@"AACAudioConverterDidFinishConversion ok");
    _converterrstr = nil;
    [_condit lock];
    [_condit signal];
    [_condit unlock];
}

- (void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError :%@", error);
    _converterrstr = ASLocalizedString(@"语音数据格式转换失败");
    [_condit lock];
    [_condit signal];
    [_condit unlock];
}

- (void)sendGiftMsg:(GiftModel *)findgifobj block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    [SResBase postReq:@"send_prop"
        ctl:@"deal"
        parm:@{ @"prop_id": @(findgifobj.ID),
                @"num": @(1),
                @"to_user_id": @(self.mUser_id) }
        block:^(SResBase *resb) {

            if (resb.msuccess)
            {
                [self realSendGift:resb block:block];
            }
            else
            {
                block(resb, nil);
            }
        }];
}

- (void)sendCoinMsgWithCoin:(NSString *)coin block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    [SResBase postReq:@"sendCoin"
        ctl:@"games"
        parm:@{ @"to_user_id": @(self.mUser_id),
                @"coin": coin }
        block:^(SResBase *resb) {
            if (resb.msuccess)
            {
                [self realSendGift:resb block:block];
            }
            else
            {
                block(resb, nil);
            }
        }];
}

- (void)sendDiamondsMsgWithDiamonds:(NSString *)diamonds block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block;
{
    [SResBase postReq:@"sendDiamonds"
                  ctl:@"games"
                 parm:@{@"to_user_id": @(self.mUser_id), @"diamonds": diamonds}
                block:^(SResBase *resb) {
                    if (resb.msuccess)
                    {
                        [self realSendGift:resb block:block];
                    }
                    else
                    {
                        block(resb, nil);
                    }
                }];
}

- (SIMMsgObj *)realSendGift:(SResBase *)resb block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    __block SIMMsgObj *itmsg = SIMMsgObj.new;

    
    NSMutableDictionary *makedat = NSMutableDictionary.new;
    [makedat setDictionary:resb.mdata];
    [makedat setObject:@"conversationDesc" forKey:ASLocalizedString(@"[礼物]")];
    [makedat setObject:[IMAPlatform sharedInstance].host.customInfoDict forKey:@"sender"];
    [makedat setObject:@(MSG_PRIVATE_GIFT) forKey:@"type"];

    V2TIMCustomElem *text_elem = [[V2TIMCustomElem alloc] init];
    text_elem.data = [NSJSONSerialization dataWithJSONObject:makedat options:NSJSONWritingPrettyPrinted error:nil];
    
    V2TIMMessage *msgforsend = [[V2TIMManager sharedInstance] createCustomMessage:text_elem.data];
    
//    V2TIMMessage *msgforsend = [[V2TIMMessage alloc] init];
//    [msgforsend addElem:text_elem];

    itmsg.mMsgID = msgforsend.msgID;
    itmsg.mMsgStatus = 1;
    itmsg.mHeadImgUrl = [[IMAPlatform sharedInstance].host.customInfoDict objectForKey:@"head_image"];
    itmsg.mIsSendOut = YES;
    itmsg.mMsgType = 4;
    itmsg.mMsgDate = msgforsend.timestamp;

    itmsg.mGiftId = [NSString stringWithFormat:@"%d", [[makedat objectForKey:@"prop_id"] intValue]];

    //礼物消息的数据
    itmsg.mGiftIconURL = [makedat objectForKey:@"prop_icon"]; //礼物小图标URL
    itmsg.mGiftDesc = [makedat objectForKey:@"from_msg"];
    itmsg.mJyStr = [makedat objectForKey:@"from_score"];

    itmsg.mCoreTMsg = msgforsend;
    
    
    [[V2TIMManager sharedInstance] sendMessage:msgforsend receiver:StringFromInt(self.mUser_id) groupID:nil priority:V2TIM_PRIORITY_DEFAULT onlineUserOnly:NO offlinePushInfo:nil progress:^(uint32_t progress) {
        
    } succ:^{
        itmsg.mMsgStatus = 0;
        block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
    } fail:^(int code, NSString *desc) {
        if (code == 10017 || code == 20012)
        {
            [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
            // return ;
        }
        itmsg.mMsgStatus = 2;
        block([SResBase infoWithString:desc], itmsg);

    }];
    

    
    
//    [_tcConv sendMessage:msgforsend
//        succ:^{
//
//            itmsg.mMsgStatus = 0;
//            block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], itmsg);
//
//        }
//        fail:^(int code, NSString *msg) {
//            if (code == 10017 || code == 20012)
//            {
//                [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
//                // return ;
//            }
//            itmsg.mMsgStatus = 2;
//            block([SResBase infoWithString:msg], itmsg);
//
//        }];
     

    return itmsg;
}

- (void)reSendMsg:(SIMMsgObj *)resmsg block:(void (^)(SResBase *resb, SIMMsgObj *thatmsg))block
{
    __block SIMMsgObj *neeresend = resmsg;

//    neeresend.mMsgStatus = 1;
//    [_tcConv sendMessage:neeresend.mCoreTMsg
//        succ:^{
//
//            neeresend.mMsgStatus = 0;
//            block([SResBase infoWithOKString:ASLocalizedString(@"发送消息成功")], neeresend);
//
//        }
//        fail:^(int code, NSString *msg) {
//            if (code == 10017 || code == 20012)
//            {
//                [FanweMessage alertHUD:ASLocalizedString(@"您已被禁言")];
//                return;
//            }
//            neeresend.mMsgStatus = 2;
//            block([SResBase infoWithString:msg], neeresend);
//
//        }];
}

// 忽略未读
+ (void)ignoreMsg:(NSArray *)allFriends block:(void (^)(SResBase *resb))block
{
    for (SFriendObj *one in allFriends)
    {

        [one ignoreThisUnReadCount];
    }
    block([SResBase infoWithOKString:ASLocalizedString(@"操作成功")]);
}

// 废弃
+ (int)getAllUnReadCount
{
    int retcount = 0;

    int cnt = [[TIMManager sharedInstance] conversationCount];
    NSArray *follows = [self getFollowIds];
    for (int index = 0; index < cnt; index++)
    {
        //TIMConversation *conversation = [[TIMManager sharedInstance] getConversationByIndex:index];
        TIMConversation *conversation = [[[TIMManager sharedInstance] getConversationList] objectAtIndex:index];

        if ([conversation getType] == TIM_C2C && [follows containsObject:[conversation getReceiver]])
        {
            int ii = [conversation getUnReadMessageNum];
            if (ii)
            {
                int immsgcount = 0;
                NSArray *array = [conversation getLastMsgs:20];
                for (int j = 0; j < array.count && j < ii; j++)
                {
                    V2TIMMessage *msg = array[j];

                    if (msg.status != TIM_MSG_STATUS_HAS_DELETED)
                    {
                        SIMMsgObj *tttmsgss = [[SIMMsgObj alloc] initWithTMsg:msg];
                        if (tttmsgss.mMsgType == -1) //0 时间消息, 1 文字消息, 2,图片消息,3 语音消息,4 礼物
                        {
                            continue;
                        }
                        //ykk bug 4
                        immsgcount = [conversation getUnReadMessageNum];
                    }
                }
                retcount += immsgcount;
            }
        }
    }
    return retcount;
}

+ (void)getAllUnReadCountComplete:(void (^)(int num))block
{
    [self getMyFocusFriendUnReadMsgNumIsFriend:0
                                         block:^(int unReadNum) {
                                             if (block)
                                             {
                                                 block(unReadNum);
                                             }
                                         }];
}

/**
 获取好友／未关注 消息个数
 
 0 查询总消息   1 好友  2 非好友
 
 cnt            会话数量
 num            记录未读数目
 follows        获取好友id （注意）（这是个耗时操作。最好修改这个方法，放在gcd里处理）
 array          将符合的会话放入数组（包含 好友／未关注）
 num +=         区分数组里 好友／未关注，根据isFriend 确定返回的数据
 
 @param isFriend 获取all会话，获取好友id数组，isFriend筛选
 @param block 回调
 */
+ (void)getMyFocusFriendUnReadMsgNumIsFriend:(int)isFriend block:(void (^)(int unReadNum))block
{
    // 如果没有登录，就不需要后续操作
    if (![IMAPlatform isAutoLogin])
    {
        return;
    }

    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{

        NSMutableArray *conversationList = NSMutableArray.new;
        int cnt = [[TIMManager sharedInstance] conversationCount];
        
        TIMConversation *startfind = nil;
        BOOL bfind = startfind == nil; // 如果是空的就从开始

        
        [[V2TIMManager sharedInstance] getConversationList:0 count:50 succ:^(NSArray<V2TIMConversation *> *list, uint64_t nextSeq, BOOL isFinished) {
            for (int index = 0; index < list.count; index++)
            {
                V2TIMConversation *conversation = list[index];

                if ([conversation type] == V2TIM_C2C)
                {
                    [conversationList addObject:conversation];
                }
            }
            
            
            if (0 == list.count)
            { // 没有

                dispatch_async(dispatch_get_main_queue(), ^{

                    block(0);

                });
                return;
            }
            
//            NSArray *follows = [self getFollowIds];

            NSMutableArray *array = NSMutableArray.new;
            NSMutableString *string = NSMutableString.new;
            int i = 0;
            for (V2TIMConversation *conversation in conversationList)
            {
                if ([conversation type] == V2TIM_C2C)
                {
                    NSString *thisuserid = [conversation conversationID];
                    if (isFriend == 0)
                    {
                    }
//                    if (isFriend == 1)
//                    { //如果是查询关注的,,,
//                        if (![follows containsObject:thisuserid])
//                            continue;
//                    }
//                    if (isFriend == 2)
//                    { //如果是查询没有关注的,
//                        if ([follows containsObject:thisuserid])
//                            continue;
//                    }

                    if (string.length)
                        [string appendString:@","];

                    [string appendString:[conversation conversationID]];
                    i++;
                    if (i == 20)
                    {
                        break;
                    }
                }

                if (i == 100)
                {
                    [array addObject:string];
                    string = NSMutableString.new;
                    i = 0;
                }
            }

            if (string.length)
                [array addObject:string];

            if (0 == array.count)
            { // 没有
                dispatch_async(dispatch_get_main_queue(), ^{

                    block(0);

                });
                return;
            }

            // 获取用户信息
            /*NSMutableDictionary *allusers = NSMutableDictionary.new;
            SResBase *sResBase = nil;
            for (NSString *one in array)
            {
                NSString *one2 = [one stringByReplacingOccurrencesOfString:@"c2c_" withString:@""];

                NSDictionary *retdic = [SResBase postReqSync:@"baseinfo" ctl:@"user" parm:@{ @"user_ids": one2 }];
                if (retdic)
                {
                    sResBase = [[SResBase alloc] initWithObj:retdic];
                    NSArray *tlist = [sResBase.mdata objectForKeyMy:@"list"];
                    for (NSDictionary *onedic in tlist)
                    {
                        SFriendObj *oneobj = [[SFriendObj alloc] initWithObj:onedic];
                        oneobj.is_robot = [[onedic objectForKey:@"is_robot"] boolValue];
                        [allusers setObject:oneobj forKey:[NSString stringWithFormat:@"%d", oneobj.mUser_id]];
                    }
                }
                else
                {
                    sResBase = [SResBase infoWithString:ASLocalizedString(@"获取用户信息失败")];
                    break;
                }
            }*/

            int msgNum = 0;
            //获取最后一条消息
            for (int j = 0; j < conversationList.count; j++)
            {
                V2TIMConversation *conversation = conversationList[j];
//                SFriendObj *oneobj = [allusers objectForKey:[conversation conversationID]];
//                if (oneobj == nil)
//                    continue;

                int uncount = [conversation unreadCount];

                    msgNum = msgNum + uncount;
//                }
            }

            dispatch_async(dispatch_get_main_queue(), ^{

                block(msgNum);

            });
            

        } fail:^(int code, NSString *desc) {
            
        }];
        



        
    });
}

@end
