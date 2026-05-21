//
//  BGLiveUIViewController.m
//  FanweLive
//
//  Created by xfg on 16/11/23.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "BGLiveUIViewController.h"
#import "BGConversationListController.h"
#import "BGTPlayControllerForPK.h"
#import "BGKSYPlayerControllerForPk.h"
#import "FPKProgress.h"
#import "PKPopView.h"
#import "WMDragView.h"

#import "MGAddWishViewController.h"

#import "BogoPkProgressModel.h"
#import "BogoShopKit.h"

// ✅ FIX: Removed duplicate #import "WMDragView.h" (was imported 3 times)

#import "RoomFaceView.h"
#import "RoomFaceModel.h"
#import "choseMuiscVC.h"

#define BEGIN_SLIDE_RATE  0.15
#define BEGIN_SLIDE_RATE2 0.3
#define DURING_TIME       10

// ✅ FIX: Named constants instead of magic numbers
static const CGFloat kPKResultDialogWidth      = 276.0;
static const CGFloat kPKResultDialogHeight     = 244.0;
static const CGFloat kPKTopImageWidth          = 179.0;
static const CGFloat kPKTopImageHeight         = 52.0;
static const CGFloat kPKCenterImageSize        = 30.0;
static const CGFloat kPKAvatarSize             = 60.0;
static const CGFloat kPKAvatarSizeSmall        = 42.0;
static const CGFloat kPKSidePanelWidth         = 145.0;
static const CGFloat kPKSidePanelHeight        = 58.0;
static const CGFloat kPKDelaySeconds           = 3;

@interface BGLiveUIViewController ()<PKUserListViewDelegate, RoomFaceViewDelegate>
{
    PKUserListViewController *pkList;
    MMAlertView *alert1;
    MMAlertView *alert2;
    MMAlertView *alert3;
    NSString    *otherId;
    CurrentLiveInfo *_liveInfo;
}

@property (nonatomic, strong) NSString            *pkID;
@property (nonatomic, strong) BogoPkProgressModel *model;
@property (nonatomic, strong) RoomFaceView        *faceView;

@end

@implementation BGLiveUIViewController

#pragma mark - ----------------------- 直播生命周期 -----------------------

- (void)releaseAll
{
    [self removePanGestureRec];

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [_imChatVCBgView removeFromSuperview];

    _liveController = nil;
    _liveItem       = nil;

    if (self.livePayTimer)
    {
        [self.livePayTimer invalidate];
        self.livePayTimer = nil;
    }
    if (self.livePayLeftTimer)
    {
        [self.livePayLeftTimer invalidate];
        self.livePayLeftTimer = nil;
    }

    // ✅ FIX: Was checking livePay.payLiveTime twice; second block now correctly
    //         checks hostPayLiveTime before invalidating it.
    if (self.livePay.payLiveTime)
    {
        [self.livePay.payLiveTime invalidate];
        self.livePay.payLiveTime = nil;
    }
    if (self.livePay.hostPayLiveTime)
    {
        [self.livePay.hostPayLiveTime invalidate];
        self.livePay.hostPayLiveTime = nil;
    }
    if (self.livePay.countDownTime)
    {
        [self.livePay.countDownTime invalidate];
        self.livePay.countDownTime = nil;
    }

    self.livePay.livController = nil;
}

- (void)dealloc
{
    [self releaseAll];
    NSLog(ASLocalizedString(@"%s释放"), __func__);

    // ✅ FIX: Was checking _fpkProgress instead of _pkCountDownView
    if (_pkCountDownView)
    {
        [_pkCountDownView stopTimer];
    }
}

#pragma mark 开始直播
- (void)startLive
{
    [self.liveView startLive];
}

#pragma mark 暂停直播
- (void)pauseLive
{
    [self.liveView pauseLive];
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    [self.liveView resumeLive];
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];

    [self.liveView endLive];
    for (UIView *tmpView in self.liveView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    [self.liveView removeFromSuperview];

    if (_soundSetView)
    {
        [_soundSetView.player pause];
        _soundSetView.player = nil;
    }
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super init])
    {
        _liveItem      = liveItem;
        _isHost        = [liveItem isHost];
        _liveController = liveController;

        self.liveView = [[TCShowLiveView alloc] initWith:liveItem liveController:liveController];
        self.liveView.uiDelegate = self;
        [self.liveView setFrameAndLayout:self.view.bounds];
        [self.view addSubview:self.liveView];

        self.liveScrollView = [BGTLiveScrollView new];
        self.liveScrollView.roomID       = [NSString stringWithFormat:@"%d", _liveItem.liveAVRoomId];
        self.liveScrollView.contentSize  = CGSizeMake(0, kScreenH * 3);
        self.liveScrollView.frame        = CGRectMake(0, 0, kScreenW, kScreenH);
        self.liveScrollView.pagingEnabled         = YES;
        self.liveScrollView.delegate              = self;
        self.liveScrollView.userInteractionEnabled = NO;
        [self.liveView addSubview:self.liveScrollView];

        self.pkID = @"";
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    _liveInfo = liveInfo;
    [self.liveView refreshLiveItem:liveItem liveInfo:liveInfo];
    [self setUpLocalizationStringForView:self.liveView.topView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(endpkview:)
                                                 name:@"endpkview"
                                               object:nil];
}

// ✅ FIX: Added viewWillDisappear to remove observer added in viewWillAppear,
//         preventing observer accumulation on every appearance.
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"endpkview"
                                                  object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self registerKeyBoardNotification];

    _panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    _panGestureRec.delegate = self;
    [self.view addGestureRecognizer:_panGestureRec];

    [GlobalVariables sharedInstance].tliveView = self.view;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showGiftView:)
                                                 name:@"showGiftView"
                                               object:nil];
}

- (void)PKUserClickItem:(UserModel *)user pk_id:(NSString *)pk_id
{
    alert3 = [FanweMessage alert:ASLocalizedString(@"提示")
                         message:ASLocalizedString(@"是否发起pk请求?")
                destructiveAction:^{
        self.pkID = pk_id;
        [self requetPkWithUser:user pk_id:pk_id];
    } cancelAction:^{
    }];
    [self hiddenPKlist];
}

- (void)requetPkWithUser:(UserModel *)user pk_id:(NSString *)pk_id
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

    if (![GlobalVariables sharedInstance].openAgora)
        [mDict setObject:@"pk_tencent" forKey:@"ctl"];
    else
        [mDict setObject:@"pk_agora" forKey:@"ctl"];

    [mDict setObject:@"request_pk"    forKey:@"act"];
    [mDict setObject:user.user_id     forKey:@"pk_emcee_id"];
    [mDict setObject:pk_id            forKey:@"pk_list_id"];

    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] == 1)
        {
            NSNumber *pk_id_num = [responseJson objectForKey:@"pk_id"];
            user.pk_id = pk_id_num.stringValue;

            if ([self.serviceDelegate respondsToSelector:@selector(pkController:WidthData:)])
                [self.serviceDelegate pkController:0 WidthData:user];

            alert1 = [FanweMessage alert:ASLocalizedString(@"提示")
                                  message:ASLocalizedString(@"申请pk中，等待对方应答..")
                              isHideTitle:NO
                         destructiveTitle:ASLocalizedString(@"取消pk")
                        destructiveAction:^{
                if ([self.serviceDelegate respondsToSelector:@selector(pkController:WidthData:)])
                    [self.serviceDelegate pkController:3 WidthData:user];
            }];
        }
        else
        {
            [FanweMessage alert:responseJson[@"msg"]];
        }

    } FailureBlock:^(NSError *error) {
    }];
}

- (void)receiveRejectPkWithMsg:(NSString *)msg
{
    [FanweMessage alertController:msg viewController:self destructiveAction:^{
    } cancelAction:nil];

    [alert1 hide];
    alert1 = nil;
}

- (void)receiveCanclePk
{
    [FanweMessage alert:ASLocalizedString(@"提示")
                message:ASLocalizedString(@"对方取消PK")
            isHideTitle:NO
       destructiveTitle:ASLocalizedString(@"确定")
      destructiveAction:nil];

    [alert1 hide];
    alert1 = nil;
    [self hiddenPKlist];
}

- (void)pkViewWith:(NSString *)uid
{
    [self hiddenPKlist];

    [alert1 hide];
    alert1 = nil;

    self.pkID = uid;

    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    if (![GlobalVariables sharedInstance].openAgora)
        [mDict setObject:@"pk_tencent" forKey:@"ctl"];
    else
        [mDict setObject:@"pk_agora"   forKey:@"ctl"];

    [mDict setObject:@"request_get_pk_info2"        forKey:@"act"];
    [mDict setObject:uid.length ? uid : @""         forKey:@"pk_id"];

    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {

        if ([responseJson toInt:@"status"] == 1 || [responseJson toInt:@"status"] == 2)
        {
            self.model = [BogoPkProgressModel mj_objectWithKeyValues:responseJson];

            if ([self.model.group_id2 isEqualToString:[NSString stringWithFormat:@"%d", [_liveItem liveAVRoomId]]])
            {
                NSArray<BogoPkProgressGiftModel *> *gift_list2 = self.model.gift_list2;
                self.model.gift_list2 = self.model.gift_list1;
                self.model.gift_list1 = gift_list2;
            }

            _fpkProgress.model = self.model;

            int timer = [responseJson toInt:@"pk_time"];
            NSLog(@"189responseJson:%@", responseJson);
            [_fpkProgress setLeftIsMe:YES];
            BOOL leftIsMe = NO;

            NSString *pk_status = [responseJson valueForKey:@"pk_status"];
            if (pk_status.integerValue == 0)
                return;

            if (!_isHost)
            {
                NSString *live1id = [NSString stringWithFormat:@"%@", [responseJson valueForKey:@"emcee_user_id1"]];
                if ([[_liveItem liveHost].imUserId isEqualToString:live1id])
                {
                    NSString *play_url2 = [responseJson valueForKey:@"play_url2"];
                    [self addPKViewWithURL:play_url2 WithViewType:1 widthTime:timer WithDic:responseJson AndIsNO1:NO status:[responseJson toInt:@"status"] pkStatus:pk_status.intValue];
                    [self swapPlayer];
                    leftIsMe = YES;
                }
                else
                {
                    NSString *play_url2 = [responseJson valueForKey:@"play_url1"];
                    [self addPKViewWithURL:play_url2 WithViewType:1 widthTime:timer WithDic:responseJson AndIsNO1:YES status:[responseJson toInt:@"status"] pkStatus:pk_status.intValue];
                }
            }
            else
            {
                NSDictionary *userInfo = @{ @"roomid": [NSString stringWithFormat:@"PK%@", [responseJson valueForKey:@"emcee_user_id1"]] };
                [[NSNotificationCenter defaultCenter] postNotificationName:@"KPKWithRoomID" object:self userInfo:userInfo];

                NSString *live1id = [NSString stringWithFormat:@"%@", [responseJson valueForKey:@"emcee_user_id1"]];
                if ([[IMAPlatform sharedInstance].host.userId isEqualToString:live1id])
                {
                    NSString *play_url2 = [responseJson valueForKey:@"play_url2"];
                    [self addPKViewWithURL:play_url2 WithViewType:1 widthTime:timer WithDic:responseJson AndIsNO1:NO status:[responseJson toInt:@"status"] pkStatus:pk_status.intValue];
                    leftIsMe = YES;
                }
                else
                {
                    NSString *play_url2 = [responseJson valueForKey:@"play_url1"];
                    [self addPKViewWithURL:play_url2 WithViewType:1 widthTime:timer WithDic:responseJson AndIsNO1:YES status:[responseJson toInt:@"status"] pkStatus:pk_status.intValue];
                    [self swapPlayer];
                }
            }

            _fpkProgress.leftIsMe = leftIsMe;
        }
        else
        {
            [[BGHUDHelper sharedInstance] tipMessage:[responseJson valueForKey:@"error"]];
        }

    } FailureBlock:^(NSError *error) {
    }];
}
- (void)swapPlayer
{
    NSDictionary *postObj = @{ @"isFull": @4 };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPKViewChange" object:nil userInfo:postObj];
}

- (void)clickChangeRoom:(UIButton *)sender
{
}

#pragma mark - 设置pk页面播放
- (void)addPKViewWithURL:(NSString *)url WithViewType:(int)type widthTime:(int)time WithDic:(NSDictionary *)dic AndIsNO1:(BOOL)isOne status:(int)status pkStatus:(int)pkStatus
{
    UIImageView *pkcenterImgv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW / 2 - 50,
                                                                               67 + kStatusBarHeight + kScreenW * 2 / 3 / 2 + 20 - 50,
                                                                               100, 100)];
    pkcenterImgv.image = [UIImage imageNamed:@"pkcenter"];
    [self.view addSubview:pkcenterImgv];

    UIImageView *pkleftImgv  = nil;
    UIImageView *pkrightImgv = nil;

    for (int i = 0; i < 2; i++)
    {
        UIImageView *pkbackImgv = [[UIImageView alloc] init];
        [self.view addSubview:pkbackImgv];

        UIImageView *pkavatarImgv = [[UIImageView alloc] init];
        [pkbackImgv addSubview:pkavatarImgv];
        pkavatarImgv.layer.cornerRadius  = kPKAvatarSizeSmall / 2;
        pkavatarImgv.layer.masksToBounds = YES;

        UILabel *namelab = [[UILabel alloc] init];
        namelab.textColor = kWhiteColor;
        namelab.font      = [UIFont systemFontOfSize:12];
        [pkbackImgv addSubview:namelab];

        UILabel *namedelab = [[UILabel alloc] init];
        namedelab.textColor = kWhiteColor;
        namedelab.font      = [UIFont systemFontOfSize:12];
        [pkbackImgv addSubview:namedelab];

        if (i == 0)
        {
            pkbackImgv.frame = CGRectMake(0,
                                          67 + kStatusBarHeight + kScreenW * 2 / 3 + 20 + 20,
                                          kPKSidePanelWidth, kPKSidePanelHeight);
            pkbackImgv.image = [UIImage imageNamed:@"我方"];
            pkleftImgv       = pkbackImgv;

            pkavatarImgv.frame = CGRectMake(15, (kPKSidePanelHeight - kPKAvatarSizeSmall) / 2, kPKAvatarSizeSmall, kPKAvatarSizeSmall);
            [pkavatarImgv sd_setImageWithURL:[NSURL URLWithString:isOne ? [dic valueForKey:@"head_image2"] : [dic valueForKey:@"head_image1"]]
                            placeholderImage:[UIImage imageNamed:@"DefaultImg"]];

            namelab.frame = CGRectMake(15 + kPKAvatarSizeSmall + 5, kPKSidePanelHeight / 2 - 20, 65, 25);
            namelab.text  = isOne ? [dic valueForKey:@"name2"] : [dic valueForKey:@"name1"];
            namelab.left  = pkavatarImgv.right + 5;

            namedelab.frame = CGRectMake(15 + kPKAvatarSizeSmall + 5, kPKSidePanelHeight / 2 + 5, kPKSidePanelWidth - 15 - kPKAvatarSizeSmall - 5, 20);
            namedelab.text  = ASLocalizedString(@"我方");
        }
        else
        {
            pkbackImgv.frame = CGRectMake(kScreenW - kPKSidePanelWidth,
                                          67 + kStatusBarHeight + kScreenW * 2 / 3 + 20 + 20,
                                          kPKSidePanelWidth, kPKSidePanelHeight);
            pkbackImgv.image = [UIImage imageNamed:@"对方"];
            pkrightImgv      = pkbackImgv;

            pkavatarImgv.frame = CGRectMake(kPKSidePanelWidth - 15 - kPKAvatarSizeSmall,
                                            (kPKSidePanelHeight - kPKAvatarSizeSmall) / 2,
                                            kPKAvatarSizeSmall, kPKAvatarSizeSmall);
            [pkavatarImgv sd_setImageWithURL:[NSURL URLWithString:isOne ? [dic valueForKey:@"head_image1"] : [dic valueForKey:@"head_image2"]]
                            placeholderImage:[UIImage imageNamed:@"DefaultImg"]];

            namelab.frame         = CGRectMake(0, kPKSidePanelHeight / 2 - 20, 65, 25);
            namelab.text          = isOne ? [dic valueForKey:@"name1"] : [dic valueForKey:@"name2"];
            namelab.textAlignment = NSTextAlignmentRight;
            namelab.right         = pkbackImgv.width - pkavatarImgv.left - 5;
            namelab.left          = 10;

            namedelab.frame         = CGRectMake(0, kPKSidePanelHeight / 2 + 5, kPKSidePanelWidth - 15 - kPKAvatarSizeSmall - 5, 20);
            namedelab.text          = ASLocalizedString(@"对方");
            namedelab.textAlignment = NSTextAlignmentRight;
        }
    }

    otherId = dic[@"emcee_user_id1"];
    if ([otherId isEqualToString:[IMAPlatform sharedInstance].host.imUserId])
        otherId = dic[@"emcee_user_id2"];

    NSMutableDictionary *postObj = [NSMutableDictionary dictionaryWithDictionary:@{ @"isFull": @0, @"playUrl": url.length ? url : @"" }];
    if (type == 1)
        postObj = [NSMutableDictionary dictionaryWithDictionary:@{ @"isFull": @3, @"playUrl": url.length ? url : @"", @"touid": otherId }];

    if (self.model)
        [postObj setObject:self.model forKey:@"model"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPKViewChange" object:nil userInfo:postObj];

    if (!_pkCountDownView)
    {
        _pkCountDownView = [[FPKCountDownView alloc] initWithFrame:CGRectMake(0, 67 + kStatusBarHeight + 10 + 20, kScreenW, 20)
                                                          liveItem:_liveItem];
        _pkCountDownView.pkid   = [NSString stringWithFormat:@"%@", dic[@"id"]];
        _pkCountDownView.pktype = @"pk";
        [self.view addSubview:_pkCountDownView];
    }

    if (pkStatus == 2)
    {
        [_fpkProgress switchToPunish:(120 + time)];
        _pkCountDownView.frame  = CGRectMake(0, 67 + kStatusBarHeight + kScreenW * 2 / 3 + 20 - 38, kScreenW, 38);
        _pkCountDownView.pktype = @"cf";
        [_pkCountDownView switchToPunish:(120 + time)];
    }
    else
    {
        _pkCountDownView.countDown = time;
    }

    if (_fpkProgress)
        _fpkProgress.room_id = _liveInfo.room_id;

    __weak typeof(self) weakSelf = self;

    // ✅ FIX: Changed int64_t literal from 3.0 (double) to 3 (integer)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kPKDelaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        pkcenterImgv.hidden = YES;
        pkleftImgv.hidden   = YES;
        pkrightImgv.hidden  = YES;

        if (!weakSelf->_fpkProgress)
        {
            weakSelf->_fpkProgress = [[FPKProgress alloc] initWithFrame:CGRectMake(0,
                                                                                    kStatusBarHeight + 53 + kScreenW * 2.4 / 3,
                                                                                    kScreenW,
                                                                                    kRealValue(20 + 36))];
            [weakSelf.view addSubview:weakSelf->_fpkProgress];
            [weakSelf.view insertSubview:weakSelf->_fpkProgress belowSubview:weakSelf->_liveView];
        }

        weakSelf->_fpkProgress.leftValue  = 0;
        weakSelf->_fpkProgress.rightValue = 0;
        weakSelf->_fpkProgress.avatar     = isOne ? [dic valueForKey:@"head_image1"] : [dic valueForKey:@"head_image2"];
        weakSelf->_fpkProgress.otherId    = isOne ? [dic valueForKey:@"group_id1"]   : [dic valueForKey:@"group_id2"];

        weakSelf->_myavatar = isOne ? [dic valueForKey:@"head_image2"] : [dic valueForKey:@"head_image1"];
        weakSelf->_myId     = isOne ? [dic valueForKey:@"name2"]       : [dic valueForKey:@"name1"];
        weakSelf->_avatar   = isOne ? [dic valueForKey:@"head_image1"] : [dic valueForKey:@"head_image2"];
        weakSelf->_otherId  = isOne ? [dic valueForKey:@"name1"]       : [dic valueForKey:@"name2"];

        if ([[dic allKeys] containsObject:@"pk_ticket1"])
        {
            if ([dic[@"emcee_user_id1"] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] ||
                [weakSelf->_liveInfo.user_id isEqualToString:dic[@"emcee_user_id1"]])
            {
                weakSelf->_fpkProgress.leftValue  = [[dic valueForKey:@"pk_ticket1"] intValue];
                weakSelf->_fpkProgress.rightValue = [[dic valueForKey:@"pk_ticket2"] intValue];
            }
            else
            {
                weakSelf->_fpkProgress.leftValue  = [[dic valueForKey:@"pk_ticket2"] intValue];
                weakSelf->_fpkProgress.rightValue = [[dic valueForKey:@"pk_ticket1"] intValue];
            }

            if ([dic[@"pk_status"] integerValue] == 2)
                [weakSelf->_fpkProgress showPublishView];
        }

        if ([weakSelf.model.group_id2 isEqualToString:[NSString stringWithFormat:@"%d", [weakSelf->_liveItem liveAVRoomId]]])
        {
            NSArray<BogoPkProgressGiftModel *> *gift_list2 = weakSelf.model.gift_list2;
            weakSelf.model.gift_list2 = weakSelf.model.gift_list1;
            weakSelf.model.gift_list1 = gift_list2;
        }

        weakSelf->_fpkProgress.room_id = weakSelf->_liveInfo.room_id;
        weakSelf->_fpkProgress.model   = weakSelf.model;
    });
}

- (void)pkViewUpdateData:(NSDictionary *)dic
{
    if ([dic[@"emcee_user_id1"] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] ||
        [_liveInfo.user_id isEqualToString:dic[@"emcee_user_id1"]])
    {
        _fpkProgress.leftValue  = [[dic valueForKey:@"pk_ticket1"] intValue];
        _fpkProgress.rightValue = [[dic valueForKey:@"pk_ticket2"] intValue];
    }
    else
    {
        _fpkProgress.leftValue  = [[dic valueForKey:@"pk_ticket2"] intValue];
        _fpkProgress.rightValue = [[dic valueForKey:@"pk_ticket1"] intValue];
    }
    [self getPKInfoWithPKID:self.pkID];
}

- (void)getPKInfoWithPKID:(NSString *)pk_ID
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];

    if (![GlobalVariables sharedInstance].openAgora)
        [mDict setObject:@"pk_tencent" forKey:@"ctl"];
    else
        [mDict setObject:@"pk_agora"   forKey:@"ctl"];

    [mDict setObject:@"request_get_pk_info2"            forKey:@"act"];
    [mDict setObject:pk_ID.length ? pk_ID : @""         forKey:@"pk_id"];

    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1 || [responseJson toInt:@"status"] == 2)
        {
            self.model            = [BogoPkProgressModel mj_objectWithKeyValues:responseJson];
            _fpkProgress.room_id  = _liveInfo.room_id;
            _fpkProgress.model    = self.model;
        }
    } FailureBlock:^(NSError *error) {
    }];
}

// ✅ FIX: endpkview: now calls pkVivewHidden instead of being empty
- (void)endpkview:(NSNotification *)noti
{
    [self pkVivewHidden];
}

// ✅ FIX: Added semicolon that was missing after NSLog call
- (void)showGiftView:(NSNotification *)noti
{
    NSLog(@"点击的用户ID  %@", noti.userInfo[@"uid"]);
    [_liveView showGiftView:noti.userInfo[@"uid"]];
}

- (void)pkVivewEnd:(NSString *)win_user_id anddic:(NSDictionary *)dic
{
    NSString *_leftValue  = @"0";
    NSString *_rightValue = @"0";

    if (dic.count != 0)
    {
        NSLog(@"%@", win_user_id);
        NSLog(@"%@", [IMAPlatform sharedInstance].host.imUserId);

        if ([dic[@"emcee_user_id1"] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] ||
            [_liveInfo.user_id isEqualToString:dic[@"emcee_user_id1"]])
        {
            _leftValue  = [dic valueForKey:@"pk_ticket1"];
            _rightValue = [dic valueForKey:@"pk_ticket2"];
        }
        else
        {
            _leftValue  = [dic valueForKey:@"pk_ticket2"];
            _rightValue = [dic valueForKey:@"pk_ticket1"];
        }
    }

    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenHeight)];
    showView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.6];
    [self.view addSubview:showView];
    self.showView = showView;
    [self.view bringSubviewToFront:showView];

    UIImageView *backImgv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW / 2 - kPKResultDialogWidth / 2,
                                                                           kScreenHeight / 2 - 122,
                                                                           kPKResultDialogWidth,
                                                                           kPKResultDialogHeight)];
    backImgv.image = [UIImage imageNamed:@"弹窗背景"];
    [showView addSubview:backImgv];

    UIImageView *topImgv = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW / 2 - kPKTopImageWidth / 2,
                                                                          kScreenHeight / 2 - kPKResultDialogHeight / 2 - kPKTopImageHeight / 2,
                                                                          kPKTopImageWidth,
                                                                          kPKTopImageHeight)];
    topImgv.image = [UIImage imageNamed:@"PK结束"];
    [showView addSubview:topImgv];

    showView.userInteractionEnabled  = YES;
    backImgv.userInteractionEnabled  = YES;

    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(backImgv.width - 30, 10, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"pk关闭"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushToCancleClick) forControlEvents:UIControlEventTouchUpInside];
    [backImgv addSubview:btn];

    UIImageView *centerImgv = [[UIImageView alloc] initWithFrame:CGRectMake(backImgv.width / 2 - kPKCenterImageSize / 2,
                                                                             kPKTopImageHeight / 2 + 15 + 30 - 17 / 2,
                                                                             kPKCenterImageSize, 17)];
    centerImgv.image = [UIImage imageNamed:@"PK后"];
    [backImgv addSubview:centerImgv];

    for (int i = 0; i < 2; i++)
    {
        UIImageView *pkavatarImgv = [[UIImageView alloc] init];
        [backImgv addSubview:pkavatarImgv];
        pkavatarImgv.layer.cornerRadius  = kPKAvatarSize / 2;
        pkavatarImgv.layer.masksToBounds = YES;

        UILabel *namelab = [[UILabel alloc] init];
        namelab.textColor     = RGB(102, 102, 102);
        namelab.textAlignment = NSTextAlignmentCenter;
        namelab.font          = [UIFont systemFontOfSize:13];
        [backImgv addSubview:namelab];

        UIImageView *footImgv = [[UIImageView alloc] init];
        [backImgv addSubview:footImgv];

        UILabel *numlab = [[UILabel alloc] init];
        numlab.backgroundColor = RGB(245, 245, 245);
        numlab.textColor       = RGB(148, 143, 255);
        numlab.textAlignment   = NSTextAlignmentCenter;
        numlab.font            = [UIFont systemFontOfSize:13];
        numlab.layer.cornerRadius  = 3;
        numlab.layer.masksToBounds = YES;
        [backImgv addSubview:numlab];

        if (i == 0)
        {
            pkavatarImgv.frame = CGRectMake(backImgv.width / 2 / 2 - 30, kPKTopImageHeight / 2 + 15, kPKAvatarSize, kPKAvatarSize);
            [pkavatarImgv sd_setImageWithURL:[NSURL URLWithString:_myavatar]
                            placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];
            namelab.frame = CGRectMake(0, kPKTopImageHeight / 2 + 15 + 65, backImgv.width / 2, 15);
            namelab.text  = _myId;

            if (_leftValue.intValue > _rightValue.intValue)
            {
                footImgv.frame = CGRectMake(backImgv.width / 2 / 2 - 91 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20, 91, 48);
                footImgv.image = [UIImage imageNamed:@"胜利"];
            }
            else if (_leftValue.intValue < _rightValue.intValue)
            {
                footImgv.frame = CGRectMake(backImgv.width / 2 / 2 - 78 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20 + 2.5, 78, 43);
                footImgv.image = [UIImage imageNamed:@"成功"];
            }
            else
            {
                footImgv.frame = CGRectMake(backImgv.width / 2 / 2 - 56 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20 - (56 - 48) / 2, 56, 56);
                footImgv.image = [UIImage imageNamed:@"平局"];
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
                lab.font          = [UIFont boldSystemFontOfSize:12];
                lab.text          = ASLocalizedString(@"平局");
                lab.textColor     = kWhiteColor;
                lab.textAlignment = NSTextAlignmentCenter;
                [footImgv addSubview:lab];
            }

            numlab.frame = CGRectMake(backImgv.width / 2 / 2 - 83 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20 + 50, 83, 25);
            numlab.text  = [NSString stringWithFormat:@"%@", _leftValue];
        }
        else
        {
            pkavatarImgv.frame = CGRectMake(backImgv.width / 2 + backImgv.width / 2 / 2 - 30, kPKTopImageHeight / 2 + 15, kPKAvatarSize, kPKAvatarSize);
            [pkavatarImgv sd_setImageWithURL:[NSURL URLWithString:_avatar]
                            placeholderImage:[UIImage imageNamed:@"com_preload_head_img"]];
            namelab.frame = CGRectMake(backImgv.width / 2, kPKTopImageHeight / 2 + 15 + 65, backImgv.width / 2, 15);
            namelab.text  = _otherId;

            if (_leftValue.intValue > _rightValue.intValue)
            {
                footImgv.frame = CGRectMake(backImgv.width / 2 + backImgv.width / 2 / 2 - 78 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20 + 2.5, 78, 43);
                footImgv.image = [UIImage imageNamed:@"成功"];
            }
            else if (_leftValue.intValue < _rightValue.intValue)
            {
                footImgv.frame = CGRectMake(backImgv.width / 2 + backImgv.width / 2 / 2 - 91 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20, 91, 48);
                footImgv.image = [UIImage imageNamed:@"胜利"];
            }
            else
            {
                footImgv.frame = CGRectMake(backImgv.width / 2 + backImgv.width / 2 / 2 - 56 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20 - (56 - 48) / 2, 56, 56);
                footImgv.image = [UIImage imageNamed:@"平局"];
                UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 56, 56)];
                lab.font          = [UIFont boldSystemFontOfSize:12];
                lab.text          = ASLocalizedString(@"平局");
                lab.textColor     = kWhiteColor;
                lab.textAlignment = NSTextAlignmentCenter;
                [footImgv addSubview:lab];
            }

            numlab.frame = CGRectMake(backImgv.width / 2 + backImgv.width / 2 / 2 - 83 / 2, kPKTopImageHeight / 2 + 15 + 65 + 20 + 50, 83, 25);
            numlab.text  = [NSString stringWithFormat:@"%@", _rightValue];
        }
    }
}

- (void)pushToCancleClick
{
    [_showView removeFromSuperview];
    [_showView removeAllSubViews];
    _showView = nil;
}

- (void)switchToPunish:(int)time
{
    [_fpkProgress switchToPunish:time];
    _pkCountDownView.frame  = CGRectMake(0, 67 + kStatusBarHeight + kScreenW * 2 / 3 + 20 - 38, kScreenW, 38);
    _pkCountDownView.pktype = @"cf";
    [_pkCountDownView switchToPunish:time];
}

- (void)pkVivewHidden
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    if (![GlobalVariables sharedInstance].openAgora)
        [dict setObject:@"pk_tencent" forKey:@"ctl"];
    else
        [dict setObject:@"pk_agora"   forKey:@"ctl"];

    [dict setValue:@"request_end_pk" forKey:@"act"];

    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
            NSLog(ASLocalizedString(@"结束PK请求成功responseJson:%@"), responseJson);
        else
            NSLog(ASLocalizedString(@"结束PK请求失败responseJson:%@"), responseJson);
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"结束PK请求失败error:%@"), error);
    }];

    [_pkView stopPlay];
    [_pkView.view removeFromSuperview];
    [_pkView removeFromParentViewController];
    _pkView = nil;

    [_pkCountDownView stopTimer];
    [_pkCountDownView removeFromSuperview];
    _pkCountDownView = nil;

    NSDictionary *postObj = @{ @"isFull": @1 };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"onPKViewChange" object:nil userInfo:postObj];

    NSArray *views = [_fpkProgress subviews];
    for (UIView *v in views)
        [v removeFromSuperview];

    [_fpkProgress setLeftValue:0];
    [_fpkProgress setRightValue:0];
    [_fpkProgress removeFromSuperview];
    _fpkProgress = nil;
}

- (void)hiddenPKlist
{
    pkList.view.hidden = YES;
    pkList = nil;
}

- (void)showPKlist
{
    if (_fpkProgress)
    {
        PKPopView *popView = [[PKPopView alloc] initWithType:PKPopViewTypeDetail];
        popView.frame = CGRectMake(0, kScreenH, kScreenW, 250);
        [popView setOtherId:otherId];
        [popView setClickEndPkBtnBlock:^{
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

            if (![GlobalVariables sharedInstance].openAgora)
                [dict setObject:@"pk_tencent" forKey:@"ctl"];
            else
                [dict setObject:@"pk_agora"   forKey:@"ctl"];

            [dict setValue:@"request_end_pk" forKey:@"act"];
            [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
                if ([responseJson toInt:@"status"] == 1)
                    NSLog(ASLocalizedString(@"结束PK请求成功responseJson:%@"), responseJson);
                else
                    NSLog(ASLocalizedString(@"结束PK请求失败responseJson:%@"), responseJson);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"endPunish" object:nil];
            } FailureBlock:^(NSError *error) {
                NSLog(ASLocalizedString(@"结束PK请求失败error:%@"), error);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"endPunish" object:nil];
            }];
        }];
        [popView show:self.view];
    }
    else
    {
        if (pkList == nil)
        {
            pkList          = [[PKUserListViewController alloc] init];
            pkList.pDelegate = self;
            [self addChildViewController:pkList];
            pkList.view.frame = CGRectMake(0, kScreenH / 2, kScreenW, kScreenH / 2);
            [self.view addSubview:pkList.view];
        }
        pkList.view.hidden = NO;
        [pkList reloadData];
    }
}

- (void)closeUserListView
{
    [self hiddenPKlist];
}

- (void)showWishView
{
    if (!_wishView)
    {
        _wishView        = [[MGLiveWishView alloc] initWithFrame:CGRectMake(0, kScreenH / 2, kScreenW, kScreenH / 2)];
        _wishView.roomId = [NSString stringWithFormat:@"%d", [_liveItem liveAVRoomId]];

        __weak typeof(self) weakSelf = self;

        // ✅ FIX: Using weakSelf->_liveItem instead of bare _liveItem to avoid retain cycle
        _wishView.clickLiveWishBlock = ^(MGADD_WISH wishType) {
            MGAddWishViewController *vc = [[MGAddWishViewController alloc] initWithWishType:wishType];
            vc.roomId = [NSString stringWithFormat:@"%d", [weakSelf->_liveItem liveAVRoomId]];
            vc.clickGiftCellBlcok = ^(MGLiveWishModel *_Nonnull wishModel) {
                wishModel.id = @"";
                [weakSelf.wishView.listArr addObject:wishModel];
                [weakSelf.wishView.tableView reloadData];
                NSLog(@"%@", weakSelf.wishView.listArr);
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };

        _wishView.clickHideLiveWishBlock = ^{
            [weakSelf.liveView.livewWishView requestModel:[NSString stringWithFormat:@"%d", [weakSelf->_liveItem liveAVRoomId]]];
        };
    }
    [_wishView show:self.view];
}

- (void)showSoundView
{
    __weak typeof(self) weakSelf = self;
    if (!_soundSetView)
    {
        _soundSetView = [[BGSoundEffectsView alloc] initWithFrame:CGRectMake(0, kScreenH / 2, kScreenW, kScreenH / 2)];
        _soundSetView.playUrl = ^(BGSoundEffectModel *model) {
            if (weakSelf.playUrl)
                weakSelf.playUrl(model);
        };
    }
    [_soundSetView show:self.view];
}

- (void)showSoundSetView:(TCShowLiveView *)showLiveView
{
    [self showSoundView];
}

- (void)showVipView:(TCShowLiveView *)showLiveView
{
    if (!_vipView)
        _vipView = [[MGShowVIPListView alloc] initWithFrame:CGRectMake(0, kScreenH / 2, kScreenW, kScreenH * 0.6)];
    [_vipView show:self.view withRoomID:[NSString stringWithFormat:@"%d", [_liveItem liveAVRoomId]]];
}

- (void)addValue
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _fpkProgress.leftValue += 5;
        [self addValue];
    });
}

#pragma mark - ----------------------- 付费相关UI -----------------------

- (void)beginEnterPayLive:(NSDictionary *)responseJson closeBtn:(UIButton *)closeBtn
{
    if (!_isHost && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        if (!self.livePay)
        {
            self.livePay = [[BGLivePayManager alloc] initWithController:self
                                                            andLiveView:self.liveView
                                                              andRoomId:[_liveItem liveAVRoomId]
                                                        andAudienceDict:responseJson
                                                              andButton:closeBtn];
            if ([responseJson toInt:@"is_live_pay"] == 1)
            {
                if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE || [_liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
                {
                    if ([responseJson toString:@"preview_play_url"] && ![[responseJson toString:@"preview_play_url"] isEqualToString:@""])
                    {
                        [_liveController startLiveRtmp:[responseJson toString:@"preview_play_url"]];
                        self.livePay.shadowView.backgroundColor = kClearColor;
                        [_liveController setSDKMute:NO];

                        if ([responseJson toInt:@"is_only_play_voice"] == 1)
                        {
                            [self.livePayTimer invalidate];
                            self.livePayTimer = nil;
                            [self.livePayLabel removeFromSuperview];
                            self.livePayLabel = nil;
                            [self.livePay creatShadowView];
                            self.livePay.shadowView.hidden = NO;
                            [self.view bringSubviewToFront:self.livePay.shadowView];
                        }
                    }
                    else
                    {
                        self.livePay.shadowView.backgroundColor = kLightGrayColor;
                        self.livePay.shadowView.hidden = NO;
                    }

                    self.livePayCount = [responseJson toInt:@"countdown"];
                    if (self.livePayCount)
                    {
                        self.livePayTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                             target:self
                                                                           selector:@selector(livePayTimeGo)
                                                                           userInfo:nil
                                                                            repeats:YES];
                        [[NSRunLoop currentRunLoop] addTimer:self.livePayTimer forMode:NSRunLoopCommonModes];
                    }

                    if ([responseJson toInt:@"is_pay_over"] == 0)
                    {
                        self.livePayLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, kScreenW - 20, 90)];
                        self.livePayLabel.textAlignment = NSTextAlignmentCenter;
                        self.livePayLabel.font          = [UIFont systemFontOfSize:16];
                        self.livePayLabel.textColor      = kWhiteColor;
                        self.livePayLabel.numberOfLines  = 0;
                        self.livePayLabel.backgroundColor = kClearColor;

                        if ([responseJson toInt:@"live_pay_type"] == 1)
                        {
                            self.payLiveType       = 1;
                            self.livePayLabel.text = [NSString stringWithFormat:ASLocalizedString(@"该直播按场收费,您还能预览倒计时%d秒"), self.livePayCount];
                        }
                        else
                        {
                            self.payLiveType       = 0;
                            self.livePayLabel.text = [NSString stringWithFormat:ASLocalizedString(@"1分钟内重复进入,不重复扣费,请能正常预览视频后,点击进入,以免扣费后不能正常进入,您还能预览倒计时%d秒"), self.livePayCount];
                        }
                        [self.view addSubview:self.livePayLabel];
                    }
                    [self.view bringSubviewToFront:closeBtn];
                }

                if ([responseJson toInt:@"live_pay_type"] == 1)
                    self.livePay.liveType = 40;

                if ([responseJson toInt:@"is_pay_over"] == 0)
                {
                    self.livePay.audienceLeftPView.hidden = YES;
                    self.livePay.is_agree = NO;
                }
                else
                {
                    self.livePay.is_agree = YES;
                }

                [self.livePay enterMoneyMode];
                [self changePayView:self.liveView];
            }

            FWWeakify(self)
            [self.livePay setBlock:^(NSString *string) {
                FWStrongify(self)
                if ([string isEqualToString:@"1"])
                    [self chargerMoney];
                else if ([string isEqualToString:@"2"])
                    [self closeLiveController];
            }];
        }
        [self changePayViewFrame:self.liveView];
    }
    else
    {
        if ([responseJson toInt:@"is_live_pay"] == 1 && [_liveItem liveType] != FW_LIVE_TYPE_RELIVE)
        {
            if (!self.livePay)
                self.livePay = [[BGLivePayManager alloc] initWithLiveView:self.liveView
                                                                andRoomId:[_liveItem liveAVRoomId]
                                                              andhostDict:responseJson
                                                              andpayType:[_liveItem liveType]];
            [self.livePay hostEnterLiveAgainWithMDict:responseJson];
        }
    }
}

- (void)createPayLiveView:(NSDictionary *)responseJson
{
    self.currentMonitorDict = responseJson;
    [self.livePay creatViewWithDict:responseJson];
}

- (void)getVedioViewWithType:(int)type closeBtn:(UIButton *)closeBtn
{
    if (!self.livePay)
    {
        self.livePay = [[BGLivePayManager alloc] initWithController:self
                                                        andLiveView:self.liveView
                                                          andRoomId:[_liveItem liveAVRoomId]
                                                    andAudienceDict:self.currentMonitorDict
                                                          andButton:closeBtn];
        FWWeakify(self)
        [self.livePay setBlock:^(NSString *string) {
            FWStrongify(self)
            if ([string isEqualToString:@"1"])
                [self chargerMoney];
            else if ([string isEqualToString:@"2"])
                [self closeLiveController];
        }];
    }
    [self.livePay AudienceGetVedioViewWithType:type];
    [self changePayViewFrame:self.liveView];
}

- (void)clickPluginPayItem:(GameModel *)model closeBtn:(UIButton *)closeBtn
{
    if ([model.class_name isEqualToString:@"live_pay"])
    {
        if ([model.is_active isEqualToString:@"0"])
        {
            SUS_WINDOW.isShowLivePay = YES;
            if (!self.livePay)
            {
                self.livePay = [[BGLivePayManager alloc] initWithLiveView:self.liveView
                                                                andRoomId:[_liveItem liveAVRoomId]
                                                              andhostDict:self.currentMonitorDict
                                                              andpayType:[_liveItem liveType]];
                if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_live_pay"] != 1)
                    [FanweMessage alert:ASLocalizedString(@"直播间人数未达到收费人数")];
                else
                {
                    self.livePay.buttomFunctionType = self.livePay.liveType = [_liveItem liveType];
                    [self.livePay creatPriceViewWithCount:1];
                }
            }
            else
            {
                self.livePay.buttomFunctionType = self.livePay.liveType = [_liveItem liveType];
                [self.livePay creatViewWithDict:self.currentMonitorDict];
                if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_live_pay"] != 1)
                    [FanweMessage alert:ASLocalizedString(@"直播间人数未达到收费人数")];
                else
                    [self.livePay creatPriceViewWithCount:1];
            }
        }
        else
        {
            [FanweMessage alert:ASLocalizedString(@"直播间已处于收费模式中")];
        }
        [self changePayView:self.liveView];
        [self changePayViewFrame:self.liveView];
    }
    else if ([model.class_name isEqualToString:@"live_pay_scene"])
    {
        if ([model.is_active isEqualToString:@"0"])
        {
            if (!self.livePay)
            {
                self.livePay = [[BGLivePayManager alloc] initWithLiveView:self.liveView
                                                                andRoomId:[_liveItem liveAVRoomId]
                                                              andhostDict:self.currentMonitorDict
                                                              andpayType:[_liveItem liveType]];
                self.livePay.liveType = 40;
                [self.livePay creatPriceViewWithCount:3];
            }
            else
            {
                self.livePay.liveType = 40;
                [self.livePay creatPriceViewWithCount:3];
            }
        }
        else
        {
            [FanweMessage alert:ASLocalizedString(@"直播间已处于收费模式中")];
        }
        [self changePayViewFrame:self.liveView];
    }
}

- (void)livePayTimeGo
{
    self.livePayCount--;
    if (self.livePayCount == 0)
    {
        [self.livePayLabel removeFromSuperview];
        self.livePayLabel = nil;
        [self.livePayTimer invalidate];
        self.livePayTimer = nil;
        [_liveController stopLiveRtmp];
        [_liveController setSDKMute:YES];
    }

    if (self.payLiveType == FW_LIVE_TYPE_RELIVE)
        self.livePayLabel.text = [NSString stringWithFormat:ASLocalizedString(@"该直播按场收费,您还能预览倒计时%d秒"), self.livePayCount];
    else
        self.livePayLabel.text = [NSString stringWithFormat:ASLocalizedString(@"1分钟内重复进入,不重复扣费,请能正常预览视频后,点击进入,以免扣费后不能正常进入,您还能预览倒计时%d秒"), self.livePayCount];
}

- (void)chargerMoney
{
}

- (void)closeLiveController
{
    BOOL isDirectCloseLive = !_isHost;
    DebugLog(@"=================：付费直播关闭直播间的操作");

    if (_serviceDelegate && [_serviceDelegate respondsToSelector:@selector(closeCurrentLive:isHostShowAlert:)])
        [_serviceDelegate closeCurrentLive:isDirectCloseLive isHostShowAlert:NO];
}

- (void)clickChangePay:(TCShowLiveView *)showLiveView
{
    if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_live_pay"] == 1)
        [self.livePay creatPriceViewWithCount:1];
    else
        [FanweMessage alert:ASLocalizedString(@"直播间人数未达到收费人数")];
}

- (void)clickMention:(TCShowLiveView *)showLiveView
{
    if ([[self.currentMonitorDict objectForKey:@"live"] toInt:@"allow_mention"] == 1)
        [self.livePay creatPriceViewWithCount:2];
}

- (void)changePayView:(TCShowLiveView *)showLiveView
{
    [self.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView andBankerView:showLiveView.gameBankerView];
}

- (void)changePayViewFrame:(TCShowLiveView *)showLiveView
{
    [self.livePay changeLeftViewFrameWithIsHost:_isHost andAuctionView:showLiveView.topView.priceView andBankerView:showLiveView.gameBankerView];
}

- (void)dealLivepayTComfirm
{
    self.livePay.audienceLeftPView.hidden = NO;
    [self.livePayTimer invalidate];
    self.livePayTimer = nil;
    [self.livePayLabel removeFromSuperview];
    self.livePayLabel = nil;
}

#pragma mark - ----------------------- 键盘事件 -----------------------

- (void)registerKeyBoardNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    FWWeakify(self)
    [Noti_Default addObserverForName:UIKeyboardDidChangeFrameNotification
                              object:nil
                               queue:[NSOperationQueue mainQueue]
                          usingBlock:^(NSNotification *_Nonnull note) {
        FWStrongify(self)
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;

        if (self.isKeyboardTypeNum == 1 && self.isHaveHalfIMMsgVC)
        {
            for (UIViewController *one_VC in self.childViewControllers)
            {
                if ([one_VC isKindOfClass:[BGConversationServiceController class]])
                {
                    BGConversationServiceController *im_Msg_VC = (BGConversationServiceController *)one_VC;
                    [UIView animateWithDuration:0.25 animations:^{
                        im_Msg_VC.view.y = kScreenH / 2 - keyboardH;
                    } completion:nil];
                }
            }
        }
    }];
}

- (void)onKeyboardWillShow:(NSNotification *)notification
{
    CGFloat animationDuration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect  keyboardF         = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH         = keyboardF.size.height;

    FWWeakify(self)
    [UIView animateWithDuration:animationDuration animations:^{
        FWStrongify(self)
        if (self.isHaveHalfIMChatVC == NO)
        {
            if (self.liveView.goldFlowerView && self.liveView.goldViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardH + self.liveView.goldFlowerViewHeiht);
                self.liveView.msgView.transform       = CGAffineTransformMakeTranslation(0, -keyboardH + self.liveView.goldFlowerViewHeiht);
            }
            else if (self.liveView.guessSizeView && self.liveView.guessSizeViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardH + kGuessSizeViewHeight);
                self.liveView.msgView.transform       = CGAffineTransformMakeTranslation(0, -keyboardH + kGuessSizeViewHeight);
            }
            else if ((self.liveView.goldFlowerView || self.liveView.guessSizeView) && self.liveView.bankerViewCanSee == YES)
            {
                // banker view active — no transform needed
            }
            else
            {
                [UIView animateWithDuration:animationDuration animations:^{
                    self.liveView.liveInputView.top = kScreenH - keyboardH - self.liveView.liveInputView.height;
                }];
            }
        }
    }];
}

- (void)textKeyboardUp:(CGFloat)move_high
{
    for (UIViewController *vc in self.childViewControllers)
    {
        if ([vc isKindOfClass:[BGConversationServiceController class]])
        {
            BGConversationServiceController *im_Msg_VC = (BGConversationServiceController *)vc;

            FWWeakify(self)
            __weak BGConversationServiceController *imMsgVC = im_Msg_VC;
            _isKeyboardTypeNum = 1;

            CGFloat time = 0.0;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (move_high < 100) return;

                [UIView animateWithDuration:0.4 animations:^{
                    imMsgVC.view.y = kScreenH / 2 - move_high;
                } completion:^(BOOL finished) {
                    FWStrongify(self)
                    if (finished)
                    {
                        imMsgVC.view.height    = kScreenH / 2;
                        imMsgVC.view.y         = kScreenH / 2 - move_high;
                        imMsgVC.inputView.hidden = YES;
                        self.isKeyboardTypeNum = 1;
                    }
                }];
            });
        }
    }
}

- (void)onKeyboardDidShow:(NSNotification *)notification
{
}

- (void)onKeyboardWillHide:(NSNotification *)notification
{
    self.liveView.bottomView.hidden = NO;
    [self.liveView hideInputView];

    CGFloat duration  = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect  keyboardF = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = keyboardF.size.height;

    FWWeakify(self)
    [UIView animateWithDuration:duration animations:^{
        FWStrongify(self)
        if (_isHaveHalfIMMsgVC == YES)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"HalfIMMsgChaVC"
                                                                object:nil
                                                              userInfo:@{ @"keyboardH": [NSString stringWithFormat:@"%f", keyboardH] }];
            return;
        }
        if (self.isHaveHalfIMChatVC == NO)
        {
            if (self.liveView.goldFlowerView && self.liveView.goldViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformIdentity;
                self.liveView.msgView.transform       = CGAffineTransformIdentity;
                self.liveView.transform               = CGAffineTransformIdentity;
            }
            else if (self.liveView.guessSizeView && self.liveView.guessSizeViewCanNotSee == NO && self.liveView.bankerViewCanSee == NO)
            {
                self.liveView.liveInputView.transform = CGAffineTransformIdentity;
                self.liveView.msgView.transform       = CGAffineTransformIdentity;
                self.liveView.transform               = CGAffineTransformIdentity;
            }
            else if ((self.liveView.goldFlowerView || self.liveView.guessSizeView) && self.liveView.bankerViewCanSee == YES)
            {
                // banker view active — no reset needed
            }
            else
            {
                [UIView animateWithDuration:duration animations:^{
                    self.liveView.liveInputView.top = kScreenH;
                }];
            }
            [self.liveView relayoutFrameOfSubViews];
        }
    }];
}

- (void)faceAndMoreKeyboardBtnClickWith:(BOOL)isFace isNotHaveBothKeyboard:(BOOL)isHave keyBoardHeight:(CGFloat)height
{
    for (UIViewController *vc in self.childViewControllers)
    {
        if ([vc isKindOfClass:[BGConversationServiceController class]])
        {
            BGConversationServiceController *imMsg_VC = (BGConversationServiceController *)vc;
            [UIView animateWithDuration:0.2 animations:^{
                if (isHave == YES)
                {
                    imMsg_VC.view.y      = kScreenH / 2 - 300;
                    imMsg_VC.view.height = kScreenH - (kScreenH * 0.5 - 300) - height;
                }
                else if (isFace == YES)
                {
                    imMsg_VC.view.y      = kScreenH / 2 - 300;
                    imMsg_VC.view.height = kScreenH - (kScreenH * 0.5 - 300);
                }
                else if (isHave == NO && isFace == NO)
                {
                    imMsg_VC.view.y      = kScreenH / 2;
                    imMsg_VC.view.height = kScreenH / 2;
                }
                else
                {
                    imMsg_VC.view.y = kScreenH / 2;
                }
            } completion:nil];
        }
    }
}

#pragma mark - ----------------------- 弹出 半屏幕VC 部分 -----------------------

- (void)addTwoSubVC
{
    if (!_imChatVCBgView)
    {
        _imChatVCBgView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _imChatVCBgView.backgroundColor = [UIColor clearColor];
        [self.liveView addSubview:_imChatVCBgView];
        UITapGestureRecognizer *IMChatVCTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ChatVCBgViewTap)];
        [_imChatVCBgView addGestureRecognizer:IMChatVCTap];
    }
    else
    {
        _imChatVCBgView.hidden = NO;
    }

    if (self.isHaveHalfIMChatVC == YES) return;

    BGConversationSegmentController *imChat_VC = [BGConversationSegmentController createIMChatVCWithHalf:self isRelive:NO];
    _isKeyboardTypeNum        = 0;
    self.isHaveHalfIMChatVC   = YES;

    __weak typeof(self) weak_Self = self;
    __weak BGConversationSegmentController *weak_chat_VC = imChat_VC;

    weak_chat_VC.goNextVCBlock = ^(int tag, SFriendObj *friend_Obj) {
        if (tag == 1)
            [weak_Self chatVCBackToLiveVC:weak_chat_VC];
        else
        {
            if (weak_Self.isHaveHalfIMMsgVC == YES) return;
            [weak_Self chatVCGoIMMsgVC:weak_chat_VC withFrinend:friend_Obj];
        }
    };
}

- (void)chatVCBackToLiveVC:(BGConversationSegmentController *)chat_VC
{
    [UIView animateWithDuration:kHalfVCViewanimation animations:^{
        chat_VC.view.y = kScreenH;
    } completion:^(BOOL finished) {
        [chat_VC.view removeFromSuperview];
        [self removeChild:chat_VC];
        self.isHaveHalfIMChatVC = NO;
        self.isHaveHalfIMMsgVC  = NO;
    }];
}

- (void)chatVCGoIMMsgVC:(BGConversationSegmentController *)chat_VC withFrinend:(SFriendObj *)friend_Obj
{
    BGConversationServiceController *imMsgChat_VC = [[BGConversationServiceController alloc] initWithNibName:@"BGBaseChatController" bundle:nil];
    imMsgChat_VC.mbhalf      = NO;
    imMsgChat_VC.mChatFriend = friend_Obj;
    [[AppDelegate sharedAppDelegate] pushViewController:imMsgChat_VC animated:NO];
}

- (void)imMsgVcGoBackToChatVC:(BGConversationServiceController *)weak_iMsg_VC
{
    CGFloat time   = 0;
    CGFloat height = weak_iMsg_VC.view.frame.size.height;

    if (height > kScreenH / 2)
    {
        time = 0.2;
        weak_iMsg_VC.inputView.hidden = YES;
        [UIView animateWithDuration:time animations:^{
            weak_iMsg_VC.view.y = kScreenH / 2;
        } completion:^(BOOL finished) {
            weak_iMsg_VC.view.height      = kScreenH / 2;
            weak_iMsg_VC.inputView.hidden = NO;
            self.isKeyboardTypeNum        = 0;
        }];
    }

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kHalfVCViewanimation animations:^{
            weak_iMsg_VC.view.x = kScreenW;
        } completion:^(BOOL finished) {
            weak_iMsg_VC.view.height = kScreenH / 2;
            [weak_iMsg_VC.view removeFromSuperview];
            [self removeChild:weak_iMsg_VC animation:nil];
            self.isHaveHalfIMMsgVC = NO;
        }];
    });
}

- (void)imMsgVCPushHomePageVC:(BGConversationServiceController *)imMsgChatVC
{
    SHomePageVC *tmpController   = [[SHomePageVC alloc] init];
    tmpController.user_id        = [NSString stringWithFormat:@"%d", imMsgChatVC.mChatFriend.mUser_id];
    tmpController.type           = 0;
    [imMsgChatVC.navigationController pushViewController:tmpController animated:YES];
}

- (void)ChatVCBgViewTap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imRemoveNeedUpdate" object:nil];
    _imChatVCBgView.hidden     = YES;
    self.panGestureRec.enabled = YES;

    for (UIViewController *one_VC in self.childViewControllers)
    {
        if ([one_VC isKindOfClass:[BGConversationSegmentController class]])
        {
            BGConversationSegmentController *imChat_VC = (BGConversationSegmentController *)one_VC;
            [UIView animateWithDuration:kHalfVCViewanimation animations:^{
                imChat_VC.view.y = kScreenH;
            } completion:^(BOOL finished) {
                if (finished)
                {
                    [imChat_VC.view removeFromSuperview];
                    [self removeChild:imChat_VC];
                    self.isHaveHalfIMChatVC = NO;
                    _isKeyboardTypeNum      = 0;
                }
            }];
        }

        // ✅ FIX: Corrected wrong cast — was casting BGConversationServiceController
        //         to BGConversationSegmentController (different type), causing crash.
        if ([one_VC isKindOfClass:[BGConversationServiceController class]])
        {
            BGConversationServiceController *imMsgChat_VC = (BGConversationServiceController *)one_VC;
            [UIView animateWithDuration:kHalfVCViewanimation animations:^{
                imMsgChat_VC.view.y = kScreenH;
            } completion:^(BOOL finished) {
                [imMsgChat_VC.view removeFromSuperview];
                [self removeChild:imMsgChat_VC];
                self.isHaveHalfIMMsgVC = NO;
                _isKeyboardTypeNum     = 0;
            }];
        }
    }
}

#pragma mark - ----------------------- 滑动手势 -----------------------

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[BGTLiveScrollView class]])          return NO;
    if ([touch.view isDescendantOfView:self.shopExplainView])          return NO;
    if (SUS_WINDOW.isSmallSusWindow)                                   return NO;
    return YES;
}

- (void)removePanGestureRec
{
    if (_panGestureRec)
        [_panGestureRec removeTarget:self action:@selector(moveViewWithGesture:)];
}

- (void)setPanGesture:(BOOL)isEnabled
{
    _panGestureRec.enabled = isEnabled;
}

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes
{
    if (_fpkProgress)                              return;
    if ([GlobalVariables sharedInstance].isBeingLinkMic) return;

    [BGUtils closeKeyboard];

    if (self.isHaveHalfIMChatVC == YES || self.isHaveHalfIMMsgVC == YES)
    {
        panGes.enabled = NO;
        return;
    }
    panGes.enabled = YES;

    if (!_isHost)
    {
        static CGFloat startX, lastX, startY, lastY, durationX, durationY;
        CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];

        if (panGes.state == UIGestureRecognizerStateBegan)
        {
            startX = lastX = touchPoint.x;
            startY = lastY = touchPoint.y;
        }

        if (panGes.state == UIGestureRecognizerStateChanged)
        {
            durationX = touchPoint.x - lastX; lastX = touchPoint.x;
            durationY = touchPoint.y - lastY; lastY = touchPoint.y;

            if (fabs(durationX) > fabs(durationY))
            {
                if (self.view.frame.origin.y > 0 || CGRectGetMaxY(self.view.frame) < self.view.frame.size.height) return;

                _isLeftOrRightPan = YES;
                if (durationX > 0)      _isFromeLeft = YES;
                else if (durationX < 0) _isFromeLeft = NO;

                if (self.liveView.frame.origin.x <= 0 && !_isFromeLeft) return;
                if (!_showingRight) _showingRight = YES;

                float x = durationX + self.liveView.frame.origin.x;
                [self.liveView setFrame:CGRectMake(x, self.liveView.frame.origin.y,
                                                   self.liveView.frame.size.width,
                                                   self.liveView.frame.size.height)];
            }
            // ✅ FIX: Removed unreachable vertical scroll code (was blocked by "return;;")
            // Vertical scroll is intentionally disabled for now.
        }
        else if (panGes.state == UIGestureRecognizerStateEnded)
        {
            if (_isLeftOrRightPan)
            {
                if (_showingRight)
                {
                    CGFloat threshold = _isFromeLeft
                        ? self.view.frame.size.width * BEGIN_SLIDE_RATE
                        : self.view.frame.size.width * (1 - BEGIN_SLIDE_RATE);

                    if (self.liveView.frame.origin.x < threshold)
                    {
                        float dur = (self.liveView.frame.origin.x) / (self.view.frame.size.width) / DURING_TIME;
                        [UIView animateWithDuration:dur animations:^{
                            [self.liveView setFrame:CGRectMake(0, self.liveView.frame.origin.y,
                                                               self.liveView.frame.size.width,
                                                               self.liveView.frame.size.height)];
                        } completion:^(BOOL finished) {
                            self.liveView.userInteractionEnabled = YES;
                        }];
                    }
                    else
                    {
                        float dur = (1 - (self.liveView.frame.origin.x) / (self.view.frame.size.width)) / DURING_TIME;
                        [UIView animateWithDuration:dur animations:^{
                            [self.liveView setFrame:CGRectMake(self.view.frame.size.width,
                                                               self.liveView.frame.origin.y,
                                                               self.liveView.frame.size.width,
                                                               self.liveView.frame.size.height)];
                        } completion:^(BOOL finished) {
                            [self.view sendSubviewToBack:self.liveView];
                            _showingRight = NO;
                        }];
                    }
                }
            }
        }
    }
}

#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(BGTLiveScrollView *)scrollView
{
    if (self.serviceDelegate && [self.serviceDelegate respondsToSelector:@selector(protocolDidScrollView:isRefreshLive:)])
        [self.serviceDelegate protocolDidScrollView:self.liveScrollView isRefreshLive:NO];
}

#pragma mark - shopExplainView

- (BogoShopExplainView *)shopExplainView
{
    if (!_shopExplainView)
    {
        _shopExplainView = [kShopKitBundle loadNibNamed:@"BogoShopExplainView" owner:nil options:nil].lastObject;
        _shopExplainView.frame = CGRectMake(kScreenW - kRealValue(12) - kRealValue(130),
                                            kScreenHeight - MG_BOTTOM_MARGIN - kRealValue(50) - kRealValue(174),
                                            kRealValue(130), kRealValue(174));
        _shopExplainView.clickBuyBlock = ^(BogoCommodityDetailShopModel *_Nonnull model) {
            if (model.model_id.integerValue == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.link_url]];
            }
            else
            {
                BogoGoodDetailViewController *detailVC = [[BogoGoodDetailViewController alloc] init];
                detailVC.gid    = model.gid;
                detailVC.uid    = model.uid;
                detailVC.source = BogoShopBuySourceLive;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
        };
    }
    _shopExplainView.backgroundColor = kWhiteColor;
    return _shopExplainView;
}

#pragma mark - Face & Music

- (void)showFace
{
    NSLog(@"点击了表情");
    [self.faceView show:self.view];
}

- (void)showMusic
{
    NSLog(@"点击了音乐");
    if (_musicVC == nil)
    {
        _musicVC = [[choseMuiscVC alloc] init];
        [self addChild:_musicVC inRect:CGRectMake(0, 227, SCREEN_WIDTH, SCREEN_HEIGHT - 227)];
    }
    else
    {
        _musicVC.view.hidden = NO;
    }

    _musicVC.mitblock = ^(musiceModel *chosemusic) {
        _musicVC.view.hidden = YES;
    };
}

- (RoomFaceView *)faceView
{
    if (!_faceView)
    {
        _faceView          = [[RoomFaceView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, 320 + (IPHONE_X ? 34 : 0))];
        _faceView.delegate = self;
    }
    return _faceView;
}

- (void)faceView:(RoomFaceView *)faceView didSelectFace:(RoomFaceModel *)model
{
    [faceView hide];
    if (self.serviceDelegate && [self.serviceDelegate respondsToSelector:@selector(protocolDidClickEmoji:)])
        [self.serviceDelegate protocolDidClickEmoji:model.img];
}

@end