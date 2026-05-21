//
//  BGLiveBaseController.h
//  BugoLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  直播基类

#import <UIKit/UIKit.h>
#import <CallKit/CallKit.h>
#import "BGBaseViewController.h"
#import "BGIMMsgHandler.h"
#import "CurrentLiveInfo.h"

@interface BGLiveBaseController : BGBaseViewController <CXCallObserverDelegate>
{

@private
    // 用于音频退出直播时还原现场
    NSString                        *_audioSesstionCategory;        // 进入房间时的音频类别
    NSString                        *_audioSesstionMode;            // 进入房间时的音频模式

@protected
    CXCallObserver                  *_callObserver;                 // 电话监听 (替换已废弃的CTCallCenter)
    BOOL                            _isAtForeground;                // 是否在前台
    BOOL                            _isPhoneInterupt;               // 是否是电话中断
    BOOL                            _hasHandleCall;

    BGIMMsgHandler                  *_iMMsgHandler;                 // IM处理单例

    NSTimeInterval                  _backGroundTime;                // 进入后台时间(s)
    NSTimeInterval                  _foreGroundTime;                // 进入前台时间(s)

    // 切换房间
    id<AVRoomAble>                  _switchingToRoom;               // 切换房间
    id<IMHostAble>                  _currentUser;                   // 当前使用的用户
    CurrentLiveInfo                 *_liveInfo;                     // 当前直播间信息

    BOOL                            _isHost;                        // 是否主播
    NSString                        *_roomIDStr;                    // 房间ID
    BOOL                            _hasShowVagueImg;               // 是否已经显示过了模糊图片
    BOOL                            _hasOnMute;                     // 是否静音了

    UILabel                         *_lossRateSendTipLabel;         // 主播丢包率严重情况提示（一般是网络差的情况）
    NSInteger                       _enterLiveStatus;

    BOOL                            _isReEnterChatGroup;            // 主播掉线后重新连接上来后，需要重新加入聊天室，而不是创建聊天室

    UIBackgroundTaskIdentifier      _bgTaskIdentifier;              // 后台任务标识符，用于正确结束后台任务
}

@property (nonatomic, strong) id<FWShowLiveRoomAble> liveItem;      // 开启、观看直播传入的实体

@property (nonatomic, copy) NSString            *vagueImgUrl;       // 模糊背景图片url
@property (nonatomic, strong) UIImageView       *vagueImgView;      // 模糊背景图片
@property (nonatomic, assign) BOOL              isDirectCloseLive;  // 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
@property (nonatomic, strong) BGIMMsgHandler    *iMMsgHandler;      // IM处理单例
@property (nonatomic, strong) CurrentLiveInfo   *liveInfo;          // 当前直播间信息

@property (nonatomic, strong) NSString          *roomIDStr;         // 房间ID
@property (nonatomic, assign) NSInteger         liveType;           // 视频类型，对应枚举FW_LIVE_TYPE
@property (nonatomic, assign) NSInteger         sdkType;            // SDK类型
@property (nonatomic, assign) NSInteger         mickType;           // 连麦类型
@property (nonatomic, assign) BOOL              isHost;             // 是否主播
@property (nonatomic, assign) BOOL              hasVideoControl;    // 点播时，视频控制操作（是否显示播放进度条等）
@property (nonatomic, assign) NSInteger         enterChatGroupTimes;// 加入聊天组尝试次数
@property (nonatomic, assign) BOOL              hasEnterChatGroup;  // 已经加入了一次聊天组，这里不记录成功与否

@property(nonatomic, strong) NSMutableArray *modelArr;

// 创建直播传入实体
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem modelArr:(NSArray *)modelArr;

/**
 弹出退出或直接退出
 @param isDirectCloseLive 该参数针对主播、观众，表示是否直播关闭直播，而不显示结束界面
 @param isHostShowAlert 该参数针对主播，表示主播是否需要弹出"您当前正在直播，是否退出直播？"
 @param succ 成功回调
 @param failed 失败回调
 */
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

// 判断对应类型然后做对应的退出操作
- (void)realExitLive:(FWVoidBlock)succ failed:(FWErrorBlock)failed;

// 退出聊天组
- (void)exitChatGroup;

// 视频第一帧加载出来后隐藏模糊背景
- (void)hideVagueImgView;

// 释放该释放的东西
- (void)releaseAll;

@end


// 供子类重写
@interface BGLiveBaseController (ProtectedMethod)

- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;
- (void)startEnterChatGroup:(NSString *)chatGroupID succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;
- (void)enterChatGroupSucc:(CurrentLiveInfo *)liveInfo;
- (void)onServiceExitLive:(BOOL)isDirectCloseLive succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed;
- (void)checkNetWorkBeforeLive;
- (void)addNetListener;
- (void)addPhoneListener;
- (void)removePhoneListener;
- (void)onExitLiveUI;
- (void)onAppEnterForeground;
- (void)onAppEnterBackground;
- (void)phoneInterruptioning:(BOOL)interruptioning;
- (void)onAudioInterruption:(NSNotification *)notification;
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification;

@end