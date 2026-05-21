//
//  TCShowLiveBottomView.h
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//2

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

typedef NS_ENUM(NSInteger, TCShowVoiceFunctionType)
{
    EFunc_VOICE_GIFT                  = 1,        // 礼物
    EFunc_VOICE_CONNECT_MIKE          = 2,        // 连麦
    EFunc_VOICE_CHART                 = 3,        // 私信
    EFunc_VOICE_INPUT                 = 4,        // 聊天
    EFunc_VOICE_GAME                  = 30,        // 游戏
    EFunc_VOICE_MORE                  = 6,        // 游戏
    EFunc_VOICE_FACE                  = 31,        // 表情
    EFunc_VOICE_MUSIC                  = 32,        // 音乐
 
};

@class TCShowVoiceBottomView;

@protocol TCShowVoiceBottomViewDelegate <NSObject>
@optional

- (void)onBottomViewClickMenus:(TCShowLiveBottomView *)bottomView fromButton:(UIButton *)button;

@end


@protocol TCShowVoiceBottomViewMultiDelegate <NSObject>

- (void)onBottomView:(TCShowVoiceBottomView *)bottomView operateCameraOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowVoiceBottomView *)bottomView operateMicOf:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowVoiceBottomView *)bottomView switchToMain:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;
- (void)onBottomView:(TCShowVoiceBottomView *)bottomView cancelInteractWith:(id<AVMultiUserAble>)user fromButton:(UIButton *)button;

@end

@interface TCShowVoiceBottomView : BGBaseView
{
@protected
    
    id<AVMultiUserAble>     _showUser;          // 多人互动时才会用到
    
    NSMutableArray          *_showFuncs;
    CGFloat                 _lastFloatBeauty;   // 主要为界面上重新条开时一致
    
    CGRect                  _heartRect;
    
    MenuButton              *_msgMenuBtn;       // 发送消息按钮
    MenuButton              *_starShopBtn;      // 星店按钮
    MenuButton              *_gamesBtn;         // 插件中心按钮
    
    CurrentLiveInfo         *_liveInfo;
}

@property (nonatomic, weak) id<TCShowVoiceBottomViewDelegate> delegate;
@property (nonatomic, weak) id<TCShowVoiceBottomViewMultiDelegate> multiDelegate;


@property (nonatomic, assign) CGRect        heartRect;              // 点亮起始位置、大小
@property (nonatomic, copy) NSString        *heartImgViewName;      // 点亮图片名字

@property (nonatomic, assign) BOOL          isHost;                 // 是否主播
@property (nonatomic, assign) BOOL          canSendLightMsg;        // 当前是否能够发送点赞
@property (nonatomic, assign) NSInteger     lightCount;             // 点亮数量
@property (nonatomic, strong) UIView        *menusBottomView;       // 用来放菜单的视图

@property (nonatomic, strong) MenuButton    *beginGameBtn;          // 开始游戏按钮
@property (nonatomic, strong) MenuButton    *auctionBtn;            // 竞拍按钮
@property (nonatomic, strong) MenuButton    *switchGameViewBtn;     // 游戏视图开关
@property (nonatomic, strong) MenuButton    *switchBankerBtn;       // 开启上庄,下庄
@property (nonatomic, strong) MenuButton    *grabBankerBtn;         // 抢庄
@property (nonatomic, strong) MenuButton    *moreToolsBtn;          // 更多功能


@property(nonatomic, strong) MenuButton *shopBtn;//购物车按钮

@property (nonatomic, strong) JSBadgeView   *jsbadge;               // 私聊的消息角标
@property (nonatomic, strong) JSBadgeView   *bjsbadge;              // 上庄、下庄的消息角标
@property (nonatomic, assign) NSInteger     bankMessage;            // 上庄、下庄的消息数量

#if kSupportIMMsgCache
@property (nonatomic, strong) NSMutableArray    *praiseImageCache;
@property (nonatomic, strong) NSMutableArray    *praiseAnimationCache;
#endif


/**
 请求完接口后，刷新直播间相关信息
 
 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

- (void)addLiveFunc:(NSInteger)liveType;    // 视频类型，对应的枚举：FW_LIVE_TYPE

- (void)showLight;                          //显示点亮

- (void)showLikeHeart;

#if kSupportIMMsgCache
- (void)showLikeHeart:(AVIMCache *)cache;
#endif

- (void)updateShowFunc;

// 开始直播
- (void)startLive;
// 暂停直播
- (void)pauseLive;
// 重新开始直播
- (void)resumeLive;
// 结束直播
- (void)endLive;

@end
