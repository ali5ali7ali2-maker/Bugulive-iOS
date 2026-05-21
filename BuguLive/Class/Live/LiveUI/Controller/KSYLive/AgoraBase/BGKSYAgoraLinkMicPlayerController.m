//
//  BGKSYAgoraLinkMicPlayerController.m
//  FanweApp
//
//  Created by xfg on 2017/2/13.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGKSYAgoraLinkMicPlayerController.h"

@interface BGKSYAgoraLinkMicPlayerController ()

@end

@implementation BGKSYAgoraLinkMicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _linkMicBaseController = [[BGKSYAgoraStreamerBaseController alloc] init];
    _linkMicBaseController.isApplicant = YES;
    [self addChild:_linkMicBaseController inRect:self.view.bounds];
    [self.view sendSubviewToBack:_linkMicBaseController.view];
    _linkMicBaseController.view.hidden = YES;
}

#pragma mark 开始连麦
/*
 *  开始连麦
 *  applicantId：申请连麦者ID
 *  responderId：接收连麦者ID
 *  roomId：房间ID
 */
- (void)startLinkMic:(NSString *)applicantId andResponderId:(NSString *)responderId roomId:(NSString *)roomId
{
    [_linkMicBaseController startLinkMic:applicantId andResponderId:responderId roomId:roomId];

    self.videoContrainerView.hidden = YES;
    _linkMicBaseController.view.hidden = NO;
    [self.txLivePlayer pause];
    
    __weak typeof(self) ws = self;
    
    _linkMicBaseController.onMyCallStart = ^(int status){
    
        if(status == 200)   // 建立连接
        {
            
        }
        else if(status == 408 || status == 404)  // 408:对方无应答 404:呼叫未注册号码,主动停止
        {
            
        }
        
    };
    
    _linkMicBaseController.onMyCallStop = ^(int status){
        
        ws.linkMicBaseController.view.hidden = YES;
        
    };
    
    _linkMicBaseController.onMyChannelJoin = ^(int status){
        
    };
}

- (void)reloadPlay
{
    [self.txLivePlayer startPlay:self.playUrlStr type:PLAY_TYPE_LIVE_RTMP];

}

#pragma mark 停止连麦
/*
 *  停止连麦
 *  applicantId：申请连麦者ID
 */
- (void)stopLinkMic:(NSString *)applicantId
{
    if (_linkMicBaseController.gPUStreamerKit)
    {
        [_linkMicBaseController stopLinkMic:applicantId];
        
        self.videoContrainerView.hidden = NO;
        [self.txLivePlayer resume];
//        [self performSelector:@selector(reloadPlay) withObject:nil afterDelay:1];
    }
}


-(void)stopRtmp
{
    [super stopRtmp];
    [self.txLivePlayer stopPlay];
    [self stopLinkMic:_linkMicBaseController.applicantId];
    [_linkMicBaseController stopLinkMic:_linkMicBaseController.applicantId];
}

#pragma mark 结束播放
- (void)stopPlay
{
    [self.txLivePlayer stopPlay];
    [self stopLinkMic:_linkMicBaseController.applicantId];
    [_linkMicBaseController stopLinkMic:_linkMicBaseController.applicantId];
}

@end
