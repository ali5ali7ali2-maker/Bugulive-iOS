//
//  BGTLiveController.m
//  BuguLive
//
//  Created by xfg on 16/12/5.
//  Copyright © 2016年 xfg. All rights reserved.
//  腾讯云直播，只处理与SDK有关的业务

#import "BGVoiceController.h"
#import "BGMD5UTils.h"
#import "TLiveMickListModel.h"
#import "YunMusicPlayVC.h"
#import "HostCheckMickAlertView.h"
#import "TCShowLiveView.h"
#import "BogoRoomUIViewController.h"
#import "RoomModel.h"
#import "BGRoomAnnouncementView.h"
#import "ReactiveObjC.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>

#define kPlayContrainerHeight 30

#import "TiSDKInterface.h"
#import "BeautySettingPanel.h"

#import "BGOtherPushPopView.h"
#import "BGRoomBGImageViewController.h"
#import "RoomBGImageModel.h"
#import "DownloadHelper.h"
#import "RoomSetViewController.h"

@interface BGVoiceController ()<BeautySettingPanelDelegate,BeautyLoadPituDelegate,BogoRoomUIViewControllerDelegate,AgoraRtcEngineDelegate,MusicPlayerDelegate>
{
    BeautySettingPanel *_beautyPanel;
}

@property (nonatomic, strong) TiSDKManager      *tiSDKManager;
@property (nonatomic, strong) UIView            *liveView;
@property (nonatomic, strong) BGOtherPushPopView        *otherPushPopView;
@property (nonatomic, strong) BogoRoomUIViewController  *voiceRoomVC;
@property (nonatomic, strong) BGRoomAnnouncementView    *announcementView;
@property (nonatomic, strong) AgoraRtcEngineKit         *agoraKit;
@property (nonatomic, strong) NSTimer                   *agoraPlayTime;

@end

@implementation BGVoiceController

#pragma mark - ----------------------- 添加UI -----------------------

- (void)addSubViews
{
    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        _beautyView = [[BGTLiveBeautyView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        [self.liveServiceController.liveUIViewController.liveView addSubview:_beautyView];
        _beautyView.delegate = self;
        _beautyView.hidden = YES;
    }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
    {
        _reLiveProgressView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 80 - MG_BOTTOM_MARGIN, kScreenW, kPlayContrainerHeight)];
        _reLiveProgressView.backgroundColor = kClearColor;
        _reLiveProgressView.hidden = YES;

        _btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnPlay.frame = CGRectMake(kDefaultMargin, 0, kPlayContrainerHeight, kPlayContrainerHeight);
        [_btnPlay setImage:[UIImage imageNamed:@"fw_relive_start"] forState:UIControlStateNormal];
        [_btnPlay addTarget:self action:@selector(onClickPlay) forControlEvents:UIControlEventTouchUpInside];
        [_reLiveProgressView addSubview:_btnPlay];

        _playStart = [[UILabel alloc] init];
        _playStart.frame = CGRectMake(kScreenW - 75 - kDefaultMargin, 0, 75, kPlayContrainerHeight);
        _playStart.font = kAppSmallTextFont;
        [_playStart setText:@"00:00"];
        [_playStart setTextColor:[UIColor whiteColor]];
        [_reLiveProgressView addSubview:_playStart];

        _playProgress = [[UISlider alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnPlay.frame) + kDefaultMargin, 5, kScreenW - CGRectGetWidth(_btnPlay.frame) - CGRectGetWidth(_playStart.frame) - kDefaultMargin * 4, kPlayContrainerHeight - 10)];
        [_playProgress setThumbImage:[UIImage imageNamed:@"fw_relive_slider_thumb"] forState:UIControlStateNormal];
        _playProgress.minimumTrackTintColor = kWhiteColor;
        _playProgress.maximumTrackTintColor = kAppGrayColor2;
        _playProgress.maximumValue = 0;
        _playProgress.minimumValue = 0;
        _playProgress.value = 0;
        _playProgress.continuous = NO;
        [_playProgress addTarget:self action:@selector(onSeek) forControlEvents:UIControlEventValueChanged];
        [_playProgress addTarget:self action:@selector(onSeekBegin) forControlEvents:UIControlEventTouchDown];
        [_playProgress addTarget:self action:@selector(onDrag) forControlEvents:UIControlEventTouchDragInside];
        [_playProgress addTarget:self action:@selector(dragSliderDidEnd:) forControlEvents:UIControlEventTouchUpInside];
        [_reLiveProgressView addSubview:_playProgress];
    }

    if (self.liveType == FW_LIVE_TYPE_RELIVE || self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        self.backVerticalBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 15, 35, 35)];
        [self.backVerticalBtn setImage:[UIImage imageNamed:@"com_arrow_vc_back_2"] forState:UIControlStateNormal];
        [self.backVerticalBtn addTarget:self action:@selector(goVerticalScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.backVerticalBtn];
        self.backVerticalBtn.hidden = YES;
    }
}

#pragma mark 添加视频
- (void)initLive
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceNotice:) name:@"closeAndOpenVoice" object:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playMusicClicked:) name:@"playMusic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopMusic) name:@"stopMusic" object:nil];

    [self initializeAgoraEngine];
}

- (void)onEnterRoom:(NSInteger)result
{
    if (result > 0)
    {
    }
    else
    {
        [BGHUDHelper alert:[NSString stringWithFormat:@"进入直播间直播-%ld", result]];
    }
}

// ✅ إصلاح: منطق currentIndex كان خاطئاً (كان يبدأ بـ 1 دائماً ويتجاهل الـ index 0)
//           وكان if (currentIndex == self.modelArr.count - 1) مكرراً في نفس else block
- (void)protocolDidScrollView:(BGTLiveScrollView *)scrollView isRefreshLive:(BOOL)isRefresh
{
    NSInteger currentIndex = 0;

    for (int i = 0; i < self.modelArr.count; i++)
    {
        LivingModel *model = self.modelArr[i];
        NSString *roomID = [NSString stringWithFormat:@"%d", model.room_id];
        if ([roomID isEqualToString:scrollView.roomID])
        {
            currentIndex = i;
            break;
        }
    }

    scrollView.nowIndex = currentIndex;

    if ((self.now_LiveIndex == 0 && scrollView.isFromeTop) || (self.now_LiveIndex == self.modelArr.count - 1 && !scrollView.isFromeTop))
    {
        _linkMicPlayController.videoContrainerView.top = 0;
        _liveServiceController.liveUIViewController.liveScrollView.top = 0;
        _firstImgView.top = _linkMicPlayController.videoContrainerView.bottom;
        _secondImgView.top = _firstImgView.bottom;
        return;
    }

    LivingModel *first_Model;
    LivingModel *second_Model;

    if (self.modelArr.count < 2)
    {
        _liveServiceController.liveUIViewController.liveScrollView.top = 0;
        return;
    }

    if (self.modelArr.count == 2)
    {
        if (currentIndex == 1)
        {
            first_Model = self.modelArr[1];
            second_Model = self.modelArr[0];
        }
        else
        {
            first_Model = self.modelArr[0];
            second_Model = self.modelArr[1];
        }
    }
    else
    {
        // ✅ إصلاح: حذف الشرط المكرر (currentIndex == self.modelArr.count - 1) داخل else
        if (currentIndex == 0)
        {
            first_Model = self.modelArr[1];
            second_Model = self.modelArr[2];
        }
        else if (currentIndex == self.modelArr.count - 1)
        {
            first_Model = self.modelArr[self.modelArr.count - 2];
            second_Model = self.modelArr[self.modelArr.count - 1];
        }
        else
        {
            first_Model = self.modelArr[currentIndex + 1];
            second_Model = self.modelArr[currentIndex - 1];
        }
    }

    _linkMicPlayController.videoContrainerView.top = scrollView.y;
    _firstImgView.bottom = _linkMicPlayController.videoContrainerView.top;
    _secondImgView.top = _linkMicPlayController.videoContrainerView.bottom;

    if (first_Model)
    {
        [_firstImgView sd_setImageWithURL:[NSURL URLWithString:first_Model.live_image] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    }
    if (second_Model)
    {
        [_secondImgView sd_setImageWithURL:[NSURL URLWithString:second_Model.live_image] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    }

    if (!isRefresh) return;

    // ✅ إصلاح: حذف السطر `LivingModel *model = [LivingModel new]` الذي كان يُنشئ object ثم يُستبدل فوراً
    LivingModel *model = nil;
    if (scrollView.isFromeTop)
    {
        model = second_Model;
    }
    else
    {
        model = first_Model;
    }

    if (!model || model.live_in != FW_LIVE_STATE_ING) return;

    if (scrollView.y == kScreenH || scrollView.y == 0)
    {
        self.nowModel = model;
        for (int i = 0; i < self.modelArr.count; i++)
        {
            LivingModel *m = self.modelArr[i];
            if (m.room_id == self.nowModel.room_id)
            {
                self.now_LiveIndex = i;
            }
        }

        FWWeakify(self)
        NSString *roomID = [NSString stringWithFormat:@"%d", model.room_id];

        [_liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
            FWStrongify(self)
            if (!liveInfo) return;

            TCShowUser *user = [[TCShowUser alloc] init];
            user.avatar = liveInfo.podcast.user.head_image;
            user.uid = liveInfo.user_id;
            user.username = liveInfo.podcast.user.nick_name;

            TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
            liveRoom.host = user;
            liveRoom.avRoomId = [liveInfo.room_id intValue];
            liveRoom.title = [NSString stringWithFormat:@"%d", liveRoom.avRoomId];
            liveRoom.vagueImgUrl = liveInfo.podcast.user.head_image;
            liveRoom.liveType = SUS_WINDOW.liveType;
            liveRoom.isHost = NO;

            _liveServiceController.liveUIViewController.liveScrollView.roomID = liveInfo.room_id;
            [_liveServiceController.liveUIViewController.liveView refreshLiveItem:liveRoom liveInfo:liveInfo];
            [_liveServiceController.liveUIViewController.liveView.msgView.liveMessages removeAllObjects];

            self.liveInfo = liveInfo;
            [self beginPlayVideo:liveInfo];
            self.hasVideoControl = liveInfo.has_video_control ? YES : NO;

            _linkMicPlayController.videoContrainerView.top = 0;
            _liveServiceController.liveUIViewController.liveScrollView.top = 0;
            _firstImgView.top = _linkMicPlayController.videoContrainerView.bottom;
            _secondImgView.top = _firstImgView.bottom;

            [super startEnterChatGroup:liveInfo.group_id succ:nil failed:nil];

        } roomID:roomID failed:^(int errId, NSString *errMsg) {
        }];
    }
}

- (void)clickVoiceMic:(TCShowLiveView *)showLiveView
{
    [self.voiceRoomVC showMicView];
}

- (void)clickVoiceMore:(TCShowLiveView *)showLiveView
{
    FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"" message:@""];
    [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"房间背景图片设置") type:FDActionTypeDefault CallBack:^{
        BGRoomBGImageViewController *vc = [BGRoomBGImageViewController new];
        vc.editRoomBGChangedCallBack = ^(RoomBGImageModel *selectModel) {
            UIImageView *iv = [self.vagueImgView viewWithTag:9998];
            [iv setImageURL:[NSURL URLWithString:selectModel.image]];
        };
        vc.room_id = self.liveInfo.room_id;
        [self.navigationController pushViewController:vc animated:NO];
    }]];
    [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:^{}]];
    [actionSheet show:self.view];
}

- (void)clickRightContrainerView:(NSString *)roomID
{
    FWWeakify(self)
    [_liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
        FWStrongify(self)
        if (!liveInfo) return;

        TCShowUser *user = [[TCShowUser alloc] init];
        user.avatar = liveInfo.podcast.user.head_image;
        user.uid = liveInfo.user_id;
        user.username = liveInfo.podcast.user.nick_name;

        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
        liveRoom.host = user;
        liveRoom.avRoomId = [liveInfo.room_id intValue];
        liveRoom.title = [NSString stringWithFormat:@"%d", liveRoom.avRoomId];
        liveRoom.vagueImgUrl = liveInfo.podcast.user.head_image;
        liveRoom.liveType = SUS_WINDOW.liveType;
        liveRoom.isHost = NO;

        _liveServiceController.liveUIViewController.liveScrollView.roomID = liveInfo.room_id;
        [_liveServiceController.liveUIViewController.liveView refreshLiveItem:liveRoom liveInfo:liveInfo];

        self.liveInfo = liveInfo;
        [self beginPlayVideo:liveInfo];
        self.hasVideoControl = liveInfo.has_video_control ? YES : NO;

        _linkMicPlayController.videoContrainerView.top = 0;
        _liveServiceController.liveUIViewController.liveScrollView.top = 0;
        _firstImgView.top = _linkMicPlayController.videoContrainerView.bottom;
        _secondImgView.top = _firstImgView.bottom;

        [super startEnterChatGroup:liveInfo.group_id succ:nil failed:nil];

    } roomID:roomID failed:^(int errId, NSString *errMsg) {
    }];
}

- (void)closeVoiceRoom
{
    // ✅ nil check على agoraKit قبل الاستخدام
    if (self.agoraKit)
    {
        [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {}];
    }
}

- (void)showAnnouncement
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"get_notice" forKey:@"act"];
    [dict setValue:self.liveInfo.room_id forKey:@"room_id"];

    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        self.liveInfo.announcement = responseJson[@"data"][@"announcement"];
        [self.announcementView show:self.view];
    } FailureBlock:^(NSError *error) {
    }];
}

- (BGRoomAnnouncementView *)announcementView
{
    if (!_announcementView)
    {
        _announcementView = [[BGRoomAnnouncementView alloc] initWithFrame:CGRectMake(0, kScreenW - 300 - (IPHONE_X ? 34 : 0), self.view.width, 300 + (IPHONE_X ? 34 : 0))];
        _announcementView.delegate = self;
        _announcementView.editBtn.hidden = !self.liveItem.isHost;
    }
    // ✅ إصلاح: تحديث النص بعد التحقق من وجود الـ object لضمان عدم الوصول لـ nil
    _announcementView.textView.text = self.liveInfo.announcement;
    return _announcementView;
}

- (void)announcementView:(BGRoomAnnouncementView *)announcementView didClickEditBtn:(UIButton *)sender
{
    [FanweMessage alertInput:nil message:@"请输入公告" placeholder:@"" keyboardType:UIKeyboardTypeDefault destructiveTitle:@"确认" destructiveAction:^(NSString *text) {

        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:@"voice" forKey:@"ctl"];
        [dict setValue:@"save_notice" forKey:@"act"];
        [dict setValue:self.liveInfo.room_id forKey:@"room_id"];
        [dict setValue:text forKey:@"announcement"];

        [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
            [self showError:responseJson];
        } FailureBlock:^(NSError *error) {
        }];

    } cancelTitle:@"取消" cancelAction:^{}];
}

- (void)showError:(NSDictionary *)res
{
    if (![res[@"error"] isEqualToString:@""])
    {
        [[BGHUDHelper sharedInstance] tipMessage:res[@"error"]];
    }
}

- (void)clickUser:(UserModel *)model
{
    [self.liveServiceController getUserInfo:model];
}

#pragma mark 添加直播间逻辑、视图
- (void)addServiceController
{
    if (!_liveServiceController)
    {
        _liveServiceController = [[BGLiveServiceController alloc] initWith:self.liveItem liveController:self];
        _liveServiceController.isVoice = YES;
        _liveServiceController.liveUIViewController.isVoice = YES;
        _liveServiceController.delegate = self;

        for (int i = 0; i < _liveServiceController.liveUIViewController.liveView.topView.subviews.count; i++)
        {
            UIView *subView = _liveServiceController.liveUIViewController.liveView.topView.subviews[i];
            subView.hidden = YES;
        }

        _liveServiceController.liveUIViewController.liveView.topView.timeView.hidden = NO;
        _liveServiceController.liveUIViewController.liveView.topView.width = 200;
        _liveServiceController.liveUIViewController.liveView.topView.height = 50;
        _liveServiceController.liveUIViewController.liveView.closeLiveBtn.hidden = YES;
        _liveServiceController.liveUIViewController.liveView.topView.timeView.userInteractionEnabled = YES;
        _liveServiceController.pluginCenterView.toolsView.toSDKdelegate = self;
        _liveServiceController.liveUIViewController.liveView.sdkDelegate = self;
        _liveServiceController.liveUIViewController.liveView.topView.toSDKDelegate = self;
        _liveServiceController.liveUIViewController.liveScrollView.hidden = YES;
        _liveServiceController.liveUIViewController.liveView.bottomView.hidden = YES;
        [_liveServiceController.liveUIViewController.liveView.bottomView removeFromSuperview];
        _liveServiceController.liveUIViewController.liveView.voicebottomView.hidden = NO;

        [self addChild:_liveServiceController inRect:self.view.bounds];

        __weak __typeof(self) weakSelf = self;
        _voiceRoomVC = [[BogoRoomUIViewController alloc] init];
        _voiceRoomVC.supperView = self.view;
        _voiceRoomVC.delegate = self;
        _voiceRoomVC.roomTopView.btnClickBlok = ^(BGVoiceRoomTopViewClickType type) {
            if (type == BGVoiceRoomTopViewClickTypeAnnouncement)
            {
                [_voiceRoomVC micView:nil didClickNumberBtn:nil];
            }
            else if (type == BGVoiceRoomTopViewClickTypeShare)
            {
                [weakSelf.liveServiceController clickShareBtn:nil];
            }
            else if (type == BGVoiceRoomTopViewClickTypeClose)
            {
                [weakSelf.liveServiceController clickCloseBtn:nil];
            }
            else if (type == BGVoiceRoomTopViewClickTypeSwitch)
            {
                [weakSelf clickSwitchBtn:nil];
            }
        };

        [_liveServiceController.liveUIViewController addChild:_voiceRoomVC container:_liveServiceController.liveUIViewController.liveView inRect:self.view.bounds];
        [_liveServiceController.liveUIViewController.liveView sendSubviewToBack:_voiceRoomVC.view];
    }
}

- (void)clickSwitchBtn:(UIButton *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"5人房") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self switchPeople:@"5"]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"10人房") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self switchPeople:@"10"]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"15人房") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self switchPeople:@"15"]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"20人房") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) { [self switchPeople:@"20"]; }]];
    [alert addAction:[UIAlertAction actionWithTitle:ASLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)switchPeople:(NSString *)people
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"change_room_mic_people" forKey:@"act"];
    [dict setValue:self.roomIDStr forKey:@"room_id"];
    [dict setValue:people forKey:@"people_count"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {} FailureBlock:^(NSError *error) {}];
}

- (void)micView:(RoomLiveMicView *)micView didClickAnnouncementBtn:(UIButton *)sender
{
    [self showAnnouncement];
}

- (void)needOpenRTCAudio:(BOOL)isOpen
{
    // ✅ nil check على agoraKit
    if (self.agoraKit)
    {
        [self.agoraKit enableLocalAudio:isOpen];
    }
}

#pragma mark - ----------------------- 重写父方法 -----------------------
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem modelArr:(NSArray *)modelArr
{
    if (self = [super initWith:liveItem modelArr:modelArr])
    {
        self.modelArr = [NSMutableArray arrayWithArray:modelArr];
        for (int i = 0; i < modelArr.count; i++)
        {
            LivingModel *model = modelArr[i];
            if (model.room_id == liveItem.liveAVRoomId)
            {
                self.nowModel = model;
                self.now_LiveIndex = i;
            }
        }
        [self addServiceController];
        [self addSubViews];
    }
    return self;
}

- (void)refreshVoice:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CustomMessageModel *)customMessageModel
{
    NSArray *list = [NSArray modelArrayWithClass:Wheat_Type_List.class json:customMessageModel.dicData[@"wheat_type_list"]];
    self.liveInfo.wheat_type_list = list;
    self.liveServiceController.currentLiveInfo.wheat_type_list = list;
    self.voiceRoomVC.model.wheat_type_list = list;
    [self.voiceRoomVC setModel:self.voiceRoomVC.model];

    BOOL openAudio = NO;
    BOOL muteAudio = NO;
    for (int i = 0; i < self.voiceRoomVC.model.wheat_type_list.count; i++)
    {
        Wheat_Type_List *item = self.voiceRoomVC.model.wheat_type_list[i];
        if (item.even_wheat.user_id == [[IMAPlatform sharedInstance].host imUserId].intValue)
        {
            openAudio = YES;
            if (item.even_wheat.is_ban_voice == 1)
            {
                muteAudio = YES;
            }
        }
    }

    [self needOpenRTCAudio:openAudio];

    // ✅ nil check على agoraKit
    if (openAudio && self.agoraKit)
    {
        [self.agoraKit enableLocalAudio:!muteAudio];
    }
}

- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    [super refreshLiveItem:liveItem liveInfo:liveInfo];
    [_liveServiceController refreshLiveItem:liveItem liveInfo:liveInfo];
    self.voiceRoomVC.live_info = liveInfo;

    RoomModel *model = [[RoomModel alloc] init];
    model.wheat_type_list = liveInfo.wheat_type_list;
    self.voiceRoomVC.model = model;
    self.agora_token = liveInfo.agora_token;
    [self joinChannel:liveInfo.room_id];

    _liveServiceController.liveUIViewController.liveView.topView.timeView.liveAudience.text = [NSString stringWithFormat:ASLocalizedString(@"%ld"), liveInfo.viewer_num];
    NSString *audienceStr = [NSString stringWithFormat:ASLocalizedString(@"%ld"), liveInfo.viewer_num];
    [self.voiceRoomVC.roomTopView.btnAnnouncement setTitle:[NSString stringWithFormat:ASLocalizedString(@"%@ 在线"), audienceStr] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.BuguLive.appModel.mic_max_num >= 3 || self.BuguLive.appModel.mic_max_num == 0)
    {
        _micMaxNum = 3;
    }
    else
    {
        _micMaxNum = self.BuguLive.appModel.mic_max_num;
    }

    [self initLive];

    NSString *key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
    if ([BGUtils isBlankString:key])
    {
        key = @"517a990947274dd8b51e1525feb0fb79";
    }

    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"语音房间背景"]];
    iv.tag = 9998;
    iv.frame = self.vagueImgView.bounds;
    self.voiceBackgroundImage = iv;
    [self.vagueImgView setImage:[UIImage imageNamed:@"语音房间背景"]];
    [self.vagueImgView addSubview:iv];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voiceLiveAudienceChanged:) name:kLiveAudienceChangedNotification object:nil];
}

- (GLuint)onPreProcessTexture:(GLuint)texture width:(CGFloat)width height:(CGFloat)height
{
    if (self.tiSDKManager && [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO])
    {
        return [self.tiSDKManager renderTexture2D:texture Width:width Height:height Rotation:CLOCKWISE_0 Mirror:NO];
    }
    return texture;
}

#pragma mark 腾讯云直播开始进入直播间
- (void)startEnterChatGroup:(NSString *)chatGroupID succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    __weak typeof(self) ws = self;

    [_liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {

        if (liveInfo)
        {
            if (_isHost)
            {
                [_liveServiceController startLiveTimer];
            }

            ws.liveInfo = liveInfo;

            if (self.liveInfo.voice_bg_image.length > 0)
            {
                UIImageView *iv = self.voiceBackgroundImage;
                [iv setImageURL:[NSURL URLWithString:self.liveInfo.voice_bg_image]];
            }

            ws.hasVideoControl = liveInfo.has_video_control ? YES : NO;

            if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE && liveInfo.has_video_control)
            {
                _reLiveProgressView.hidden = NO;
            }
            else
            {
                _reLiveProgressView.hidden = YES;
            }

            ws.liveServiceController.liveUIViewController.livePay.payDelegate = self;

            if (![BGUtils isBlankString:liveInfo.push_rtmp] || ![BGUtils isBlankString:liveInfo.play_url])
            {
                [ws beginPlayVideo:liveInfo];
            }

            if (liveInfo.is_live_pay == 1 && liveInfo.is_pay_over == 0 && ![liveInfo.podcast.user.user_id isEqualToString:[[IMAPlatform sharedInstance].host imUserId]])
            {
                if (succ) { succ(); }
            }
            else
            {
                [super startEnterChatGroup:liveInfo.group_id succ:^{
                    [ws getVideoState:1];
                    if (succ) { succ(); }
                } failed:^(int errId, NSString *errMsg) {
                    [ws getVideoState:0];
                    if (failed) { failed(errId, errMsg); }
                }];
            }
        }
        else
        {
            [ws setGetVideoFailed:nil];
            if (failed) { failed(FWCode_Net_Error, ASLocalizedString(@"获取到的liveInfo为空")); }
        }

    } roomID:@"" failed:^(int errId, NSString *errMsg) {
        [ws setGetVideoFailed:errMsg];
        if (failed) { failed(errId, errMsg); }
        DebugLog(@"=========加载get_video接口出错 code: %d , msg = %@", errId, errMsg);
    }];
}

#pragma mark 加入聊天组成功
- (void)enterChatGroupSucc:(CurrentLiveInfo *)liveInfo
{
    [super enterChatGroupSucc:liveInfo];
    if (!_isHost && (_liveInfo.join_room_prompt == 1 || [[IMAPlatform sharedInstance].host getUserRank] >= self.BuguLive.appModel.jr_user_level))
    {
        _liveServiceController.liveUIViewController.liveView.canShowLightMessage = YES;
    }
}

#pragma mark 重写父方法：业务上退出直播
- (void)onServiceExitLive:(BOOL)isDirectCloseLive succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    [_liveServiceController endLive];

    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        [_publishController endLive];

        __weak typeof(self) ws = self;
        [_liveServiceController hostExitLive:^{
            if (isDirectCloseLive) { [ws onExitLiveUI]; }
            if (succ) { succ(); }
        } failed:^(int errId, NSString *errMsg) {
            if (isDirectCloseLive) { [ws onExitLiveUI]; }
            if (failed) { failed(errId, errMsg); }
        }];

        [_publishController stopRtmp];
    }
    else
    {
        if (self.liveType == FW_LIVE_TYPE_RELIVE)
        {
            [_playController stopRtmp];
        }
        else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
        {
            [_linkMicPlayController endVideo];
            [self cancelMickingAlert];
            if ([_linkMicPlayController.linkMemeberSet containsObject:[[IMAPlatform sharedInstance].host imUserId]])
            {
                [BGLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:@""];
            }
        }

        if (isDirectCloseLive)
        {
            [self onExitLiveUI];
        }
        if (succ) { succ(); }
    }
}

#pragma mark 是否需要打断视频
- (void)interruptionLiveIng:(BOOL)interruptioning
{
    if (interruptioning)
    {
        [_liveServiceController pauseLive];
        if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            [_publishController.txLivePublisher pausePush];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            [_playController onAppDidEnterBackGround];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            [_linkMicPlayController onAppDidEnterBackGround];
        }
    }
    else
    {
        [_liveServiceController resumeLive];
        if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            [_publishController.txLivePublisher resumePush];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            [_playController onAppWillEnterForeground];
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            [_linkMicPlayController onAppWillEnterForeground];
        }
    }
}

// ✅ إصلاح: استدعاء super عشان الـ base يعمل reset لـ _hasHandleCall و _isPhoneInterupt و endBackgroundTask
#pragma mark 是否正在被电话打断
- (void)phoneInterruptioning:(BOOL)interruptioning
{
    [super phoneInterruptioning:interruptioning];
    [self interruptionLiveIng:interruptioning];
}

// ✅ إصلاح: استدعاء super عشان الـ background task يتعمله end صح
#pragma mark app进入前台
- (void)onAppEnterForeground
{
    [super onAppEnterForeground];

    if (_isHost)
    {
        [_publishController.txLivePublisher resumePush];
    }
    else
    {
        if (_isMickAudiencePushing)
        {
            _isMickAudiencePushing = NO;
            [_linkMicPlayController.txLivePush resumePush];
        }
    }
}

// ✅ إصلاح: استدعاء super عشان الـ background task يتعمل بشكل صح
#pragma mark app进入后台
- (void)onAppEnterBackground
{
    [super onAppEnterBackground];

    if (_isHost)
    {
        [_publishController.txLivePublisher pausePush];
    }
    else
    {
        if (_linkMicPlayController.txLivePush.isPublishing)
        {
            _isMickAudiencePushing = YES;
            [_linkMicPlayController.txLivePush pausePush];
        }
    }

    if (_toolsView)
    {
        [BGUtils turnOnFlash:NO];
        ToolsCollectionViewCell *cell = (ToolsCollectionViewCell *)[_toolsView.toolsCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        if (cell)
        {
            cell.toolImgView.image = [UIImage imageNamed:@"lr_plugin_flash_unsel"];
        }
    }
}

#pragma mark 重写退出方法
- (void)onExitLiveUI
{
    [super onExitLiveUI];

    if (SUS_WINDOW.isSusWindow && SUS_WINDOW.isDirectCloseLive == YES)
    {
        [[LiveCenterManager sharedInstance] resetSuswindowPramaComple:^(BOOL finished) {}];
    }

    [_liveServiceController endLive];
    [_liveServiceController.view removeFromSuperview];

    _publishController = nil;
    _playController = nil;
    _linkMicPlayController = nil;

    // ✅ إصلاح: تحرير الـ timer + مغادرة channel + تدمير Agora engine بشكل صحيح
    [self releaseTimer];
    if (self.agoraKit)
    {
        [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {}];
        [AgoraRtcEngineKit destroy];
        self.agoraKit = nil;
    }

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@"voice" forKey:@"ctl"];
    [dict setValue:@"end_voice" forKey:@"act"];
    [dict setValue:self.roomIDStr forKey:@"room_id"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {} FailureBlock:^(NSError *error) {}];

    if (!SUS_WINDOW.isSusWindow)
    {
        self.navigationController.navigationBarHidden = NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark 重写声音打断监听
- (void)onAudioInterruption:(NSNotification *)notification
{
    [super onAudioInterruption:notification];
    if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        [_playController onAudioInterruption:notification];
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        [_linkMicPlayController onAudioInterruption:notification];
    }
}

#pragma mark 监听耳机插入和拔出
- (void)audioRouteChangeListenerCallback:(NSNotification *)notification
{
    [super audioRouteChangeListenerCallback:notification];
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason)
    {
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            _publishController.txLivePushonfig.enableAudioPreview = YES;
            [_publishController.txLivePublisher setConfig:_publishController.txLivePushonfig];
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            _publishController.txLivePushonfig.enableAudioPreview = NO;
            [_publishController.txLivePublisher setConfig:_publishController.txLivePushonfig];
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark 重写弹出退出或直接退出
- (void)alertExitLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert succ:(FWVoidBlock)succ failed:(FWErrorBlock)failed
{
    self.isDirectCloseLive = isDirectCloseLive;

    [self.liveServiceController.liveUIViewController.liveView.livewWishView.rotateTimer invalidate];
    self.liveServiceController.liveUIViewController.liveView.livewWishView.rotateTimer = nil;

    LiveCenterManager *liveCenterManager = [LiveCenterManager sharedInstance];

    if (self.isHost || !isDirectCloseLive || self.liveType == FW_LIVE_TYPE_RELIVE || _liveInfo.is_live_pay == 1)
    {
        [liveCenterManager closeLiveOfPramaOfLiveViewController:self paiTimeNum:nil alertExitLive:isDirectCloseLive isHostShowAlert:isHostShowAlert colseLivecomplete:^(BOOL finished) {
            if (finished) { if (succ) { succ(); } }
            else { if (failed) { failed(FWCode_Normal_Error, @""); } }
        }];
    }
    else
    {
        [liveCenterManager closeLiveOfPramaOfLiveViewController:self paiTimeNum:nil alertExitLive:isDirectCloseLive isHostShowAlert:isHostShowAlert colseLivecomplete:^(BOOL finished) {
            if (isHostShowAlert) { [FanweMessage alert:ASLocalizedString(@"您被主播踢出直播间")]; }
            if (finished) { if (succ) { succ(); } }
            else { if (failed) { failed(FWCode_Normal_Error, @""); } }
        }];
    }
}

- (void)showHoverViewWithAlert:(BOOL)isHostShowAlert
{
    [self.liveServiceController.liveUIViewController pkVivewHidden];
    __weak __typeof(self) weakSelf = self;

    self.liveServiceController.clickCloseBlock = ^(BOOL isReresh) {
        [weakSelf.hoverView removeFromSuperview];
        weakSelf.hoverView = nil;
        [weakSelf.linkMicPlayController.view removeFromSuperview];
        weakSelf.linkMicPlayController.view = nil;
    };

    if (!self.hoverView)
    {
        self.hoverView = [[WMDragView alloc] init];
        self.hoverView.backgroundColor = kClearColor;
        self.hoverView.button.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [self.hoverView.button setTitle:ASLocalizedString(@"可拖曳") forState:UIControlStateNormal];
        self.hoverView.button.hidden = YES;

        self.hoverView.clickDragViewBlock = ^(WMDragView *dragView) {
            [weakSelf.hoverView removeFromSuperview];
            weakSelf.hoverView = nil;
            [weakSelf.linkMicPlayController.view removeFromSuperview];
            weakSelf.linkMicPlayController.view = nil;

            [[LiveCenterManager sharedInstance] closeLiveOfPramaOfLiveViewController:weakSelf paiTimeNum:nil alertExitLive:YES isHostShowAlert:YES colseLivecomplete:^(BOOL finished) {
                weakSelf.linkMicPlayController.view = nil;
                weakSelf.linkMicPlayController = nil;
                BOOL isSusWindow = [[LiveCenterManager sharedInstance] judgeIsSusWindow];
                [[LiveCenterManager sharedInstance] showLiveOfAudienceLiveofTCShowLiveListItem:[LiveCenterManager sharedInstance].itemModel modelArr:nil isSusWindow:isSusWindow isSmallScreen:NO block:^(BOOL isFinished) {}];
            }];
        };

        self.hoverView.duringDragBlock = ^(WMDragView *dragView) {
            weakSelf.linkMicPlayController.videoContrainerView.frame = dragView.frame;
        };

        self.hoverView.endDragBlock = ^(WMDragView *dragView) {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:@"rightMove" context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.5];
            weakSelf.linkMicPlayController.videoContrainerView.frame = dragView.frame;
            [UIView commitAnimations];
        };
    }

    CGRect frame = CGRectMake(kScreenW * 0.7, kScreenH / 2, kScreenW * 0.3, kScreenH * 0.25);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"lr_top_close"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickLive:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(frame.size.width - 40, 0, 40, 40);
    [self.hoverView addSubview:btn];

    _linkMicPlayController.view.frame = frame;
    _linkMicPlayController.view.backgroundColor = kClearColor;
    _linkMicPlayController.pkBgView.hidden = YES;
    [_linkMicPlayController.pkBgView removeAllSubViews];
    _linkMicPlayController.pkBgView = nil;
    self.hoverView.frame = _linkMicPlayController.view.bounds;
    _linkMicPlayController.videoContrainerView.frame = _linkMicPlayController.view.bounds;
    [[BGBaseAppDelegate sharedAppDelegate].window addSubview:_linkMicPlayController.view];
    [_linkMicPlayController.view addSubview:self.hoverView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLive:) name:@"clickLiveRoomNotification" object:nil];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentP = [touch locationInView:self.hoverView];
    CGPoint preP = [touch previousLocationInView:self.hoverView];
    CGFloat offsetX = currentP.x - preP.x;
    CGFloat offsetY = currentP.y - preP.y;
    self.hoverView.transform = CGAffineTransformTranslate(self.hoverView.transform, offsetX, offsetY);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)clickLive:(UIButton *)sender
{
    self.hoverView.hidden = self.linkMicPlayController.view.hidden = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hoverView removeFromSuperview];
        self.hoverView = nil;
        [self.linkMicPlayController.view removeFromSuperview];
        // ✅ إصلاح: كان `self.liveView = nil` خطأ — الصحيح هو تفريغ linkMicPlayController.view
        self.linkMicPlayController.view = nil;
        [self clickEndLive];
    });
}

- (void)clickEndLive
{
    __weak __typeof(self) weakSelf = self;
    [[LiveCenterManager sharedInstance] closeLiveOfPramaOfLiveViewController:self paiTimeNum:nil alertExitLive:YES isHostShowAlert:YES colseLivecomplete:^(BOOL finished) {
        weakSelf.linkMicPlayController.view = nil;
        weakSelf.linkMicPlayController = nil;
    }];
}

#pragma mark - ----------------------- 部分业务逻辑 -----------------------
- (void)setGetVideoFailed:(NSString *)errMsg
{
    NSString *errStr = [BGUtils isBlankString:errMsg] ? ASLocalizedString(@"获取聊天室信息失败，请稍候尝试") : errMsg;
    [self getVideoState:0];
    __weak typeof(self) ws = self;
    [BGHUDHelper alert:errStr action:^{ [ws onExitLiveUI]; }];
}

- (void)beginPlayVideo:(CurrentLiveInfo *)liveInfo
{
    _iMMsgHandler.isEnterRooming = NO;
    __weak typeof(self) ws = self;

    if (self.liveType == FW_LIVE_TYPE_HOST)
    {
        if (liveInfo.push_rtmp && ![liveInfo.push_rtmp isEqualToString:@""])
        {
            _publishController.pushUrlStr = liveInfo.push_rtmp;
            if (![GlobalVariables sharedInstance].isOtherPush)
            {
                [_publishController startRtmp];
            }
        }
        else
        {
            [BGHUDHelper alert:ASLocalizedString(@"抱歉，推流地址为空，请稍后尝试") action:^{
                [ws alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
            }];
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_RELIVE)
    {
        if (liveInfo.has_video_control)
        {
            [_liveServiceController.liveUIViewController.liveView addSubview:_reLiveProgressView];
        }
        _playController.playProgress = _playProgress;
        _playController.playStart = _playStart;
        _playController.btnPlay = _btnPlay;

        if (liveInfo.play_url && ![liveInfo.play_url isEqualToString:@""])
        {
            _playController.playUrlStr = liveInfo.play_url;
            [_playController clickPlay:_btnPlay create_type:liveInfo.create_type];
        }
        else
        {
            [BGHUDHelper alert:ASLocalizedString(@"视频已删除.") action:^{
                [ws alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
            }];
        }
    }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
    {
        if (liveInfo.play_url && ![liveInfo.play_url isEqualToString:@""])
        {
            _linkMicPlayController.playUrlStr = liveInfo.play_url;
            [_linkMicPlayController startRtmp:liveInfo.create_type];
        }
        else
        {
            [BGHUDHelper alert:ASLocalizedString(@"抱歉，播放地址为空，请稍后尝试") action:^{
                [ws alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
            }];
        }
    }
}

- (void)getVideoState:(NSInteger)state
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"video_cstatus" forKey:@"act"];
    [mDict setObject:[NSString stringWithFormat:@"%d", [self.liveItem liveAVRoomId]] forKey:@"room_id"];
    [mDict setObject:StringFromInteger(state) forKey:@"status"];
    if ([self.liveItem liveIMChatRoomId] && ![[self.liveItem liveIMChatRoomId] isEqualToString:@""])
    {
        [mDict setObject:[self.liveItem liveIMChatRoomId] forKey:@"group_id"];
    }
    [_liveServiceController getVideoState:mDict];
}

#pragma mark - ----------------------- 回放相关 -----------------------
- (void)onClickPlay { [_playController clickPlay:_btnPlay create_type:self.liveInfo.create_type]; }
- (void)onSeek { [_playController onSeek:_playProgress]; }
- (void)onSeekBegin { [_playController onSeekBegin:_playProgress]; }
- (void)onDrag { [_playController onDrag:_playProgress]; }
- (void)dragSliderDidEnd:(UISlider *)slider { [_playController dragSliderDidEnd:_playProgress]; }

#pragma mark - ----------------------- 连麦 -----------------------
- (void)audienceCheckMick
{
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"check_lianmai" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    [SVProgressHUD show];

    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        [SVProgressHUD dismiss];
        if ([responseJson toInt:@"status"] == 1)
        {
            __weak BGIMMsgHandler *wd = _iMMsgHandler;
            FWWeakify(self)
            [FanweMessage alert:nil message:ASLocalizedString(@"是否请求与主播连麦？") destructiveAction:^{
                FWStrongify(self)
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_APPLY_MIKE;
                sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
                [wd sendCustomC2CMsg:sendCustomMsgModel succ:^{
                    [self performSelector:@selector(alertLinkMicking) withObject:nil afterDelay:0.2];
                } fail:^(int code, NSString *msg) {
                    [FanweMessage alertHUD:ASLocalizedString(@"您的连麦申请发送失败")];
                }];
            } cancelAction:^{}];
        }
    } FailureBlock:^(NSError *error) {}];
}

- (BOOL)isInteractUser:(NSString *)userId
{
    if (userId)
    {
        for (NSString *tmpUserId in _linkMicPlayController.linkMemeberSet)
        {
            if ([userId isEqualToString:tmpUserId]) return YES;
        }
    }
    return NO;
}

- (void)openOrCloseMike:(BGLiveServiceController *)liveServiceController
{
    if (_linkMicPlayController.isWaitingResponse)
    {
        [FanweMessage alertHUD:ASLocalizedString(@"连麦申请中...")];
        return;
    }
    if ([self isInteractUser:[[IMAPlatform sharedInstance].host imUserId]])
    {
        FWWeakify(self)
        [FanweMessage alert:nil message:ASLocalizedString(@"是否结束与主播的互动连麦？") destructiveAction:^{
            FWStrongify(self)
            [self.linkMicPlayController stopLinkMic];
            [self.linkMicPlayController startRtmp:self.liveInfo.create_type];
        } cancelAction:^{}];
    }
    else
    {
        [self audienceCheckMick];
    }
}

- (void)refreshUserListVoice {}

- (void)alertLinkMicking
{
    _isApplyMicking = YES;
    FWWeakify(self)
    _applyMickingAlert = [FanweMessage alert:ASLocalizedString(@"提示") message:ASLocalizedString(@"申请连麦中，等待对方应答...") isHideTitle:NO destructiveTitle:ASLocalizedString(@"取消连麦") destructiveAction:^{
        FWStrongify(self)
        self.isApplyMicking = NO;
        [self performSelector:@selector(releaseMickingAlert) withObject:nil afterDelay:0.5];
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
        sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
        [self.iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
    }];
}

- (void)cancelMickingAlert
{
    if (_applyMickingAlert)
    {
        _isApplyMicking = NO;
        [_applyMickingAlert hide];
        [self performSelector:@selector(releaseMickingAlert) withObject:nil afterDelay:0.5];
    }
}

- (void)releaseMickingAlert { _applyMickingAlert = nil; }
- (void)releaseHostMickingAlert { _hostMickingAlert = nil; }

- (void)getMickPara:(CustomMessageModel *)customMessageModel
{
    _isResponseMicking = YES;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"video" forKey:@"ctl"];
    [mDict setObject:@"start_lianmai" forKey:@"act"];
    [mDict setObject:_roomIDStr forKey:@"room_id"];
    [mDict setObject:customMessageModel.sender.user_id forKey:@"to_user_id"];

    __weak typeof(self) ws = self;
    __weak BGIMMsgHandler *wm = (BGIMMsgHandler *)_iMMsgHandler;

    [self.httpsManager POSTWithParameters:mDict SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            NSString *push_rtmp2 = [responseJson toString:@"push_rtmp2"];
            NSString *play_rtmp_acc = [responseJson toString:@"play_rtmp_acc"];
            if (![BGUtils isBlankString:push_rtmp2] && ![BGUtils isBlankString:play_rtmp_acc])
            {
                SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                sendCustomMsgModel.msgType = MSG_RECEIVE_MIKE;
                sendCustomMsgModel.push_rtmp2 = push_rtmp2;
                sendCustomMsgModel.play_rtmp_acc = play_rtmp_acc;
                sendCustomMsgModel.msgReceiver = customMessageModel.sender;
                [wm sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
                [ws.publishController agreeLinkMick:[responseJson toString:@"play_rtmp2_acc"] applicant:customMessageModel.sender.user_id];
            }
            else
            {
                ws.isResponseMicking = NO;
                [FanweMessage alertHUD:ASLocalizedString(@"获取连麦参数失败")];
            }
        }
        else { ws.isResponseMicking = NO; }
    } FailureBlock:^(NSError *error) { ws.isResponseMicking = NO; }];
}

- (void)onRecvGuestApply:(CustomMessageModel *)customMessageModel
{
    SenderModel *sender = customMessageModel.sender;
    if ([_publishController.linkMemeberSet count] >= _micMaxNum || _hostMickingAlert || _isResponseMicking)
    {
        SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
        sendCustomMsgModel.msgType = MSG_REFUSE_MIKE;
        sendCustomMsgModel.msgReceiver = customMessageModel.sender;
        if (_hostMickingAlert || _isResponseMicking)
        {
            sendCustomMsgModel.msg = ASLocalizedString(@"主播有未处理的连麦请求，请稍候再试");
        }
        else
        {
            sendCustomMsgModel.msg = ASLocalizedString(@"当前主播连麦数已上限，请稍后尝试");
        }
        [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
    }
    else
    {
        __weak BGIMMsgHandler *wm = (BGIMMsgHandler *)_iMMsgHandler;
        NSString *text = [NSString stringWithFormat:ASLocalizedString(@"%@向你发来连麦请求"), [sender imUserName]];
        FWWeakify(self)
        _hostMickingAlert = [FanweMessage alert:ASLocalizedString(@"提示") message:text destructiveTitle:ASLocalizedString(@"同意") destructiveAction:^{
            FWStrongify(self)
            [self getMickPara:customMessageModel];
            [self performSelector:@selector(releaseHostMickingAlert) withObject:nil afterDelay:0.2];
        } cancelTitle:ASLocalizedString(@"拒绝") cancelAction:^{
            FWStrongify(self)
            SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
            sendCustomMsgModel.msgType = MSG_REFUSE_MIKE;
            sendCustomMsgModel.msgReceiver = customMessageModel.sender;
            [wm sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
            [self performSelector:@selector(releaseHostMickingAlert) withObject:nil afterDelay:0.2];
        }];
    }
}

- (void)closeAlertView
{
    if (_hostMickingAlert)
    {
        [_hostMickingAlert hide];
        [self performSelector:@selector(releaseHostMickingAlert) withObject:nil afterDelay:0.2];
    }
}

- (void)showRefuseHud:(NSString *)refuseStr { [FanweMessage alert:refuseStr]; }

- (void)pushMickResult:(BOOL)isSucc userID:(NSString *)userID
{
    if (![BGUtils isBlankString:userID])
    {
        if (!isSucc)
        {
            if ([[[IMAPlatform sharedInstance].host imUserId] isEqualToString:userID])
            {
                [BGLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:@""];
            }
            SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
            sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
            sendCustomMsgModel.msgReceiver = [self.liveItem liveHost];
            [_iMMsgHandler sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
        }
    }
}

- (void)playMickResult:(BOOL)isSucc userID:(NSString *)userID
{
    _isResponseMicking = NO;
    if (![BGUtils isBlankString:userID] && isSucc)
    {
        [BGLiveSDKViewModel tLiveMixStream:_roomIDStr toUserId:userID];
    }
}

- (void)hostReceiveTouch:(UITouch *)touch
{
    if ([_publishController.linkMemeberSet count])
    {
        for (NSString *user in _publishController.linkMemeberSet)
        {
            BGTLinkMicPlayItem *playItem = [self.publishController getPlayItemByUserID:user];
            if (playItem && CGRectContainsPoint(playItem.videoView.frame, [touch locationInView:self.publishController.view]))
            {
                UserModel *userModel;
                for (UserModel *tmpModel in _liveServiceController.liveUIViewController.liveView.topView.userArray)
                {
                    if ([tmpModel.user_id isEqualToString:user]) { userModel = tmpModel; break; }
                }
                if (!userModel) { userModel = [[UserModel alloc] init]; userModel.user_id = user; }

                HostCheckMickAlertView *view = [[HostCheckMickAlertView alloc] initAlertView:userModel closeMickBlock:^(UserModel *userModel) {
                    SendCustomMsgModel *sendCustomMsgModel = [[SendCustomMsgModel alloc] init];
                    sendCustomMsgModel.msgType = MSG_BREAK_MIKE;
                    sendCustomMsgModel.msgReceiver = userModel;
                    [[BGIMMsgHandler sharedInstance] sendCustomC2CMsg:sendCustomMsgModel succ:nil fail:nil];
                    [BGLiveSDKViewModel tLiveStopMick:_roomIDStr toUserId:userModel.user_id];
                }];
                [view showWithBlock:^(MMPopupView *popupView, BOOL finished) {}];
            }
        }
    }
}

#pragma mark - ----------------------- 横竖屏 -----------------------
- (void)goVerticalScreen { [self interfaceOrientation:UIInterfaceOrientationPortrait]; }
- (void)clickFullScreen { [self interfaceOrientation:UIInterfaceOrientationLandscapeRight]; }

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)])
    {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)deviceOrientationDidChange
{
    if (self.liveInfo.create_type == 1)
    {
        if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
            [self orientationChange:kDirectionTypeDefault];
        }
        else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft)
        {
            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
            [self orientationChange:kDirectionTypeLeft];
        }
    }
}

- (void)orientationChange:(kDirectionType)landscape
{
    if (landscape == kDirectionTypeDefault)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        _liveServiceController.liveUIViewController.liveView.hidden = NO;
        _liveServiceController.closeBtn.hidden = NO;
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            self.view.bounds = CGRectMake(0, 0, kScreenW, kScreenH);
            if (self.liveType == FW_LIVE_TYPE_RELIVE)
            {
                _playController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = YES;
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                _linkMicPlayController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = YES;
            }
        }];
    }
    else if (landscape == kDirectionTypeLeft)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        _liveServiceController.liveUIViewController.liveView.hidden = YES;
        _liveServiceController.closeBtn.hidden = YES;
        [UIView animateWithDuration:0.2f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.view.bounds = CGRectMake(0, 0, kScreenW, kScreenH);
            if (self.liveType == FW_LIVE_TYPE_RELIVE)
            {
                _playController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = NO;
            }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE)
            {
                _linkMicPlayController.videoContrainerView.frame = CGRectMake(0, 0, kScreenW, kScreenH);
                self.backVerticalBtn.hidden = NO;
            }
        }];
    }
}

#pragma mark - ----------------------- 代理方法 -----------------------
- (void)recvCustomC2C:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]]) return;
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    switch (customMessageModel.type)
    {
        case MSG_APPLY_MIKE:
        {
            [BGUtils closeKeyboard];
            _linkMicPlayController.isWaitingResponse = YES;
            [self onRecvGuestApply:customMessageModel];
        } break;
        case MSG_RECEIVE_MIKE:
        {
            if (_isApplyMicking)
            {
                [BGUtils closeKeyboard];
                if (![BGUtils isBlankString:customMessageModel.push_rtmp2] && ![BGUtils isBlankString:customMessageModel.play_rtmp_acc])
                {
                    [_linkMicPlayController stopRtmp];
                    _linkMicPlayController.push_rtmp2 = customMessageModel.push_rtmp2;
                    _linkMicPlayController.play_rtmp_acc = customMessageModel.play_rtmp_acc;
                    _linkMicPlayController.isWaitingResponse = NO;
                    [_linkMicPlayController startLinkMic];
                    [self cancelMickingAlert];
                }
                else { [FanweMessage alertHUD:ASLocalizedString(@"获取连麦参数失败")]; }
            }
        } break;
        case MSG_REFUSE_MIKE:
        {
            [self cancelMickingAlert];
            _linkMicPlayController.isWaitingResponse = NO;
            NSString *refuseStr = ![BGUtils isBlankString:customMessageModel.msg] ? customMessageModel.msg : ASLocalizedString(@"主播拒绝了您的连麦请求");
            [self showRefuseHud:refuseStr];
        } break;
        case MSG_BREAK_MIKE:
        {
            if (_isHost)
            {
                [self closeAlertView];
                [_publishController breakLinkMick:customMessageModel.sender.user_id];
            }
            else
            {
                [_linkMicPlayController stopLinkMic];
                [_linkMicPlayController startRtmp:self.liveInfo.create_type];
            }
        } break;
        case MSG_ACCEPT_PK:
        case MSG_END_PK:
            [BGUtils closeKeyboard];
            break;
        case MSG_REFRESH_VOICE_ROOM_INFO:
            break;
        default: break;
    }
}

- (void)recvCustomGroup:(id<AVIMMsgAble>)msg
{
    if (![msg isKindOfClass:[CustomMessageModel class]]) return;
    CustomMessageModel *customMessageModel = (CustomMessageModel *)msg;
    switch (customMessageModel.type)
    {
        case MSG_REFRESH_AUDIENCE_LIST:
        {
            if (customMessageModel.data_type == 1)
            {
                TLiveMickListModel *mickListModel = [TLiveMickListModel mj_objectWithKeyValues:customMessageModel.data];
                if (self.liveType == FW_LIVE_TYPE_HOST) { [_publishController adjustPlayItem:mickListModel]; }
                else if (self.liveType == FW_LIVE_TYPE_AUDIENCE) { [_linkMicPlayController adjustPlayItem:mickListModel]; }
            }
        } break;
        case MSG_REFRESH_SEAT_LIST:
        {
            if (![customMessageModel.dicData[@"data"] isKindOfClass:[NSDictionary class]]) break;
            NSMutableArray *list = [NSMutableArray array];
            for (NSDictionary *dic in customMessageModel.dicData[@"data"])
            {
                [list addObject:[Wheat_Type_List mj_objectWithKeyValues:dic]];
            }
            self.liveInfo.wheat_type_list = list;
            [_liveServiceController refreshLiveItem:self.liveItem liveInfo:self.liveInfo];
            self.voiceRoomVC.live_info = self.liveInfo;
            RoomModel *model = [[RoomModel alloc] init];
            model.wheat_type_list = self.liveInfo.wheat_type_list;
            self.voiceRoomVC.model = model;
        } break;
        case MSG_SEND_EMOTION:
        {
            NSMutableArray *list = [NSMutableArray array];
            for (Wheat_Type_List *model in self.liveInfo.wheat_type_list)
            {
                if (customMessageModel.sender.user_id.intValue == model.even_wheat.user_id)
                {
                    model.face_img = customMessageModel.faceUrl;
                }
                [list addObject:model];
            }
            self.liveInfo.wheat_type_list = list;
            [_liveServiceController refreshLiveItem:self.liveItem liveInfo:self.liveInfo];
            self.voiceRoomVC.live_info = self.liveInfo;
            RoomModel *model = [[RoomModel alloc] init];
            model.wheat_type_list = self.liveInfo.wheat_type_list;
            self.voiceRoomVC.model = model;
        } break;
        case MSG_SEND_GIFT_SUCCESS:
            [self.voiceRoomVC.micView sendGift:customMessageModel];
            break;
        case MSG_REFRESH_VOICE_ROOM_INFO:
        {
            NSDictionary *dic = [customMessageModel.dicData mj_JSONObject];
            NSString *voice_bg_image = dic[@"voice"][@"voice_bg_image"];
            if (StrValid(voice_bg_image))
            {
                [self.voiceBackgroundImage sd_setImageWithURL:[NSURL URLWithString:SafeStr(voice_bg_image)]];
            }
        } break;
        default: break;
    }
}

- (void)refreshCurrentLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    [self refreshLiveItem:liveItem liveInfo:liveInfo];
}

- (void)switchLiveRoom
{
    [self stopLiveRtmp];
    // ✅ إصلاح: تمرير nil لـ chatGroupID آمن هنا لأن startEnterChatGroup يجلب الـ group_id من getVideo داخلياً
    [self startEnterChatGroup:nil succ:^{} failed:^(int errId, NSString *errMsg) {}];
}

- (void)clickCloseLive:(BOOL)isDirectCloseLive isHostShowAlert:(BOOL)isHostShowAlert
{
    [self alertExitLive:isDirectCloseLive isHostShowAlert:isHostShowAlert succ:nil failed:nil];
}

- (void)finishViewClose:(BGLiveServiceController *)liveServiceController
{
    UITabBarController *tabBars = [BGTabBarController sharedInstance];
    tabBars.selectedIndex = 0;
    SUS_WINDOW.isDirectCloseLive = YES;
    [self onExitLiveUI];
}

- (void)stopReLive {}

#pragma mark ToolsViewDelegate
- (void)selectToolsItemWith:(ToolsView *)toolsView selectIndex:(NSInteger)index isSelected:(BOOL)isSelected
{
    _toolsView = toolsView;
    if (index == 0)
    {
        if ([GlobalVariables sharedInstance].isOtherPush)
        {
            self.otherPushPopView.liveInfo = self.liveInfo;
            [self.otherPushPopView show:self.view type:FDPopTypeCenter];
        }
        else
        {
            [[[YunMusicPlayVC alloc] init] showYunMusicPlayInVC:self inview:self.liveServiceController.liveUIViewController.liveView showframe:CGRectMake(0, 200, self.view.bounds.size.width, 130) myPlayType:0];
        }
    }
    else if (index == 1)
    {
        NSString *key = [GlobalVariables sharedInstance].appModel.bogo_beauty_key;
        if ([BGUtils isBlankString:key]) { _beautyView.hidden = NO; }
        else { KPostNotification(@"onMainSwitchButtonClick", nil); }
    }
    else if (index == 2)
    {
        _isMuted = !isSelected;
        [[BGHUDHelper sharedInstance] tipMessage:isSelected ? ASLocalizedString(@"已打开麦克风") : ASLocalizedString(@"已关闭麦克风")];
        [_publishController.txLivePublisher setMute:!isSelected];
    }
    else if (index == 3)
    {
        if (!_publishController.txLivePublisher.frontCamera)
        {
            [BGUtils turnOnFlash:NO];
            [toolsView.toolsCollectionView deselectItemAtIndexPath:[NSIndexPath indexPathWithIndex:4] animated:NO];
        }
        [_publishController clickCamera:nil];
    }
    else if (index == 4)
    {
        if (_publishController.txLivePublisher.frontCamera)
        {
            [FanweMessage alert:ASLocalizedString(@"前置摄像头下暂时不能打开闪光灯")];
            return;
        }
        [_publishController clickTorch:isSelected];
    }
    else if (index == 5)
    {
        [FanweMessage alert:isSelected ? ASLocalizedString(@"已打开镜像") : ASLocalizedString(@"已关闭镜像")];
        [_publishController.txLivePublisher setMirror:isSelected];
    }
}

- (void)refreshKBPS:(TCShowLiveTopView *)topView
{
    NSDictionary *tmpDict;
    if ([self.liveItem liveType] == 0) { tmpDict = _publishController.qualityDict; }
    else if ([self.liveItem liveType] == 1) { tmpDict = _playController.qualityDict; }
    else if ([self.liveItem liveType] == 2) { tmpDict = _linkMicPlayController.qualityDict; }

    int totalkb = ([tmpDict toInt:NET_STATUS_VIDEO_BITRATE] + [tmpDict toInt:NET_STATUS_AUDIO_BITRATE]) / 8;
    if (totalkb)
    {
        topView.kbpsSendLabel.hidden = NO;
        topView.kbpsRecvLabel.hidden = YES;
        CGRect newFrame = topView.kbpsSendLabel.frame;
        newFrame.origin.y = CGRectGetHeight(topView.kbpsContainerView.frame) / 4;
        topView.kbpsSendLabel.frame = newFrame;
        topView.kbpsSendLabel.text = [NSString stringWithFormat:@"%@%dk", [self.liveItem liveType] == 0 ? @"↑" : @"↓", totalkb];
    }
    else
    {
        topView.kbpsSendLabel.hidden = YES;
        topView.kbpsRecvLabel.hidden = YES;
    }
}

- (void)firstIFrame:(BGTPublishController *)publishVC
{
    if (!_hasShowVagueImg)
    {
        [self hideVagueImgView];
        [self setCurrentBeautyValue:self.BuguLive.appModel.beauty_ios whiteValue:0];
        SUS_WINDOW.isPushStreamIng = YES;
    }
}

- (void)exitPublishAndApp:(BGTPublishController *)publishVC
{
    [self alertExitLive:NO isHostShowAlert:NO succ:nil failed:nil];
}

- (void)firstFrame:(BGTPlayController *)playVC { [self hideVagueImgView]; }

- (void)playAgain:(BGTPlayController *)publishVC isHideLeaveTip:(BOOL)isHideLeaveTip
{
    if (self.liveType == FW_LIVE_TYPE_RELIVE) { [_playController clickPlay:_btnPlay create_type:self.liveInfo.create_type]; }
    else if (self.liveType == FW_LIVE_TYPE_AUDIENCE) { [_linkMicPlayController startRtmp:self.liveInfo.create_type]; }
    if (!_liveServiceController.anchorLeaveTipLabel.isHidden && isHideLeaveTip)
    {
        _liveServiceController.anchorLeaveTipLabel.hidden = YES;
    }
}

- (void)exitPlayAndApp:(BGTPlayController *)publishVC
{
    [self alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil];
}

- (void)livePayLoadVedioIsComfirm:(BOOL)isComfirm
{
    if (isComfirm)
    {
        if (!self.hasEnterChatGroup)
        {
            [self.linkMicPlayController stopRtmp];
            if (self.liveType == FW_LIVE_TYPE_RELIVE) { [self.publishController.txLivePublisher setMute:NO]; }
            else if (self.liveType == FW_LIVE_TYPE_AUDIENCE) { [self.linkMicPlayController.txLivePlayer setMute:NO]; }
            [self.liveServiceController.liveUIViewController dealLivepayTComfirm];
            FWWeakify(self)
            [self.liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
                FWStrongify(self)
                self.liveInfo = liveInfo;
                [self beginPlayVideo:liveInfo];
                self.hasVideoControl = liveInfo.has_video_control ? YES : NO;
                [super startEnterChatGroup:_liveInfo.group_id succ:nil failed:nil];
            } roomID:@"" failed:^(int errId, NSString *errMsg) {}];
        }
    }
    else { [self alertExitLive:YES isHostShowAlert:NO succ:nil failed:nil]; }
}

- (void)protocolGetVideoWithRoomID:(NSString *)roomID
{
    FWWeakify(self)
    [self.liveServiceController getVideo:^(CurrentLiveInfo *liveInfo) {
        FWStrongify(self)
        if (!liveInfo) return;

        TCShowUser *user = [[TCShowUser alloc] init];
        user.avatar = liveInfo.podcast.user.head_image;
        user.uid = liveInfo.user_id;
        user.username = liveInfo.podcast.user.nick_name;

        TCShowLiveListItem *liveRoom = [[TCShowLiveListItem alloc] init];
        liveRoom.host = user;
        liveRoom.avRoomId = [liveInfo.room_id intValue];
        liveRoom.title = [NSString stringWithFormat:@"%d", liveRoom.avRoomId];
        liveRoom.vagueImgUrl = liveInfo.podcast.user.head_image;
        liveRoom.liveType = SUS_WINDOW.liveType;
        liveRoom.isHost = NO;

        _liveServiceController.liveUIViewController.liveScrollView.roomID = liveInfo.room_id;
        [_liveServiceController.liveUIViewController.liveView refreshLiveItem:liveRoom liveInfo:liveInfo];

        self.liveInfo = liveInfo;
        [self beginPlayVideo:liveInfo];
        self.hasVideoControl = liveInfo.has_video_control ? YES : NO;

        _linkMicPlayController.videoContrainerView.top = 0;
        _liveServiceController.liveUIViewController.liveScrollView.top = 0;
        _firstImgView.top = _linkMicPlayController.videoContrainerView.bottom;
        _secondImgView.top = _firstImgView.bottom;

        [FanweMessage alert:ASLocalizedString(@"切换直播间成功!")];
        [super startEnterChatGroup:liveInfo.group_id succ:nil failed:nil];
    } roomID:roomID failed:^(int errId, NSString *errMsg) {}];
}

- (void)voiceNotice:(NSNotification *)notification
{
    NSMutableDictionary *dictM = [notification object];
    if ([dictM toInt:@"type"] == 0) { [self setSDKMute:YES]; }
    else if ([dictM toInt:@"type"] == 1) { [self setSDKMute:NO]; }
}

#pragma mark - ----------------------- FWLiveControllerAble -----------------------
- (void)startLiveRtmp:(NSString *)playUrlStr
{
    if (![BGUtils isBlankString:playUrlStr])
    {
        if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST)
        {
            _publishController.pushUrlStr = playUrlStr;
            if (![GlobalVariables sharedInstance].isOtherPush) { [_publishController startRtmp]; }
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            _playController.playUrlStr = playUrlStr;
            [_playController clickPlay:_btnPlay create_type:self.liveInfo.create_type];
            _playController.play_switch = NO;
        }
        else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE)
        {
            _linkMicPlayController.playUrlStr = playUrlStr;
            [_linkMicPlayController startRtmp:self.liveInfo.create_type];
        }
    }
}

- (void)stopLiveRtmp
{
    if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST) { [_publishController stopRtmp]; }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE) { [_playController stopRtmp]; }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE) { [_linkMicPlayController stopRtmp]; }
}

- (void)hideReLiveSlide:(BOOL)isHided
{
    if (isHided) { _reLiveProgressView.hidden = YES; }
    else if (self.hasVideoControl) { _reLiveProgressView.hidden = NO; }
}

#pragma mark - ----------------------- 美颜 -----------------------
- (void)setBeauty:(BGTLiveBeautyView *)beautyView withBeautyName:(NSString *)beautyName
{
    if (_publishController.txLivePublisher)
    {
        if (![BGUtils isBlankString:beautyName])
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"FilterResource" ofType:@"bundle"];
            if (path && ![beautyName isEqualToString:ASLocalizedString(@"普通美颜")])
            {
                path = [path stringByAppendingPathComponent:beautyName];
                [_publishController.txLivePublisher setFilter:[UIImage imageWithContentsOfFile:path]];
            }
            else if ([beautyName isEqualToString:ASLocalizedString(@"普通美颜")])
            {
                [_publishController.txLivePublisher setFilter:nil];
            }
        }
        else
        {
            [_publishController.txLivePublisher setFilter:nil];
            [self setCurrentBeautyValue:0 whiteValue:0];
        }
    }
}

- (void)setBeautyValue:(BGTLiveBeautyView *)beautyView
{
    if (_publishController.txLivePublisher)
    {
        [_publishController.txLivePublisher setBeautyStyle:0 beautyLevel:beautyView.filterParam1.slider.value / 10 whitenessLevel:beautyView.filterParam2.slider.value / 10 ruddinessLevel:0];
    }
}

- (void)setCurrentBeautyValue:(float)beautyDepth whiteValue:(float)whiteDepth
{
    _beautyView.filterParam1.slider.value = beautyDepth;
    _beautyView.filterParam2.slider.value = whiteDepth;
    [_beautyView.filterParam1 updateValue];
    [_beautyView.filterParam2 updateValue];
    [self setBeautyValue:_beautyView];
}

#pragma mark - ----------------------- 其他 -----------------------
- (NSString *)getLiveQuality
{
    NSDictionary *tmpDict = ([self.liveItem liveType] == 0) ? _publishController.qualityDict : _playController.qualityDict;
    NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
    [mDict setObject:@"Ios" forKey:@"device"];
    if ([tmpDict toFloat:NET_STATUS_CPU_USAGE_D]) { [mDict setObject:[NSString stringWithFormat:@"%f", [tmpDict toFloat:NET_STATUS_CPU_USAGE_D] * 100] forKey:@"appCPURate"]; }
    if ([tmpDict toFloat:NET_STATUS_CPU_USAGE]) { [mDict setObject:[NSString stringWithFormat:@"%f", [tmpDict toFloat:NET_STATUS_CPU_USAGE] * 100] forKey:@"sysCPURate"]; }
    if ([tmpDict toString:NET_STATUS_VIDEO_FPS]) { [mDict setObject:[tmpDict toString:NET_STATUS_VIDEO_FPS] forKey:@"fps"]; }

    int totalkbps = [tmpDict toInt:NET_STATUS_VIDEO_BITRATE] + [tmpDict toInt:NET_STATUS_AUDIO_BITRATE];
    int totalkb = totalkbps / 8;
    if (totalkb)
    {
        [mDict setObject:StringFromInt(totalkb) forKey:([self.liveItem liveType] == 0) ? @"sendKBps" : @"recvKBps"];
    }

    int netSpeed = [tmpDict toInt:NET_STATUS_NET_SPEED];
    if (netSpeed == 0) { netSpeed = 1; }
    float loss_rate_send = (netSpeed - totalkbps) / (float)netSpeed;

    [mDict setObject:[NSString stringWithFormat:@"%f", loss_rate_send] forKey:([self.liveItem liveType] == 0) ? @"sendLossRate" : @"recvLossRate"];

    if (loss_rate_send <= 0.2) { _lossRateSendTipLabel.hidden = YES; }
    else if (loss_rate_send < 0.3) { _lossRateSendTipLabel.hidden = NO; _lossRateSendTipLabel.text = kHostNetLowTip1; _lossRateSendTipLabel.textColor = kYellowColor; }
    else { _lossRateSendTipLabel.hidden = NO; _lossRateSendTipLabel.text = kHostNetLowTip2; _lossRateSendTipLabel.textColor = kRedColor; }

    NSString *sendMessage = [BGUtils dataTOjsonString:mDict];
    return sendMessage ?: @"";
}

- (UIView *)getPlayViewBottomView
{
    if ([self.liveItem liveType] == FW_LIVE_TYPE_HOST) { return _publishController.view; }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE) { return _playController.view; }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE) { return _linkMicPlayController.view; }
    return nil;
}

- (void)setSDKMute:(BOOL)bEnable
{
    if ([self.liveItem liveType] == FW_LIVE_TYPE_RELIVE) { [self.playController.txLivePlayer setMute:bEnable]; }
    else if ([self.liveItem liveType] == FW_LIVE_TYPE_AUDIENCE) { [self.linkMicPlayController.txLivePlayer setMute:bEnable]; }
}

- (void)volumeChanged:(NSNotification *)noti
{
    NSDictionary *tmpDict = noti.userInfo;
    if (tmpDict && [tmpDict isKindOfClass:[NSDictionary class]])
    {
        if ([[tmpDict toString:@"AVSystemController_AudioVolumeChangeReasonNotificationParameter"] isEqualToString:@"ExplicitVolumeChange"] && !_isMuted)
        {
            float volume = [[tmpDict objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
            [_publishController.txLivePublisher setMute:(volume <= 0.062500)];
        }
    }
}

- (BGOtherPushPopView *)otherPushPopView
{
    if (!_otherPushPopView)
    {
        _otherPushPopView = [[NSBundle mainBundle] loadNibNamed:@"BGOtherPushPopView" owner:nil options:nil].lastObject;
    }
    return _otherPushPopView;
}

// ✅ إصلاح dealloc: تحرير الـ timer + مغادرة channel + تدمير agoraKit + إزالة الـ observers
- (void)dealloc
{
    [self releaseTimer];
    if (self.agoraKit)
    {
        [self.agoraKit leaveChannel:nil];
        [AgoraRtcEngineKit destroy];
        self.agoraKit = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ----------------------- Agora -----------------------
- (void)initializeAgoraEngine
{
    // ✅ nil check: التأكد من وجود الـ appId قبل إنشاء الـ engine
    NSString *appId = [GlobalVariables sharedInstance].appModel.agora_app_id;
    if ([BGUtils isBlankString:appId]) return;

    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithAppId:appId delegate:self];
    if (!self.agoraKit) return;

    [self.agoraKit enableAudioVolumeIndication:1000 smooth:3 report_vad:YES];
    [self needOpenRTCAudio:NO];
    [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting];
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
    [self.agoraKit enableLocalVideo:NO];
}

- (void)setChannelProfile
{
    if (self.agoraKit) { [self.agoraKit setChannelProfile:AgoraChannelProfileLiveBroadcasting]; }
}

- (void)setClientRole
{
    if (self.agoraKit) { [self.agoraKit setClientRole:AgoraClientRoleBroadcaster]; }
}

- (void)setupLocalVideo {}

- (void)joinChannel:(NSString *)room_id
{
    // ✅ nil check على agoraKit + التأكد من وجود room_id
    if (!self.agoraKit || [BGUtils isBlankString:room_id]) return;

    // ✅ إصلاح: استخدام integerValue بدل intValue لتجنب overflow على أجهزة 64-bit
    NSUInteger uid = (NSUInteger)[[IMAPlatform sharedInstance].host.userId integerValue];
    int status = [self.agoraKit joinChannelByToken:self.agora_token channelId:room_id info:nil uid:uid joinSuccess:^(NSString *channel, NSUInteger uid, NSInteger elapsed) {
        NSLog(@"加入声网房间成功");
    }];
    NSLog(@"声网 status %d", status);
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine reportAudioVolumeIndicationOfSpeakers:(NSArray<AgoraRtcAudioVolumeInfo *> *)speakers totalVolume:(NSInteger)totalVolume
{
    if (!self.voiceRoomVC.model.wheat_type_list.count) return;

    NSMutableArray<Wheat_Type_List *> *wheat_type_list = [NSMutableArray arrayWithArray:self.voiceRoomVC.model.wheat_type_list];
    for (int i = 0; i < wheat_type_list.count; i++)
    {
        Wheat_Type_List *info = wheat_type_list[i];
        if (!info.even_wheat.user_id) continue;

        for (AgoraRtcAudioVolumeInfo *speaker in speakers)
        {
            // ✅ إصلاح: مقارنة صريحة بين NSUInteger وNSInteger بعد casting لتجنب signed/unsigned mismatch
            if (speaker.uid == 0 || (NSUInteger)info.even_wheat.user_id == speaker.uid)
            {
                info.totalVolume = speaker.volume;
            }
        }
        wheat_type_list[i] = info;
    }
    self.voiceRoomVC.model.wheat_type_list = wheat_type_list;
    [self.voiceRoomVC setModel:self.voiceRoomVC.model];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {}

- (void)playMusicClicked:(NSNotification *)nofit
{
    // ✅ nil check على agoraKit
    if (!self.agoraKit) return;

    [self releaseTimer];
    _agoraPlayTime = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getAgoraTimer) userInfo:nil repeats:YES];

    musiceModel *model = nofit.object;
    if (!model) return;

    int ret = [self.agoraKit startAudioMixing:model.url loopback:NO replace:NO cycle:1];
    NSLog(ret < 0 ? @"播放音乐失败" : @"播放成功");
}

- (void)getAgoraTimer
{
    if (!self.agoraKit) return;

    // ✅ إصلاح: التحقق من أن duration > 0 قبل القسمة لتجنب division by zero
    float duration = [self.agoraKit getAudioMixingDuration];
    float position = [self.agoraKit getAudioMixingCurrentPosition];
    float perct = (duration > 0) ? (position / duration) : 0.0f;
    self.liveServiceController.liveUIViewController.musicVC.playerView.songSlider.value = perct;
    NSInteger positionSecs = (NSInteger)(position / 1000);
    NSString *time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",
                      (long)(positionSecs / 3600),
                      (long)(positionSecs % 3600 / 60),
                      (long)(positionSecs % 60)];
    self.liveServiceController.liveUIViewController.musicVC.playerView.songTimeLabel.text = time;
}

- (void)stopMusic
{
    // ✅ nil check على agoraKit
    if (self.agoraKit) { [self.agoraKit stopAudioMixing]; }
    [self releaseTimer];
    self.liveServiceController.liveUIViewController.musicVC.playMusicId = @"";
    [self.liveServiceController.liveUIViewController.musicVC.mtableview reloadData];
    self.liveServiceController.liveUIViewController.musicVC.playerView.songSlider.value = 0;
    self.liveServiceController.liveUIViewController.musicVC.playerView.songTimeLabel.text = @"00:00:00";
}

- (void)rtcEngineLocalAudioMixingDidFinish:(AgoraRtcEngineKit *)engine { [self stopMusic]; }

- (void)releaseTimer
{
    if (_agoraPlayTime)
    {
        [_agoraPlayTime invalidate];
        _agoraPlayTime = nil;
    }
}

- (void)clickRoomManage
{
    RoomSetViewController *vc = [[RoomSetViewController alloc] init];
    vc.model = self.liveInfo;
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)voiceLiveAudienceChanged:(NSNotification *)nofit
{
    NSString *audience = nofit.userInfo[@"audience"];
    [self.voiceRoomVC.roomTopView.btnAnnouncement setTitle:[NSString stringWithFormat:ASLocalizedString(@"%@ 在线"), audience] forState:UIControlStateNormal];
}

@end