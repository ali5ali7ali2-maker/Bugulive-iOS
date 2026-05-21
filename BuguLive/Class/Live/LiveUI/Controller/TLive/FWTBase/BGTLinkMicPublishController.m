//
//  BGTLinkMicPublishController.m
//  BuguLive
//
//  Created by xfg on 2017/1/19.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGTLinkMicPublishController.h"

#define MAX_LINKMIC_MEMBER_SUPPORT  1

#define VIDEO_VIEW_WIDTH            120
#define VIDEO_VIEW_HEIGHT           160
#define VIDEO_VIEW_MARGIN_BOTTOM    70
#define VIDEO_VIEW_MARGIN_RIGHT     20

//小图标
#define BOTTOM_BTN_ICON_WIDTH  35


@implementation TCLivePlayListenerImpl

- (void)onPlayEvent:(int)evtID withParam:(NSDictionary*)param
{
    if (self.delegate)
    {
        [self.delegate onLivePlayEvent:self.playUrl withEvtID:evtID andParam:param];
    }
}

- (void)onNetStatus:(NSDictionary*) param
{
    if (self.delegate)
    {
        [self.delegate onLivePlayNetStatus:self.playUrl withParam:param];
    }
}

@end


@interface BGTLinkMicPublishController ()<ITCLivePlayListener>
{
    BOOL                    _isSupprotHardware;
}

@end


@implementation BGTLinkMicPublishController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playItemArray = [NSMutableArray array];
    self.linkMemeberSet = [NSMutableSet set];
    
    _isSupprotHardware = ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0);

    [self addLinkMicPlayItem];
    
//    [self initBeautyView];
}

- (void)addLinkMicPlayItem
{
    for (int i = 0; i<3; i++)
    {
        BGTLinkMicPlayItem* playItem = [[BGTLinkMicPlayItem alloc] init];
        playItem.videoView = [[UIView alloc] init];
        [self.view addSubview:playItem.videoView];
        
        playItem.livePlayListener = [[TCLivePlayListenerImpl alloc] init];
        playItem.livePlayListener.delegate = self;
        TXLivePlayConfig * playConfig0 = [[TXLivePlayConfig alloc] init];
        playItem.livePlayer = [[TXLivePlayer alloc] init];
        playItem.livePlayer.delegate = playItem.livePlayListener;
        [playItem.livePlayer setConfig: playConfig0];
        [playItem.livePlayer setRenderMode:RENDER_MODE_FILL_EDGE];
        playItem.pending = false;
        playItem.itemIndex = i;
        [playItem emptyPlayInfo];
        
        [_playItemArray addObject:playItem];
    }
}

-(void)initBeautyView{
    //#error TiSDK Key, 与包名对应，请联系商务获取
        NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
        if([BGUtils isBlankString:key])
        {
            //这里写上那个key
            key = @"517a990947274dd8b51e1525feb0fb79";
            //        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"美颜key为空，请尝试重新打开app获取！")];
        }
        else
        {
//            [TiSDK init:key];

            //在这里创建好像会被覆盖掉 你看看这里

            //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([[GlobalVariables sharedInstance].appModel.spear_live isEqualToString:@"1"])
            {
//                NSString* key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
//
//                //    NSString* key = @"";
//                [TiSDK init:key CallBack:^(InitStatus initStatus) {
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TiSDKInitStatusNotification" object:nil];
//                }];
                    
                //    [[TiUIManager shareManager] loadToSuperview:self.view];
//                [TiUIManager shareManager].showsDefaultUI = YES;
//                [[TiUIManager shareManager]loadToWindowDelegate:nil];

            }
        }
}

#pragma mark ---------美颜增加-------------
//隐藏拓幻美颜
/*
- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height{
    
    return [[TiSDKManager shareManager] renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:self.txLivePublisher.config.frontCamera];
    
}
*/
#pragma mark - ----------------------- 推流模块 -----------------------
- (BOOL)startRtmp
{
    return [super startRtmp];
}

- (void)stopRtmp
{
    [super stopRtmp];
    
    for (BGTLinkMicPlayItem* playItem in _playItemArray)
    {
        [playItem stopPlay];
    }
}

#pragma mark - ----------------------- 连麦 -----------------------
#pragma mark 同意连麦
- (void)agreeLinkMick:(NSString *)streamPlayUrl applicant:(NSString *)userID
{
    self.txLivePushonfig.enableAEC = YES;
    [self.txLivePublisher setConfig:self.txLivePushonfig];
    
    if ([BGUtils isBlankString:streamPlayUrl] || [BGUtils isBlankString:userID])
    {
        return;
    }
}

#pragma mark 断开连麦
- (void)breakLinkMick:(NSString *)userID
{
    
    [BGLiveSDKViewModel tLiveStopMick:self.roomIDStr toUserId:userID];
    
    if (![BGUtils isBlankString:userID])
    {
        BGTLinkMicPlayItem *playItem = [self getPlayItemByUserID:userID];
        if (playItem)
        {
            [playItem stopPlay];
            [playItem emptyPlayInfo];
            
            if (_linkMicPublishDelegate && [_linkMicPublishDelegate respondsToSelector:@selector(playMickResult:userID:)])
            {
                [_linkMicPublishDelegate playMickResult:NO userID:userID];
            }
        }
    }
}

//语音连麦
- (void)adjustPlayItemVoiceUserList:(NSArray *)userlist;
{
    [super adjustPlayItemVoiceUserList:userlist];
}
#pragma mark 调整连麦窗口
- (void)adjustPlayItem:(TLiveMickListModel *)mickListModel
{
    //声网dev
    if([GlobalVariables sharedInstance].openAgora == YES)
    {
        [self adjustPlayItemAgora:mickListModel];
        return;
    }
    @synchronized (self.linkMemeberSet)
    {
        [self.linkMemeberSet removeAllObjects];
        
        if (!mickListModel.list_lianmai || [mickListModel.list_lianmai count] == 0)
        {
            for (BGTLinkMicPlayItem *playItem in _playItemArray)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
            }
            return;
        }
        
        for (TLiveMickModel *mickModel in mickListModel.list_lianmai)
        {
            BOOL isHasPlayItem = NO;
            BGTLinkMicPlayItem *tmpPlayItem;
            int i = 0;
            
            for (BGTLinkMicPlayItem *playItem in _playItemArray)
            {
                i ++;
                
                if ([playItem.userID isEqualToString:mickModel.user_id])
                {
                    isHasPlayItem = YES;
                    
                    TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
                    playItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                    
                    break;
                }
                
                if (([BGUtils isBlankString:playItem.userID] || i == [_playItemArray count]) && !tmpPlayItem)
                {
                    tmpPlayItem = playItem;
                }
            }
            
            if (!isHasPlayItem)
            {
                TLiveMickLayoutParamModel *paramModel = mickModel.layout_params;
                tmpPlayItem.videoView.frame = CGRectMake(kScreenW * paramModel.location_x, kScreenH * paramModel.location_y, kScreenW * paramModel.image_width, kScreenH * paramModel.image_height);
                
                [tmpPlayItem stopPlay];
                [tmpPlayItem emptyPlayInfo];
                
                tmpPlayItem.pending = YES;
                tmpPlayItem.isWorking = YES;
                tmpPlayItem.userID = mickModel.user_id;
                [tmpPlayItem setLoadingText:ASLocalizedString(@"等待观众推流···")];
                [tmpPlayItem initLoadingView:tmpPlayItem.videoView];
                [tmpPlayItem startLoading];
                [tmpPlayItem startPlay:mickModel.play_rtmp2_acc];
            }
            
            //加入连麦成员列表
            [self.linkMemeberSet addObject:mickModel.user_id];
        }
        
        for (BGTLinkMicPlayItem *playItem in _playItemArray)
        {
            if (!playItem.isWorking)
            {
                [playItem stopPlay];
                [playItem stopLoading];
                [playItem emptyPlayInfo];
            }
        }
        
        if ([self.linkMemeberSet count] == 0 && self.txLivePushonfig.enableAEC)
        {
            self.txLivePushonfig.enableAEC = NO;
            [self.txLivePublisher setConfig:self.txLivePushonfig];
        }
    }
}

#pragma mark 通过用户ID来获取连麦视图
- (BGTLinkMicPlayItem *)getPlayItemByUserID:(NSString*)userID
{
    if (userID)
    {
        for (BGTLinkMicPlayItem* playItem in _playItemArray)
        {
            if ([userID isEqualToString:playItem.userID])
            {
                return playItem;
            }
        }
    }
    return nil;
}

- (BGTLinkMicPlayItem*)getPlayItemByStreamUrl:(NSString*)streamUrl
{
    if (streamUrl)
    {
        for (BGTLinkMicPlayItem* playItem in _playItemArray)
        {
            if ([streamUrl isEqualToString:playItem.playUrl])
            {
                return playItem;
            }
        }
    }
    return nil;
}

#pragma mark 连麦失败处理
- (void)handleLinkMicFailed:(NSString*)userID message:(NSString*)message
{
    if (userID)
    {
        BGTLinkMicPlayItem* playItem = [self getPlayItemByUserID:userID];
        if (playItem == nil)
        {
            return;
        }
        
        if (_linkMicPublishDelegate && [_linkMicPublishDelegate respondsToSelector:@selector(playMickResult:userID:)])
        {
            [_linkMicPublishDelegate playMickResult:NO userID:userID];
        }
        
        [playItem stopPlay];
        [playItem emptyPlayInfo];
        
        if (message != nil && message.length > 0)
        {
            [self toastTip:message];
        }
    }
}



#pragma mark - ----------------------- ITCLivePlayListener代理事件 -----------------------
- (void)onLivePlayEvent:(NSString*)strStreamUrl withEvtID:(int)event andParam:(NSDictionary*)param
{
    if (event != PLAY_EVT_PLAY_PROGRESS)
    {
        NSLog(@"==========playEvtID2:%d",event);
    }
    
    BGTLinkMicPlayItem * playItem = [self getPlayItemByStreamUrl:strStreamUrl];
    if (playItem == nil)
    {
        return;
    }
    
    if (event == PLAY_EVT_PLAY_BEGIN)
    {
        if (playItem.pending == YES)
        {
            playItem.pending = NO;
            [playItem stopLoading];
            
            if (_linkMicPublishDelegate && [_linkMicPublishDelegate respondsToSelector:@selector(playMickResult:userID:)])
            {
                [_linkMicPublishDelegate playMickResult:YES userID:playItem.userID];
            }
        }
    }
    else if (event == PLAY_EVT_PLAY_END)
    {
        [playItem stopLoading];
        
        if (playItem.pending == YES)
        {
            [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"拉流失败，结束连麦")];
        }
        else
        {
            [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"连麦观众视频断流，结束连麦")];
        }
        [self breakLinkMick:playItem.userID];
    }
    else if (event == PLAY_ERR_NET_DISCONNECT)
    {
        [playItem stopLoading];
        
//        [BGLiveSDKViewModel tLiveStopMick:self.roomIDStr toUserId:playItem.userID];
        
        if (playItem.pending == YES)
        {
//            [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"拉流失败，继续尝试连麦")];
            
            [playItem reStartPlay];
            
        }
        else
        {
            [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"连麦观众视频断流，结束连麦")];
        }
//        [self breakLinkMick:playItem.userID];
    }
    else if (event == PLAY_ERR_GET_RTMP_ACC_URL_FAIL)
    {
        if (playItem.reStartTimes < 5)
        {
            [playItem reStartPlay];
        }
        else
        {
            [playItem stopLoading];
            
            [BGLiveSDKViewModel tLiveStopMick:self.roomIDStr toUserId:playItem.userID];
            
            if (playItem.pending == YES)
            {
                [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"拉流失败，结束连麦")];
            }
            else
            {
                [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"连麦观众视频断流，结束连麦")];
            }
        }
        playItem.reStartTimes ++;
    }
    else if (event == PUSH_WARNING_HW_ACCELERATION_FAIL || event == PLAY_WARNING_HW_ACCELERATION_FAIL)
    {
        [playItem stopLoading];
        
        [self handleLinkMicFailed:playItem.userID message:ASLocalizedString(@"系统不支持硬编或硬解")];
        _isSupprotHardware = NO;
    }
}

- (void)onLivePlayNetStatus:(NSString*)playUrl withParam:(NSDictionary*)param
{
    
}

- (void)clickCloseBtn:(UserView *)view
{
    if([self.linkMicPublishDelegate respondsToSelector:@selector(clickCloseBtn:)])
    {
        [self.linkMicPublishDelegate clickCloseBtn:view];
    }
}

@end
