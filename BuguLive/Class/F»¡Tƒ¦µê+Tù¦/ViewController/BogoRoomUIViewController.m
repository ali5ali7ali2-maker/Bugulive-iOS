//
//  BogoRoomUIViewController.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/4/7.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "BogoRoomUIViewController.h"
#import "RoomLiveMicView.h"
#import <YYKit/YYKit.h>
#import "RoomModel.h"
#import "VoiceHTTPManger.h"
#import "RoomUserInfo.h"
#import "BGRoomMicManageCell.h"
#import "RoomUserListView.h"
@interface BogoRoomUIViewController ()<RoomMicUserListViewDelegate>
@property(nonatomic, strong) VoiceHTTPManger *voiceApi;

@end

@implementation BogoRoomUIViewController

#pragma mark - LifeCycle
- (void)dealloc {
    [self removeNotificationObserver];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    [self setupNavBar];
    
    //设置view
    [self setupView];
   
    //请求数据
    [self requestData];
    
    //添加通知
    [self addNotificationObserver];
    
    
}

#pragma mark - View
- (void)setupNavBar {
    
}

- (void)showMicView {
    
    __weak __typeof(self)weakSelf = self;
    
//    [self.voiceApi requestWheatListType:@"0" block:^(NSDictionary *selfPtr) {
//        NSMutableArray *dataArr = [NSMutableArray modelArrayWithClass:RoomUserInfo.class json:selfPtr[@"data"]];
//        weakSelf.userListView.dataArray = dataArr;
    weakSelf.userListView.voiceApi = self.voiceApi;
        [weakSelf.userListView show:weakSelf.supperView];
//    }];
}
- (void)setupView {
    self.view.userInteractionEnabled = YES;
    [self.view addSubview:self.roomTopView];
    [self.view addSubview:self.micView];
    
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
    view.tag = 100000;
    
    [GlobalVariables sharedInstance].voiceGiftView = view;
    view.backgroundColor = kClearColor;
    view.userInteractionEnabled = NO;
}

- (BGVoiceRoomTopView *)roomTopView
{
    if(!_roomTopView)
    {
        _roomTopView = [BGVoiceRoomTopView getView];
        _roomTopView.frame = CGRectMake(0, 0, self.view.width, 300);
    }
    return _roomTopView;
}

- (RoomLiveMicView *)micView{
    if (!_micView) {
        _micView = [[RoomLiveMicView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight + NavigationBarHeight, kScreenW, 330+30+20+20+115)];
        _micView.delegate = self;
        _micView.userInteractionEnabled = YES;
    }
    return _micView;
}
- (void)setLive_info:(CurrentLiveInfo *)live_info
{
    _live_info = live_info;
    self.roomTopView.liveInfo = live_info;
    self.voiceApi = [[VoiceHTTPManger alloc] init];
    self.voiceApi.live_info = live_info;
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 需要延迟执行的代码
        
//        [self.voiceApi requestBanVoice:@"" toUserID:[IMAPlatform sharedInstance].host.userId second:@"1" block:^(id selfPtr) {
//
//        }];
    });

    
}
#pragma mark - RoomLiveMicViewDelegate
- (void)micView:(RoomLiveMicView *)micView didClickLinkBtnIndex:(NSInteger)index{

    
    __weak __typeof(self)weakSelf = self;
    Wheat_Type_List *model = self.model.wheat_type_list[index];

    

    
    //如果是个人就下麦
    if (self.live_info.user_id.intValue  == [IMAPlatform sharedInstance].host.userId.intValue) {
        FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"" message:@""];

        
        //如果是个人就下model
        if (model.even_wheat.user_id  == [IMAPlatform sharedInstance].host.userId.intValue) {
            

            
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"下麦")  type:FDActionTypeDefault CallBack:^{
                [weakSelf.voiceApi requestUpdWheatUser:model.wheat_id toUserID:[IMAPlatform sharedInstance].host.userId status:@"3" block:^(id selfPtr) {
    //                [weakSelf openAudio:NO];
                }];
            }]];
            
            //判断是否开麦
            if(model.even_wheat.is_ban_voice == 1)
            {
                [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"打开麦克风") type:FDActionTypeDefault CallBack:^{
                   
                    
                    [self.voiceApi requestBanVoice:@"" toUserID:[IMAPlatform sharedInstance].host.userId second:@"0" block:^(id selfPtr) {

                    }];
                    
                }]];
            }
            else
            {
                [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"关闭麦克风") type:FDActionTypeDefault CallBack:^{
              
                    [self.voiceApi requestBanVoice:@"" toUserID:[IMAPlatform sharedInstance].host.userId second:@"1" block:^(id selfPtr) {

                    }];
                    
                }]];
            }
            
            
        } else {
            
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"上麦") type:FDActionTypeDefault CallBack:^{
                [self requestApplyWheatWithId:model.wheat_id];
            }]];

        }
        

        
        
        
        //设置麦位
        
        if(model.type == 0)
        {
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"设置申请上麦") type:FDActionTypeDefault CallBack:^{
                [weakSelf.voiceApi setWheatApplyTypeWheatId:model.wheat_id type:@"1" block:^(id selfPtr) {
                    
                }];
            }]];
        }
        else if(model.type == 1)
        {
            [actionSheet addAction:[FDAction actionWithTitle:@"设置直接上麦" type:FDActionTypeDefault CallBack:^{
                [weakSelf.voiceApi setWheatApplyTypeWheatId:model.wheat_id type:@"0" block:^(id selfPtr) {
                    
                }];
            }]];
        }
        

        
        [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:^{
            
        }]];
      
        [actionSheet show:[UIApplication sharedApplication].keyWindow];

        
        
    } else {

        //如果是自己或者管理员的
        [self requestApplyWheatWithId:model.wheat_id];
    }
    

    
    
    
    
    

}

- (void)micViewdidClickRoomTrueLove
{
    NSLog(@"点击了真爱榜单");
    
    NSString *tmpUrlStr = [NSString stringWithFormat:@"%@&room_id=%@&to_uid=%@",[GlobalVariables sharedInstance].appModel.h5_url.video_ranking_url,self.live_info.room_id,self.live_info.user_id];
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
            appearance.backgroundEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
        appearance.backgroundColor = kWhiteColor;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
     }
    
    [self.navigationController pushViewController:tmpController animated:NO];
//    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
    
//    video_ranking_url
}

- (void)requestApplyWheatWithId:(NSString *)id {
    [self.voiceApi requestApplyWheat:id block:^(NSDictionary *selfPtr) {

    }];
}

- (void)openAudio:(BOOL)isOpen {
    if([self.delegate respondsToSelector:@selector(needOpenRTCAudio:)])
    {
        [self.delegate needOpenRTCAudio:isOpen];
    }
}

- (void)micView:(RoomLiveMicView *)micView didClickNumberBtn:(UIButton *)sender
{
    RoomUserListView *listView = [[RoomUserListView alloc] initWithFrame:CGRectMake(0, kScreenH, kScreenW, kScreenH/2)];
//    listView.frame =
    listView.room_id = self.live_info.room_id;
    [listView show:self.view.superview];
    listView.delegate = self;
}

- (void)listView:(RoomUserListView *)listView didSelectUser:(RoomUserInfo *)user
{
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = user.user_id;
    userModel.nick_name = user.nick_name;
    userModel.head_image = user.head_image;
    userModel.user_level = user.level;
    
    [self.delegate clickUser:userModel];

//    [self getUserInfo:userModel];
}

- (void)micView:(RoomLiveMicView *)micView didClickUser:(Wheat_Type_List *)info{
    
    __weak __typeof(self)weakSelf = self;
    FDActionSheet *actionSheet = [[FDActionSheet alloc] initWithTitle:@"" message:@""];
    [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"查看资料")  type:FDActionTypeDefault CallBack:^{
        
        
        UserModel *model = [[UserModel alloc] init];
        model.user_id = StringFromInt(info.even_wheat.user_id);
        model.nick_name = info.even_wheat.nick_name;
        model.head_image = info.even_wheat.head_image;
        [self.delegate clickUser:model];
        
//        SHomePageVC *tmpController= [[SHomePageVC alloc]init];
//        tmpController.user_id = [NSString stringWithFormat:@"%d",info.even_wheat.user_id];
//        tmpController.type = 0;
//        [[AppDelegate sharedAppDelegate]pushViewController:tmpController animated:YES];
    }]];
    
    //如果是个人就下麦
    if (info.even_wheat.user_id  == [IMAPlatform sharedInstance].host.userId.intValue) {
        
        
        [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"下麦") type:FDActionTypeDefault CallBack:^{
            [weakSelf.voiceApi requestUpdWheatUser:info.wheat_id toUserID:[IMAPlatform sharedInstance].host.userId status:@"3" block:^(id selfPtr) {
//                [weakSelf openAudio:NO];
            }];
        }]];
        
        //判断是否开麦
        if(info.even_wheat.is_ban_voice == 1)
        {
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"打开麦克风") type:FDActionTypeDefault CallBack:^{
               
                
                [self.voiceApi requestBanVoice:@"" toUserID:[IMAPlatform sharedInstance].host.userId second:@"0" block:^(id selfPtr) {

                }];
                
            }]];
        }
        else
        {
            [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"关闭麦克风") type:FDActionTypeDefault CallBack:^{
          
                [self.voiceApi requestBanVoice:@"" toUserID:[IMAPlatform sharedInstance].host.userId second:@"1" block:^(id selfPtr) {

                }];
                
            }]];
        }
        
        
    } else {

    }
    
    [actionSheet addAction:[FDAction actionWithTitle:ASLocalizedString(@"取消") type:FDActionTypeCancel CallBack:^{
        
    }]];
    
    
//    [actionSheet show:[UIApplication sharedApplication].delegate.window];
    [actionSheet show:[UIApplication sharedApplication].keyWindow];
    

}

- (RoomMicUserListView *)userListView{
    if (!_userListView) {
        _userListView = [[RoomMicUserListView alloc]initWithFrame:CGRectMake(kScreenW, kScreenH - 300 - (IPHONE_X ? 34 : 0), self.view.width, 300 + (IPHONE_X ? 34 : 0))];
        _userListView.delegate = self;
        _userListView.vc = self;
    }
    return _userListView;
}

//抱上下麦
- (void)userListView:(RoomMicUserListView *)userListView manageCell:(BGRoomMicManageCell *)messageCell didClickManageBtn:(UIButton *)sender{
    __weak __typeof(self)weakSelf = self;

     
    if(messageCell.type == RoomMicManageCellTypeApplyList)
    {
        
        NSString *type = @"0";
        if([sender.titleLabel.text isEqualToString:@"同意上麦"])
        {
            type = @"1";
        }
        else if([sender.titleLabel.text isEqualToString:@"拒绝上麦"])
        {
            type = @"2";
        }
        
        //同意上麦
        [self.voiceApi requestUpdWheatUser:@"" toUserID:messageCell.model.user_id status:type block:^(id selfPtr) {
            [weakSelf.userListView hide];
        }];
    }
    else if(messageCell.type == RoomMicManageCellTypeManageView)
    {
        if([sender.titleLabel.text isEqualToString:@"抱下麦"])
        {
            //抱下麦
            [self.voiceApi requestUpdWheatUser:@"" toUserID:messageCell.model.user_id status:@"3" block:^(id selfPtr) {
                [weakSelf.userListView hide];
            }];
        }
        else
        {
            //关麦
            NSString *status = @"1";
            if(sender.selected)
            {
                status = @"0";
            }
            
            [self.voiceApi requestBanVoice:@"" toUserID:messageCell.model.user_id second:status block:^(id selfPtr) {
                sender.selected = !sender.selected;
            }];
        }
    }
}

- (void)micView:(RoomLiveMicView *)micView didClickShareBtn:(QMUIButton *)sender{
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(uicontroller:micView:didClickShareBtn:)]) {
//          [self.delegate uicontroller:self micView:micView didClickShareBtn:sender];
//      }
//
    
}


- (void)micView:(RoomLiveMicView *)micView didClickAnnouncementBtn:(UIButton *)sender
{
    NSLog(@"点击了公告");
    [self.delegate micView:micView didClickAnnouncementBtn:sender];
}

#pragma mark - Network
- (void)requestData {
//    NSDictionary *dic = [self getJsonDataJsonname:@"room_json"];
//    RoomModel *model = [RoomModel mj_objectWithKeyValues:dic];
////    RoomModel *model = [RoomModel]
//    NSLog(@"%@",dic);
}

- (void)setModel:(RoomModel *)model
{
    _model = model;
    [self.micView setModel:model];

    
}

-(id)getJsonDataJsonname:(NSString *)jsonname
{
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonname ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (!jsonData || error) {
        //DLog(@"JSON解码失败");
        return nil;
    } else {
        return jsonObj;
    }
}

#pragma mark- Delegate
#pragma mark UITableDatasource & UITableviewDelegate


#pragma mark - Private


#pragma mark - Event


#pragma mark - Public


#pragma mark - NSNotificationCenter
- (void)addNotificationObserver {
    
}

- (void)removeNotificationObserver {
    
}

#pragma mark - Setter


#pragma mark - Getter


#pragma mark - MemoryWarning
- (void)didReceiveMemoryWarning {
    
}

@end
