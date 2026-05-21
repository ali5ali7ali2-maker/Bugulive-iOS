//
//  BGLiveUIViewController.h
//  BugoLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//  直播UI层

//#import "AuctionTool.h"
#import "BGConversationSegmentController.h"
#import "BGConversationServiceController.h"
#import "BGLivePayManager.h"
#import "SHomePageVC.h"
#import "TCShowLiveView.h"
#import <UIKit/UIKit.h>
#import "GameModel.h"
#import "PKUserListViewController.h"
#import "BGKSYPlayerControllerForPk.h"
#import "FPKProgress.h"
#import "FPKCountDownView.h"

#import "MGLiveWishView.h"
#import "MGShowVIPListView.h"

#import "BGSoundEffectsView.h"
//#import "TiUIView.h"
#import "BogoShopExplainView.h"
#import "BGSoundEffectModel.h"
#import "choseMuiscVC.h"
@class BGLiveUIViewController;

@protocol FWLiveUIViewControllerServeiceDelegate <NSObject>
@required

/**
 显示充值界面
 
 @param liveUIViewController self
 */
- (void)showRechargeView:(BGLiveUIViewController *)liveUIViewController;

/**
 显示音效设置界面

 */
- (void)showSoundSetView:(BGLiveUIViewController *)liveUIViewController;

/**
 显示音效设置界面

 */
- (void)shoSVipView:(BGLiveUIViewController *)liveUIViewController;

/**
 关闭当前直播
 
 @param isDirectCloseLive 是否直接关闭
 @param isHostShowAlert 主播是否弹出Alert
 */
- (void)closeCurrentLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert;
-(void)pkController:(int )type WidthData:(id)obj;


- (void)protocolDidScrollView:(BGTLiveScrollView *)scrollView isRefreshLive:(BOOL)isRefresh;

- (void)protocolGetVideoWithRoomID:(NSString *)roomID;

//点击了表情
- (void)protocolDidClickEmoji:(NSString *)emoji;
@end

@interface BGLiveUIViewController : BGBaseViewController<FWChatVCDelegate, UIGestureRecognizerDelegate,UIScrollViewDelegate, TCShowLiveViewForUIDelegate>
//,TiUIViewDelegate>
{
    __weak id<FWShowLiveRoomAble>       _liveItem;              // 开启、观看直播传入的实体
    id<FWLiveControllerAble>            _liveController;        // 当前SDK控制类
    
    BOOL                _showingRight;                          // 判断是否正在显示LivingView
    BOOL                _isFromeLeft;                           // 判断是否从左往右滑动
    BOOL                _isFromeTop;                            // 判断是否从上往下滑动
    BOOL                _isLeftOrRightPan;                      // 判断是否左右方向滑动的幅度大于上线方向
    BOOL                _isHost;                                // 是否主播
}

@property (nonatomic, weak) id<FWLiveUIViewControllerServeiceDelegate> serviceDelegate;
// 左右滑动层
@property (nonatomic, strong) TCShowLiveView *liveView;
//上下滑动
@property(nonatomic, strong) BGTLiveScrollView *liveScrollView;
// 记录 是否加载半屏幕 VC
@property (nonatomic, assign) BOOL isHaveHalfIMChatVC;
// 记录 是否加载半屏幕 VC
@property (nonatomic, assign) BOOL isHaveHalfIMMsgVC;
// 记录 是否加载半屏幕 VC 键盘类型 1文本  2表情  3更多
@property (nonatomic, assign) int isKeyboardTypeNum;
// 半屏幕 VC背景
@property (nonatomic, strong) UIView *imChatVCBgView;
// 滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;
// 付费直播的控制类
@property (nonatomic, strong) BGLivePayManager *livePay;
// 付费直播心跳返回的字典
@property (nonatomic, strong) NSDictionary              *currentMonitorDict;
// 付费直播显示看视频的倒计时的label
@property (nonatomic, strong) UILabel                   *livePayLabel;
// 付费直播倒计时的time
@property (nonatomic, strong) NSTimer                   *livePayTimer;
// 按时付费直播倒计时剩余时间的定时器
@property (nonatomic, strong) NSTimer                   *livePayLeftTimer;
// 按时付费直播倒计时剩余时间的时间
@property (nonatomic, assign) int                       livePayLeftCount;
// 付费直播的类型0按时1按场
@property (nonatomic, assign) int                       payLiveType;
// 可免费观看的时长
@property (nonatomic, assign) int                       livePayCount;
@property(nonatomic, strong)      BGKSYPlayerControllerForPk *pkView;
@property (nonatomic, strong) FPKProgress *fpkProgress;
@property (nonatomic, strong) FPKCountDownView *pkCountDownView;
//心愿单
@property(nonatomic, strong) MGLiveWishView *wishView;
//音效设置
@property(nonatomic, strong) BGSoundEffectsView *soundSetView;
//贵族中心
@property(nonatomic, strong) MGShowVIPListView *vipView;
//商品讲解
@property(nonatomic, strong) BogoShopExplainView *shopExplainView;

//2020-1-4 PK结束后
@property (nonatomic,weak) UIView *showView;
//pk对方id
@property(nonatomic, strong) NSString *otherId;
//对方主播头像地址
@property(nonatomic, strong) NSString *avatar;
@property(nonatomic,strong) NSString *myavatar;
@property(nonatomic,strong) NSString *myId;


@property(nonatomic, assign) BOOL isLianMaiing;
@property(nonatomic, assign) BOOL isVoice;

@property(nonatomic, copy) void (^playUrl)(BGSoundEffectModel *model);

/**
 初始化房间信息等
 
 @param liveItem 房间信息
 @param liveController 直播VC
 @return self
 */
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController;

/**
 请求完接口后，刷新直播间相关信息
 
 @param liveItem 视频Item
 @param liveInfo get_video2接口获取下来的数据实体
 */
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo;

/**
 进入付费直播
 
 @param responseJson get_video2接口返回的数据
 @parma closeBtn 关闭按钮
 */
- (void)beginEnterPayLive:(NSDictionary *)responseJson closeBtn:(UIButton *)closeBtn;

/**
 收到IM消息，调起付费
 
 @param type 付费类型
 @param closeBtn 关闭按钮
 */
- (void)getVedioViewWithType:(int)type closeBtn:(UIButton *)closeBtn;

/**
 心跳唤起付费界面
 
 @param responseJson 心跳接口返回数据
 */
- (void)createPayLiveView:(NSDictionary *)responseJson;

/**
 插件中心点击付费
 
 @param model Model
 */
- (void)clickPluginPayItem:(GameModel *)model closeBtn:(UIButton *)closeBtn;

/**
 显示按时付费在倒计时的页面
 */
- (void)dealLivepayTComfirm;

- (void)addTwoSubVC;
- (void)showFace;
- (void)showMusic;
// 移除滑动手势
- (void)removePanGestureRec;

// 设置当前是否能够使用滑动手势
- (void)setPanGesture:(BOOL)isEnabled;

// 开始直播
- (void)startLive;
// 暂停直播
- (void)pauseLive;
// 重新开始直播
- (void)resumeLive;
// 结束直播
- (void)endLive;

//显示pk列表
-(void)showPKlist;
-(void)hiddenPKlist;
//显示心愿view
-(void)showWishView;
//显示pkView
-(void)pkViewWith:(NSString *)uid;
-(void)pkVivewHidden;
//2020-1-4 pk结束
-(void)pkVivewEnd:(NSString *)win_user_id anddic:(NSDictionary *)dic;
-(void)pkViewUpdateData:(NSDictionary *)dic;

- (void)switchToPunish:(int)time;

- (void)receiveCanclePk;

- (void)receiveRejectPkWithMsg:(NSString *)msg;

- (void)requestUserInfo;
//隐藏对话框
- (void)ChatVCBgViewTap;

@property(nonatomic, strong) choseMuiscVC *musicVC;
@end
