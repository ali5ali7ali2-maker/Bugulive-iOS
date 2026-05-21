//
//  TCShowLiveTopView.m
//  TCShow
//
//  Created by AlexiChen on 16/4/14.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "TCShowLiveTopView.h"

#pragma mark - ----------------------- 内部类 TCShowLiveTimeView -----------------------
@implementation TCShowLiveTimeView
{
}
- (void)dealloc
{
    NSLog(@"11");
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _liveItem = liveItem;
        _isHost = [liveItem isHost];
        
        [self addOwnViews];
        [self configOwnViews];
        self.backgroundColor = kGrayTransparentColor2;
        self.layer.cornerRadius = kLogoContainerViewHeight/2;
        self.layer.masksToBounds = YES;
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];
        
        
        
    }
    return self;
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    _isHost = [liveItem isHost];
    _roomId.text = [NSString stringWithFormat:@"ID:%@",liveInfo.user_id];
    if(liveInfo.luck_num.intValue > 0)
    {
        self.roomId.text = [NSString stringWithFormat:@"ID:%@",liveInfo.luck_num];
    }
    
    [self setHostVIcon:liveInfo];
}

- (void)addOwnViews
{
    _hostHeadBtn = [[MenuButton alloc] init];
    _hostHeadBtn.layer.masksToBounds = YES;
    [self addSubview:_hostHeadBtn];
    
    _hostVImgView = [[UIImageView alloc]init];
    [self addSubview:_hostVImgView];
    
    _liveTitle = [[UILabel alloc] init];
    _liveTitle.userInteractionEnabled = YES;
    _liveTitle.font = kAppSmallerTextFont;
    _liveTitle.textAlignment = NSTextAlignmentCenter;
    _liveTitle.textColor = kWhiteColor;
    _liveTitle.text = ASLocalizedString(@"加载中...");
    [self addSubview:_liveTitle];
    
    _liveAudience = [[UILabel alloc] init];
    _liveAudience.userInteractionEnabled = YES;
    _liveAudience.font = kAppSmallerTextFont;
    _liveAudience.textAlignment = NSTextAlignmentCenter;
    _liveAudience.textColor = kWhiteColor;
    _liveAudience.text = @"0";
    _liveAudience.hidden = YES;
    [self addSubview:_liveAudience];
    
    _roomId = [[UILabel alloc] init];
    _roomId.userInteractionEnabled = YES;
    _roomId.font = kAppSmallerTextFont;
    _roomId.textAlignment = NSTextAlignmentCenter;
    _roomId.textColor = kWhiteColor;
    _roomId.text = @"";
    [self addSubview:_roomId];

    _liveFollow = [[UIButton alloc] init];
    _liveFollow.titleLabel.font = kAppSmallerTextFont;
    _liveFollow.backgroundColor = RGB(118, 59, 243);
    [_liveFollow setTitleColor:kWhiteColor forState:UIControlStateNormal];
    [_liveFollow setTitle:ASLocalizedString(@"关注")forState:UIControlStateNormal];
//    [_liveFollow setBackgroundImage:[UIImage imageNamed:@"bogo_live_topUser_concert"] forState:UIControlStateNormal];
    _liveFollow.layer.masksToBounds = YES;
    
    
    [self addSubview:_liveFollow];
}

#pragma mark 设置主播认证图标

- (void)setHostVIcon:(CurrentLiveInfo *)currentLiveInfo
{
    if ([currentLiveInfo.podcast.user.is_authentication intValue] == 2)
    {
        NSString *vIcon = currentLiveInfo.podcast.user.v_icon;
        
        _hostVImgView.hidden = YES;
//        if (vIcon && ![vIcon isEqualToString:@""])
//        {
//            _hostVImgView.hidden = NO;
//        _hostVImgView.backgroundColor = kRedColor;
//            [_hostVImgView sd_setImageWithURL:[NSURL URLWithString:vIcon]];
//        }
//        else
//        {
//            _hostVImgView.hidden = YES;
//        }
    }
}

- (void)configOwnViews
{
    NSString *url = [[_liveItem liveHost] imUserIconUrl];
    [_hostHeadBtn sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
}

- (void)relayoutFrameOfSubViews
{
    [_hostHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(2);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kLogoContainerViewHeight-4, kLogoContainerViewHeight-4));
    }];
    _hostHeadBtn.layer.cornerRadius = (kLogoContainerViewHeight-4)/2;
    
    [_hostVImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.bottom.equalTo(_hostHeadBtn);
        make.size.mas_equalTo(CGSizeMake(kViconWidthOrHeight, kViconWidthOrHeight));
    }];
    
    [_liveTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_hostHeadBtn.mas_trailing);
        make.top.equalTo(self);
        make.width.mas_equalTo(kLiveStatusViewWidth);
        make.height.mas_equalTo(kLogoContainerViewHeight/2);
    }];
    
    [_liveAudience mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_hostHeadBtn.mas_trailing);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(kLiveStatusViewWidth);
        make.height.mas_equalTo(kLogoContainerViewHeight/2);
    }];
    
    [_roomId mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_hostHeadBtn.mas_trailing);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(kLiveStatusViewWidth);
        make.height.mas_equalTo(kLogoContainerViewHeight/2);
    }];

    [_liveFollow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_liveAudience.mas_trailing);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(kFollowBtnWidth);
        make.height.mas_equalTo(22);
    }];
    _liveFollow.layer.cornerRadius = 11;

}

- (void)onImUsersEnterLive
{
    NSString *audience = _liveAudience.text;
    if (audience && ![audience isEqualToString:@""])
    {
        audience = StringFromInt([audience intValue]+1);
    }
    else
    {
        audience = @"1";
    }
    
    _liveAudience.text = audience;
    NSLog(@"number ---++%@",_liveAudience.text);
    //通过通知发送人数变更 audience
    [[NSNotificationCenter defaultCenter] postNotificationName:kLiveAudienceChangedNotification object:nil userInfo:@{@"audience":audience}];
    
    
}

- (void)onImUsersExitLive
{
    NSString *audience = _liveAudience.text;
    if (audience && ![audience isEqualToString:@""] && [audience intValue])
    {
        audience = StringFromInt([audience intValue]-1);
    }
    else
    {
        audience = @"0";
    }
    _liveAudience.text = audience;
    NSLog(@"number --- >>%@",_liveAudience.text);
    [[NSNotificationCenter defaultCenter] postNotificationName:kLiveAudienceChangedNotification object:nil userInfo:@{@"audience":audience}];

}

@end


#pragma mark - ----------------------- 内部类 LiveUserViewCell -----------------------
@interface LiveUserViewCell : UICollectionViewCell
{
    MenuButton        *_userIcon;
    UIImageView       *_vImgView;
}

@property (nonatomic, readonly) MenuButton *userIcon;
@property (nonatomic, readonly) UIImageView *vImgView;//守护图标

@property(nonatomic, strong) UIImageView *nobleImgView;

@property(nonatomic, strong) UILabel *titleL;

@property(nonatomic, assign) NSInteger indexRow;

@end

@implementation LiveUserViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _userIcon = [[MenuButton alloc] init];
        _userIcon.clipsToBounds = YES;
        _userIcon.backgroundColor = [UIColor clearColor];
        _userIcon.layer.cornerRadius = kLogoContainerViewHeight/2;
        _userIcon.layer.masksToBounds = YES;
        _userIcon.userInteractionEnabled = YES;
        [self.contentView addSubview:_userIcon];
        
        
        
        _nobleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(-5, -2.5, kLogoContainerViewHeight + 2.5, kLogoContainerViewHeight + 2.5)];
//        _nobleImgView.layer.cornerRadius = kViconWidthOrHeight/2;
//        _nobleImgView.layer.masksToBounds = YES;
        _nobleImgView.image = [UIImage imageNamed:@"bogo_noble_live_headIcon"];
        [self.contentView addSubview:_nobleImgView];
        
        _vImgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-kViconWidthOrHeight, frame.size.height-kViconWidthOrHeight, kViconWidthOrHeight, kViconWidthOrHeight)];
        _vImgView.layer.cornerRadius = kViconWidthOrHeight/2;
        _vImgView.layer.masksToBounds = YES;
        _vImgView.image = [UIImage imageNamed:@""];
        [self.contentView addSubview:_vImgView];
        
        _titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kLogoContainerViewHeight, kRealValue(14))];
        _titleL.backgroundColor = [UIColor colorWithHexString:@"#C28CF8"];
        _titleL.textColor = kWhiteColor;
        _titleL.font = [UIFont systemFontOfSize:10];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.layer.cornerRadius = kRealValue(14 / 2);
        _titleL.layer.masksToBounds = YES;
        _titleL.alpha = 0.8;
        [self.contentView addSubview:_titleL];
        
    }
    return self;
}

- (void)setIndexRow:(NSInteger)indexRow{
    
    _titleL.alpha = 0.8;
    if (indexRow == 0) {
        self.titleL.backgroundColor = [UIColor colorWithHexString:@"#C28CF8"];
    }else if (indexRow == 1){
        self.titleL.backgroundColor = [UIColor colorWithHexString:@"#8EC5FF"];
    }else if (indexRow == 2){
        self.titleL.backgroundColor = [UIColor colorWithHexString:@"#C39346"];
    }else{
        self.titleL.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        _titleL.alpha = 0.4;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    _userIcon.frame = CGRectMake(rect.origin.x + 2.5, rect.origin.y + 2.5, 30, 30);
    _nobleImgView.frame = CGRectMake(rect.origin.x, rect.origin.y, 34, 34);
}

@end



#pragma mark - ----------------------- TCShowLiveTopView -----------------------
@implementation TCShowLiveTopView
{
    CAGradientLayer *_gradientLayer;

}
#pragma mark - ----------------------- 直播生命周期 -----------------------
- (void)releaseAll
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_liveRateTimer)
    {
        [_liveRateTimer invalidate];
        _liveRateTimer = nil;
    }
    
    _liveItem = nil;
    _timeView.liveItem = nil;
}
- (void)dealloc
{
    [self releaseAll];
    [_gradientLayer removeFromSuperlayer];
    _gradientLayer = nil;
}

#pragma mark 开始直播
- (void)startLive
{
    
}

#pragma mark 暂停直播
- (void)pauseLive
{
    if (_liveRateTimer)
    {
        [_liveRateTimer invalidate];
        _liveRateTimer = nil;
    }
}

#pragma mark 重新开始直播
- (void)resumeLive
{
    [self monitorRateKBPS];
}

#pragma mark 结束直播
- (void)endLive
{
    [self releaseAll];
}

#pragma mark 初始化房间信息等
- (instancetype)initWith:(id<FWShowLiveRoomAble>)liveItem liveController:(id<FWLiveControllerAble>)liveController
{
    if (self = [super initWithFrame:CGRectZero])
    {
        _liveItem = liveItem;
        _isHost = [liveItem isHost];
        _groupIdStr = StringFromInt([_liveItem liveAVRoomId]);
        
        _httpManager = [NetHttpsManager manager];
        _userArray = [NSMutableArray array];
        
        _timeView = [[TCShowLiveTimeView alloc] initWith:liveItem liveController:liveController];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onPKViewChange:) name:@"onPKViewChange" object:nil];

        [self addOwnViewsWith:_liveItem];
        
        [self monitorRateKBPS];
        [self requestWardData];
        
        
    }
    return self;
}

- (void)requestWardData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"guardians_old" forKey:@"ctl"];
    [dict setValue:@"index" forKey:@"act"];
    [dict setValue:_liveItem.liveHost.imUserId forKey:@"host_id"];
    [_httpManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        NSLog(@"104responseJson%@",responseJson);
        if ([responseJson toInt:@"status"] == 1) {
            //守护数量
            NSString *guardian_sum = responseJson[@"guardian_sum"];
            self.wardJson = responseJson;
            if (guardian_sum.integerValue == 0) {
                self.wardNumLabel.text = ASLocalizedString(@"守护 : 虚席以待");
            }else{
                self.wardNumLabel.text = [NSString stringWithFormat:ASLocalizedString(@"守护 : %@人"),guardian_sum];
            }
//            NSString *is_guartian = responseJson[@"is_guartian"];
//            [GlobalVariables sharedInstance].is_guartian = [NSString stringWithFormat:@"%@",is_guartian];
            [self relayoutOtherContainerViewFrame];
        }else{
            //接口请求失败
            NSLog(ASLocalizedString(@"守护列表请求数据失败responseJson:%@"),responseJson);
        }
    } FailureBlock:^(NSError *error) {
        NSLog(ASLocalizedString(@"守护列表请求数据失败error:%@"),error);
    }];
}


//该参数就是发送过来的通知,接到通知后执行的方法
- (void)onPKViewChange:(NSNotification *)notify
{
    int isFull = [[notify.userInfo valueForKey:@"isFull"] intValue];
    
    if(isFull == 1)
    {
        _otherContainerView.hidden = NO;
        _collectionView.hidden = NO;
        //        _liveGuard.hidden = NO;
    }
    else
    {
        
        _otherContainerView.hidden = NO;
        _collectionView.hidden = NO;
        //        _liveGuard.hidden = YES;
    }
}

#pragma mark 请求完接口后，刷新直播间相关信息
- (void)refreshLiveItem:(id<FWShowLiveRoomAble>)liveItem liveInfo:(CurrentLiveInfo *)liveInfo
{
    _liveItem = liveItem;
    _isHost = [liveItem isHost];
    _groupIdStr = [_liveItem liveIMChatRoomId];
    
    _is_private = liveInfo.is_private;
    _has_admin = (int)liveInfo.podcast.has_admin;
    
    [_timeView refreshLiveItem:_liveItem liveInfo:liveInfo];
    
    float ticket = liveInfo.podcast.user.ticket.floatValue;
    if (ticket > 1000) {
        _ticketNumLabel.text = [NSString stringWithFormat:@"%.1fK",floorf(ticket/1000)];
    }else{
        _ticketNumLabel.text = [NSString stringWithFormat:@"%.0f",ticket];
    }
    _ticketNumLabel.text = liveInfo.total_num;

    if (![BGUtils isBlankString:liveInfo.video_title])
    {
        _timeView.liveTitle.text = liveInfo.podcast.user.nick_name;
    }
    else
    {
        if ([_liveItem liveType] == FW_LIVE_TYPE_RELIVE)
        {
            _timeView.liveTitle.text = ASLocalizedString(@"精彩回放");
        }
        else
        {
            _timeView.liveTitle.text = ASLocalizedString(@"直播Live");
        }
    }
    
//    // 当前直播间是否在竞拍
//    if (liveInfo.pai_id == 0)
//    {
//        self.accountLabel.hidden = NO;
//    }
    
    if ([liveInfo.luck_num intValue] > 1)
    {
        _accountLabel.text = [NSString stringWithFormat:@"%@:%@",[GlobalVariables sharedInstance].appModel.account_name,liveInfo.luck_num];
    }
    else
    {
        if (liveInfo.user_id.length > 1)
        {
            _accountLabel.text = [NSString stringWithFormat:@"%@:%@",[GlobalVariables sharedInstance].appModel.account_name,liveInfo.user_id];
        }
    }
    
    [_timeView.hostHeadBtn sd_setImageWithURL:[NSURL URLWithString:liveInfo.podcast.user.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
//    _timeView.hostHeadBtn.backgroundColor = kBlueColor;
    
    if (!_isHost && liveInfo.podcast.has_focus == 0 && ![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[_liveItem liveHost] imUserId]])
    {
        _isShowFollowBtn = YES;
    }
    
    [self relayoutOtherContainerViewFrame];
    [self relayoutFrameOfSubViews];
    
    [self.collectionView reloadData];
}

#pragma mark - ----------------------- 观众进、退操作 -----------------------

#pragma mark 首次获取观众列表
- (void)refreshAudienceList:(NSDictionary *)responseJson
{
    
    NSArray *array = [[responseJson objectForKey:@"viewer"] objectForKey:@"list"];
    if (array && [array isKindOfClass:[NSArray class]])
    {
        if ([array count])
        {
//            NSMutableArray* userArray = [NSMutableArray array];
//            for (NSDictionary *dict in array)
//            {
//                if (![[dict toString:@"user_id"] isEqualToString:[[_liveItem liveHost] imUserId]])
//                {
//                    UserModel *audience = [UserModel mj_objectWithKeyValues:dict];
//                    [userArray addObject:audience];
//                }
//            }
//            _userArray = userArray;
        }
    }
    
    CurrentLiveInfo *info = [CurrentLiveInfo mj_objectWithKeyValues:responseJson];
    
    
    
    _numRightTitleL.text = [[responseJson objectForKey:@"viewer"] toString:@"watch_number"];
    
    FWWeakify(self)
    [UIView animateWithDuration:0 animations:^{

        FWStrongify(self)
        [self.collectionView reloadData];
        
    }];
    
//    [self performSelector:@selector(setupLiveAudience:) withObject:[[responseJson objectForKey:@"viewer"] toString:@"watch_number"] afterDelay:0.3];
}

#pragma mark 初始化观众数量、列表
- (void)setupLiveAudience:(NSString *)watch_number
{
    _numRightTitleL.text = watch_number;

    if (![BGUtils isBlankString:watch_number])
    {
        if ([watch_number intValue] >= [_collectionView numberOfItemsInSection:0])
        {
            [_timeView.liveAudience setText:watch_number];
        }
        else
        {
            int numCount;
            if (_is_private)
            {
                numCount = (int)([_collectionView numberOfItemsInSection:0]-2);
            }
            else
            {
                numCount = (int)[_collectionView numberOfItemsInSection:0];
                [_timeView.liveAudience setText:StringFromInt(numCount)];
            }
        }
    }
    else
    {

        if ([_collectionView numberOfItemsInSection:0])
        {
            int numCount;
            if (_is_private)
            {
                numCount = (int)([_collectionView numberOfItemsInSection:0]-2);
            }
            else
            {
                numCount = (int)[_collectionView numberOfItemsInSection:0];
                [_timeView.liveAudience setText:StringFromInt(numCount)];
            }
        }
        else
        {
            _timeView.liveAudience.text = @"0";
        }
    }
}

#pragma mark 刷新观众���表
- (void)refreshLiveAudienceList:(CustomMessageModel *)customMessageModel
{
    if (customMessageModel.data && [customMessageModel.data isKindOfClass:[NSDictionary class]])
    {
        // 当 data_type == 1，主播、所有连麦观众收到的定时连麦消息
        if (customMessageModel.data_type == 0)
        {
            if ([GlobalVariables sharedInstance].refreshAudienceListTime < [[customMessageModel.data objectForKey:@"time"] longValue])
            {
                [GlobalVariables sharedInstance].refreshAudienceListTime = [[customMessageModel.data objectForKey:@"time"] longValue];
                
                NSArray *keyArray = [customMessageModel.data objectForKey:@"list_fields"];
                NSArray *valueAllArray = [customMessageModel.data objectForKey:@"list_data"];
                if (keyArray && [keyArray isKindOfClass:[NSArray class]] && valueAllArray && [valueAllArray isKindOfClass:[NSArray class]])
                {
//                    [_userArray removeAllObjects];  // 清空头像的数组
//                    if ([keyArray count] && [valueAllArray count])
//                    {
//                        NSMutableArray* userArray = [NSMutableArray array];
//                        for (NSArray *valueArray in valueAllArray)
//                        {
//                            NSString *user_id;
//                            if ([keyArray containsObject:@"user_id"])
//                            {
//                                user_id = [valueArray objectAtIndex:[keyArray indexOfObject:@"user_id"]];
//                            }
//
//                            if (user_id)
//                            {
//                                if (![user_id isEqualToString:[[_liveItem liveHost] imUserId]])
//                                {
//                                    UserModel *userModel = [[UserModel alloc] init];
//                                    userModel.user_id = user_id;
//
//                                    if ([keyArray containsObject:@"user_level"])
//                                    {
//                                        userModel.user_level = [valueArray objectAtIndex:[keyArray indexOfObject:@"user_level"]];
//                                    }
//
//                                    if ([keyArray containsObject:@"head_image"])
//                                    {
//                                        NSString *headStr = [valueArray objectAtIndex:[keyArray indexOfObject:@"head_image"]];
//                                        if (![BGUtils isBlankString:headStr])
//                                        {
//                                            if ([headStr hasPrefix:@"http://"] || [headStr hasPrefix:@"https://"])
//                                            {
//                                                userModel.head_image = headStr;
//                                            }
//                                            else
//                                            {
//                                                userModel.head_image = [NSString stringWithFormat:@"%@%@",[customMessageModel.data objectForKey:@"short_url"],headStr];
//                                            }
//                                        }
//                                    }
//
//                                    if ([keyArray containsObject:@"v_icon"])
//                                    {
//                                        NSString *iconStr = [valueArray objectAtIndex:[keyArray indexOfObject:@"v_icon"]];
//                                        if (![BGUtils isBlankString:iconStr])
//                                        {
//                                            if ([iconStr hasPrefix:@"http://"] || [iconStr hasPrefix:@"https://"])
//                                            {
//                                                userModel.v_icon = iconStr;
//                                            }
//                                            else
//                                            {
//                                                userModel.v_icon = [NSString stringWithFormat:@"%@%@",[customMessageModel.data objectForKey:@"short_url"],iconStr];
//                                            }
//                                        }
//                                    }
//
//                                    if ([keyArray containsObject:@"is_authentication"])
//                                    {
//                                        userModel.is_authentication = [valueArray objectAtIndex:[keyArray indexOfObject:@"is_authentication"]];
//                                    }
//
//                                    [userArray addObject:userModel];
//                                }
//                            }
//                        }
//                        _userArray = userArray;
//                    }
                    
                    FWWeakify(self)
                    [UIView animateWithDuration:0 animations:^{
                        
                        FWStrongify(self)
                        [self.collectionView reloadData];
                        
                    }];
                    
                    [self performSelector:@selector(setupLiveAudience:) withObject:[customMessageModel.data toString:@"watch_number"] afterDelay:0.3];
                }
            }
        }
    }
}

- (UserModel *)getUserOf:(NSString *)sender
{
    if (sender.length)
    {
        for(UserModel *user in _userArray)
        {
            if([user.user_id isEqualToString:sender])
            {
                return user;
            }
        }
    }
    return nil;
}

#pragma mark 观众进入直播间
- (void)onImUsersEnterLive:(UserModel *)userModel
{
    [_timeView onImUsersEnterLive];
    
//    if (userModel)
//    {
//        [self addUsers:userModel];
//    }
    _groupIdStr = [_liveItem liveIMChatRoomId];
    [self refreshAudienceWithRoomID:_groupIdStr];
}

#pragma mark 添加用户
- (void)addUsers:(UserModel *)lu
{
    if (lu)
    {
//        @synchronized(_userArray)
//        {
            UserModel *liu = [self getUserOf:lu.user_id];
            if (liu)
            {
                @try {
                    
                    NSInteger tmpIndex = [_userArray indexOfObject:liu];
                    if (tmpIndex <= [_userArray count])
                    {
                        [_userArray replaceObjectAtIndex:tmpIndex withObject:lu];
                    }
                    
                } @catch (NSException *exception) {
                    
                } @finally {
                    
                }
                
                [UIView animateWithDuration:0 animations:^{
                    [_collectionView reloadData];
                }];
            }
            else
            {
                if (_userArray)
                {
                    NSInteger tmpIndex = 0;
                    NSInteger user_level = 0;
                    
                    if ([lu.sort_num intValue])
                    {
                        user_level = [lu.sort_num intValue];
                    }
                    else
                    {
                        user_level = [lu.user_level intValue];
                    }
                    
                    for (NSInteger i=0; i<[_userArray count]; i++) {
                        UserModel *um = [_userArray objectAtIndex:i];
                        if (user_level >= [um.user_level intValue])
                        {
                            tmpIndex = i;
                            
                            break;
                        }
                        else if (i == [_userArray count]-1)
                        {
                            tmpIndex = i;
                        }
                    }
                    
//                    @try {
                        
                    
                    if (_userArray) {
                        if (tmpIndex <= [_userArray count])
                        {
                            [_userArray insertObject:lu atIndex:tmpIndex];
                            
                            [UIView animateWithDuration:0 animations:^{
                                [_collectionView reloadData];
                            }];
                        }
                    }
                    
//
//                    } @catch (NSException *exception) {
//
//                    } @finally {
//
//                    }
                    
                }else{
                    [_userArray addObject:lu];
                    [UIView animateWithDuration:0 animations:^{
                        [_collectionView reloadData];
                    }];
                }
            }
        }
//    }
}

#pragma mark 观众退出直播间
- (void)onImUsersExitLive:(UserModel *)userModel
{
    [_timeView onImUsersExitLive];
    
//    if (userModel)
//    {
//        [self deleteUsers:userModel];
//    }
    _groupIdStr = [_liveItem liveIMChatRoomId];
    [self refreshAudienceWithRoomID:_groupIdStr];
}

#pragma mark 删除用户
- (void)deleteUsers:(UserModel *)lu
{
    if (lu)
    {
        @synchronized(_userArray)
        {
            UserModel *liu = [self getUserOf:lu.user_id];
            if (liu)
            {
                [_userArray removeObject:liu];
                
                [UIView animateWithDuration:0 animations:^{
                    [_collectionView reloadData];
                }];
            }
        }
    }
}


-(void)refreshAudienceWithRoomID:(NSString *)roomID{
    
    roomID = StringFromInt([_liveItem liveAVRoomId]);
    NSMutableDictionary * parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"video" forKey:@"ctl"];
    [parmDict setObject:@"room_lists" forKey:@"act"];
    [parmDict setObject:SafeStr(roomID) forKey:@"room_id"];
    [parmDict setObject:@"1" forKey:@"page"];
    
    [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"]integerValue] == 1) {
            [_userArray removeAllObjects];
            NSArray *listArr = [NSArray modelArrayWithClass:[UserModel class] json:[responseJson valueForKey:@"data"]];
            [_userArray addObjectsFromArray:listArr];
            
            [self.collectionView reloadData];
        }
        
        
        
//        UserModel *liu = [self getUserOf:lu.user_id];
//        if (liu)
//        {
//            [_userArray removeObject:liu];
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
}



#pragma mark - ----------------------- 初始化界面 -----------------------
- (void)addOwnViewsWith:(id<FWShowLiveRoomAble>)room
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(kLogoContainerViewHeight, kLogoContainerViewHeight + 5);
    layout.minimumLineSpacing = kDefaultMargin-2;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
    [_collectionView registerClass:[LiveUserViewCell class] forCellWithReuseIdentifier:@"LiveUserViewCell"];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    
    _numRightImgView = [[UIImageView alloc]init];
    _numRightImgView.backgroundColor = [kBlackColor colorWithAlphaComponent:0.3];
//    _numRightImgView.image = [UIImage imageNamed:@"bogo_liveroom_TopNumBgImg"];
    _numRightImgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:_numRightImgView];
    
    _numRightTitleL = [UILabel new];
    _numRightTitleL.font = [UIFont boldSystemFontOfSize:9];
    _numRightTitleL.text = @"";
    _numRightTitleL.textColor = kWhiteColor;
    
    _numRightSubTitleL = [UILabel new];
    _numRightSubTitleL.font = [UIFont boldSystemFontOfSize:11];
    _numRightSubTitleL.text = ASLocalizedString(@"  观众");
    _numRightSubTitleL.textColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    [_numRightImgView addSubview:_numRightTitleL];
    [_numRightImgView addSubview:_numRightSubTitleL];
    
    @synchronized (_userArray)
    {
        [UIView animateWithDuration:0 animations:^{
            [_collectionView reloadData];
        }];
    }
    
    __weak TCShowLiveTopView *ws = self;
    [_timeView.hostHeadBtn setClickAction:^(id<MenuAbleItem> menu) {
        [ws clickLiveHost];
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLiveHost)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_timeView.liveTitle addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLiveHost)];
    tap2.numberOfTapsRequired = 1;
    tap2.numberOfTouchesRequired = 1;
    [_timeView.liveAudience addGestureRecognizer:tap2];
    
    if (![[[IMAPlatform sharedInstance].host imUserId] isEqualToString:[[room liveHost] imUserId]]) {
        [_timeView.liveFollow addTarget:self action:@selector(followAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self addSubview:_timeView];
    
    // 印票
    _otherContainerView = [[UIView alloc]init];
    //渐变B835A2到DD518B
    



    
    _otherContainerView.frame = CGRectMake(0, 0, 0, kTicketContrainerViewHeight);
    _otherContainerView.layer.cornerRadius = _otherContainerView.frame.size.height/2;
    _otherContainerView.backgroundColor = kGrayTransparentColor2;
    _otherContainerView.clipsToBounds = YES;

    
    [self addSubview:_otherContainerView];
    UITapGestureRecognizer *sigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToContribution)];
    [_otherContainerView addGestureRecognizer:sigleTap];
    
    _ticketNameLabel = [[UILabel alloc]init];
    _ticketNameLabel.textColor = kWhiteColor;
    _ticketNameLabel.font = [UIFont systemFontOfSize:14.0];
    GlobalVariables *BuguLive = [GlobalVariables sharedInstance];
    _ticketNameLabel.text = [NSString stringWithFormat:@"%@ : ",BuguLive.appModel.ticket_name];
    [_otherContainerView addSubview:_ticketNameLabel];
    
    _ticketNumLabel = [[UILabel alloc]init];
    _ticketNumLabel.textColor = kWhiteColor;
    _ticketNumLabel.font = [UIFont systemFontOfSize:14.0];
    _ticketNumLabel.text = @"0";
    [_otherContainerView addSubview:_ticketNumLabel];
    
    _moreImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lr_top_arrow_right"]];
    [_otherContainerView addSubview:_moreImgView];
    
    // 守护
    _wardContainerView = [[UIView alloc]init];
    _wardContainerView.frame = CGRectMake(0, 0, 0, kTicketContrainerViewHeight);
    _wardContainerView.layer.cornerRadius = _wardContainerView.frame.size.height/2;
    _wardContainerView.backgroundColor = kGrayTransparentColor2;
    _wardContainerView.clipsToBounds = YES;
    _wardContainerView.hidden = YES;
    _wardContainerView.userInteractionEnabled = YES;
    [self addSubview:_wardContainerView];
    UITapGestureRecognizer *wardSigleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToWardPopView)];
    [_wardContainerView addGestureRecognizer:wardSigleTap];
    
    _wardNumLabel = [[UILabel alloc]init];
    _wardNumLabel.textColor = kWhiteColor;
    _wardNumLabel.font = [UIFont systemFontOfSize:14.0];
    [self addSubview:_wardNumLabel];
    
    _wardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_wardBtn setBackgroundImage:[UIImage imageNamed:ASLocalizedString(@"bogo_live_ward")] forState:UIControlStateNormal];
    [_wardBtn addTarget:self action:@selector(goToWardPopView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_wardBtn];
    
    _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_vipBtn setBackgroundImage:[UIImage imageNamed:ASLocalizedString(@"bogo_live_Vip")] forState:UIControlStateNormal];
    [_vipBtn addTarget:self action:@selector(gotoVipPopView) forControlEvents:UIControlEventTouchUpInside];
    _vipBtn.hidden = [[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"0"];
    [self addSubview:_vipBtn];
    
    
    
    _moreWardImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lr_top_arrow_right"]];
    [_wardContainerView addSubview:_moreWardImgView];
    
    // 最高价（竞拍模块）
    _priceView = [[UIView alloc]init];
    _priceView.frame = CGRectMake(0, 0, 0, kTicketContrainerViewHeight);
    _priceView.layer.cornerRadius = _priceView .bounds.size.height/2;
    _priceView.backgroundColor = kGrayTransparentColor2;
    _priceView.clipsToBounds = YES;
    _priceView.userInteractionEnabled = YES;
    [self addSubview:_priceView];
    _priceView.hidden = NO;
    UITapGestureRecognizer *otherTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToAuction)];
    [_priceView addGestureRecognizer:otherTap];
    
    _titleNameLabel= [[UILabel alloc]init];
    _titleNameLabel.textColor = kWhiteColor;
    _titleNameLabel.font = [UIFont systemFontOfSize:15.0];
    [_priceView addSubview:_titleNameLabel];
    
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.textColor = kWhiteColor;
    _priceLabel.font = [UIFont systemFontOfSize:15.0];
    [_priceView addSubview:_priceLabel];
    
    _otherMoreView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lr_top_arrow_right"]];
    [_priceView addSubview:_otherMoreView];
    _priceView.hidden = YES;
    
    // 账号
    _accountLabel = [[UILabel alloc]init];
    _accountLabel.textColor = RGBA(255, 255, 255, 0.52);
    _accountLabel.font = [UIFont systemFontOfSize:13.0];
    _accountLabel.textAlignment = NSTextAlignmentRight;
    _accountLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _accountLabel.hidden = YES;
    _accountLabel.shadowOffset = CGSizeMake(1, 1);
    [self addSubview:_accountLabel];
    
    // 推拉流码率
    _kbpsContainerView = [[UIView alloc]init];
    _kbpsContainerView.frame = CGRectMake(0, 0, 100, kTicketContrainerViewHeight+6);
    _kbpsContainerView.backgroundColor = kClearColor;
    _kbpsContainerView.clipsToBounds = YES;
    _kbpsContainerView.hidden = YES;
    [self addSubview:_kbpsContainerView];
    
    _kbpsSendLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_kbpsContainerView.frame), CGRectGetHeight(_kbpsContainerView.frame)/2)];
    _kbpsSendLabel.textColor = kWhiteColor;
    _kbpsSendLabel.font = [UIFont systemFontOfSize:9.0];
    _kbpsSendLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _kbpsSendLabel.shadowOffset = CGSizeMake(1, 1);
    [_kbpsContainerView addSubview:_kbpsSendLabel];
    
    _kbpsRecvLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_kbpsContainerView.frame), CGRectGetHeight(_kbpsContainerView.frame)/2)];
    _kbpsRecvLabel.textColor = kWhiteColor;
    _kbpsRecvLabel.font = [UIFont systemFontOfSize:9.0];
    _kbpsRecvLabel.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    _kbpsRecvLabel.shadowOffset = CGSizeMake(1, 1);
    [_kbpsContainerView addSubview:_kbpsRecvLabel];
}

- (void)relayoutFrameOfSubViews
{
    CGFloat tmpWidth = 0;
    if (_isShowFollowBtn)
    {
        tmpWidth = kLogoContainerViewHeight+kLiveStatusViewWidth+kFollowBtnWidth+kDefaultMargin-2;
        _timeView.liveFollow.hidden = NO;
    }
    else
    {
        tmpWidth = kLogoContainerViewHeight+kLiveStatusViewWidth+kDefaultMargin-2;
        _timeView.liveFollow.hidden = YES;
    }
    
    [_timeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(kDefaultMargin);
        make.top.mas_equalTo(kDefaultMargin/2);
        make.width.mas_equalTo(tmpWidth);
        make.height.mas_equalTo(kLogoContainerViewHeight+2);
    }];
    [_timeView relayoutFrameOfSubViews];
    
    [_collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_timeView.mas_trailing).offset(kDefaultMargin);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(self.frame.size.width-tmpWidth-kDefaultMargin-kLiveTopRightNumWidth-kDefaultMargin*2);
        make.height.mas_equalTo(kLogoContainerViewHeight + kRealValue(17 / 2));
    }];
    
    [_numRightImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(0);
        make.centerY.equalTo(_collectionView);
        make.width.mas_equalTo(kLiveTopRightNumWidth);
        make.height.mas_equalTo(kRealValue(34));
    }];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, kLiveTopRightNumWidth, kRealValue(34)) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(kRealValue(34)/2, kRealValue(34)/2)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, kLiveTopRightNumWidth, kRealValue(34));
    maskLayer.path = maskPath.CGPath;
    _numRightImgView.layer.mask = maskLayer;
    
    [_numRightTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_numRightImgView);
        make.top.mas_equalTo(4);
    }];
    
    [_numRightSubTitleL mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_numRightImgView);
        make.top.equalTo(_numRightTitleL.mas_bottom).offset(2);
    }];
    
    [_accountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(-kDefaultMargin);
        make.top.equalTo(_collectionView.mas_bottom).offset(kDefaultMargin);
        make.width.equalTo(self).multipliedBy(0.5);
        make.height.equalTo(_otherContainerView);
    }];
    
    [self relayoutOtherContainerViewFrame];
}

- (void)relayoutOtherContainerViewFrame
{
    CGSize ticketNameSize = [_ticketNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    CGSize ticketNumSize = [_ticketNumLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    _ticketNameLabel.frame = CGRectMake(kDefaultMargin, 0, ticketNameSize.width, CGRectGetHeight(_otherContainerView.frame));
    
    _ticketNumLabel.frame = CGRectMake(CGRectGetMaxX(_ticketNameLabel.frame)+2, 0, ticketNumSize.width+2, CGRectGetHeight(_otherContainerView.frame));
    
    _moreImgView.frame = CGRectMake(CGRectGetMaxX(_ticketNumLabel.frame)+4, (CGRectGetHeight(_otherContainerView.frame)-9)/2, 5, 9);
    
    _otherContainerView.frame = CGRectMake(kDefaultMargin,38.333+kAppMargin2, CGRectGetMaxX(_moreImgView.frame)+kDefaultMargin, kTicketContrainerViewHeight);
//    gradientLayer.frame = _otherContainerView.bounds;
//    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#B835A2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#DD518B"].CGColor];
//     gradientLayer.startPoint = CGPointMake(0, 0);
//     gradientLayer.endPoint = CGPointMake(0, 1);
    
    //先移除之前的gradientLayer

    
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#B835A2"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#DD518B"].CGColor];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        [_otherContainerView.layer insertSublayer:_gradientLayer atIndex:0];
    }
    
    _gradientLayer.frame = _otherContainerView.bounds;
    
    //守护相关
    CGSize wardNumSize = [_wardNumLabel.text textSizeIn:CGSizeMake(MAXFLOAT, MAXFLOAT) font:[UIFont systemFontOfSize:14]];
//    _wardNumLabel.frame = CGRectMake(kDefaultMargin, 0, wardNumSize.width+2, CGRectGetHeight(_wardContainerView.frame));
    _wardBtn.frame = CGRectMake(_otherContainerView.right + 10, _otherContainerView.top, 83, 23);
    _vipBtn.frame = CGRectMake(_wardBtn.right + 10, _wardBtn.top, 83, 23);
    if (_vipBtn.hidden) _vipBtn.height = 0;

    
//    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
//    gradientLayer3.frame = _otherContainerView.bounds; // 请将"yourView"替换为您想要添加渐变的视图
//    gradientLayer3.colors = @[(__bridge id)[UIColor colorWithHexString:@"#EB3452"].CGColor, (__bridge id)[UIColor colorWithHexString:@"#EFAF16"].CGColor];
//    gradientLayer3.startPoint = CGPointMake(0, 0);
//    gradientLayer3.endPoint = CGPointMake(1, 0);
//    [_vipBtn.layer insertSublayer:gradientLayer3 atIndex:0];
    
    
    CGSize titleNameSize = [_titleNameLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    CGSize priceSize = [_priceLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, kTicketContrainerViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}  context:nil].size;
    
    _titleNameLabel.frame = CGRectMake(kDefaultMargin, 0, titleNameSize.width, _priceView.frame.size.height);
    
    _priceLabel.frame = CGRectMake(CGRectGetMaxX(_titleNameLabel.frame)+kDefaultMargin, 0, priceSize.width, CGRectGetHeight(_priceView.frame));
    
    _otherMoreView.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame)+4, (CGRectGetHeight(_priceView.frame)-9)/2, 5, 9);
    
    _priceView.frame = CGRectMake(kDefaultMargin, CGRectGetMaxY(_wardContainerView.frame)+kAppMargin2, CGRectGetMaxX(_otherMoreView.frame)+kDefaultMargin, kTicketContrainerViewHeight);
    
    CGRect newFrame = _kbpsContainerView.frame;
    newFrame.origin.x = CGRectGetMaxX(_wardContainerView.frame)+kDefaultMargin;
    newFrame.origin.y = CGRectGetMinY(_wardContainerView.frame) -3;
    _kbpsContainerView.frame = newFrame;
}



#pragma mark - ----------------------- UICollectionViewDataSource -----------------------
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(userlistRefresh)])
    {
        [_toServicedelegate userlistRefresh];
    }
    
    return _userArray.count;
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
        LiveUserViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LiveUserViewCell" forIndexPath:indexPath];
        [cell sizeToFit];
        
        UserModel *audience;
        
        if ([self.is_private isEqualToString:@"1"])//是否私密
        {
            if (![[[_liveItem liveHost] imUserId] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] && self.has_admin == 0)//是否是私密直播的管理员
            {
                audience = _userArray[indexPath.row];
                [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
                
                if ([audience.noble_stealth isEqualToString:@"1"]) {
                    
                }
                
            }else
            {
                if (indexPath.row == 0){
                    [cell.userIcon setImage:[UIImage imageNamed:@"ic_live_add_viewer"] forState:0];
                    
                }else if (indexPath.row == 1)
                {
                    [cell.userIcon setImage:[UIImage imageNamed:@"ic_live_minus_viewer"] forState:0];
                }else
                {
                    audience = _userArray[indexPath.row-2];
                    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
                }
            }
        }else
        {
            audience = _userArray[indexPath.row];
            [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
        }
        
        
        if (audience.nobleid.intValue > 0)
        {
            cell.nobleImgView.hidden = NO;
            [cell.nobleImgView sd_setImageWithURL:[NSURL URLWithString:SafeStr(audience.noble_avatar)]];
        }
        else
        {
            cell.nobleImgView.hidden = YES;
        }
        
        if (audience.is_noble_mysterious.intValue == 1) {
            [cell.userIcon sd_setImageWithURL:nil forState:UIControlStateNormal placeholderImage:kDefaultNobleMysteriousHeadImg];
        }else{
            [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:audience.head_image] forState:UIControlStateNormal placeholderImage:kDefaultPreloadHeadImg];
        }
        
        cell.indexRow = indexPath.row;
        
        cell.titleL.hidden = YES;
        if (audience.total_num.intValue > 0) {
            cell.titleL.text = audience.total_num;
            cell.titleL.hidden = NO;
        }
        
        
        cell.userInteractionEnabled = YES;
        cell.userIcon.tag = indexPath.row;
        __weak TCShowLiveTopView *ws = self;
        [cell.userIcon setClickAction:^(id<MenuAbleItem> menu) {
            [ws userIconAction:menu];
        }];
        return cell;
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (void)userIconAction:(id)sender
{
    
    MenuButton *userIcon = (MenuButton *)sender;
    
    UserModel *userModel = [_userArray objectAtIndex:userIcon.tag];
    if ([userModel.is_noble_mysterious isEqualToString:@"1"] && ![userModel.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        [FanweMessage alertHUD:ASLocalizedString(@"不能查看神秘人的信息")];
        return;
    }

    
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(clickTopViewUserHeaderMustQuitAllHalfVC:)])
    {
        [_toServicedelegate clickTopViewUserHeaderMustQuitAllHalfVC:self];
    }
    
    
    
    if ([self.is_private isEqualToString:@"1"])//判断是否是私密
    {
        if (![[[_liveItem liveHost] imUserId] isEqualToString:[IMAPlatform sharedInstance].host.imUserId] && self.has_admin == 0)//是否是私密直播的管理员
        {
            if (userIcon.tag < [_userArray count])
            {
                UserModel *userModel = [_userArray objectAtIndex:userIcon.tag];
                if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
                {
                    [_toServicedelegate onTopView:self userModel:userModel];
                }
            }
        }else
        {
            if (userIcon.tag == 0 || userIcon.tag == 1)//+ -
            {
                if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:andCount:)])
                {
                    [_toServicedelegate onTopView:self andCount:(int)userIcon.tag];
                }
            }
            else
            {
                if (userIcon.tag < [_userArray count]+2)
                {
                    UserModel *userModel = [_userArray objectAtIndex:userIcon.tag-2];
                    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
                    {
                        [_toServicedelegate onTopView:self userModel:userModel];
                    }
                }
            }
        }
    }
    else
    {
        if (userIcon.tag < [_userArray count])
        {
            UserModel *userModel = [_userArray objectAtIndex:userIcon.tag];
            if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
            {
                [_toServicedelegate onTopView:self userModel:userModel];
            }
        }
    }
}

#pragma mark -点击LiveVC 的主播个人 图像
/*!
 *    @author Yue
 *
 *    @brief 直播左上角第一个btn，点击弹出个人信息，同时控制半VC 退出
 */
- (void)clickLiveHost
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(clickTopViewUserHeaderMustQuitAllHalfVC:)])
    {
        [_toServicedelegate clickTopViewUserHeaderMustQuitAllHalfVC:self];
    }
    UserModel *userModel = [[UserModel alloc]init];
    userModel.user_id = [[_liveItem liveHost] imUserId];
    userModel.nick_name = [[_liveItem liveHost] imUserName];
    userModel.head_image = [[_liveItem liveHost] imUserIconUrl];
    
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(onTopView:userModel:)])
    {
        [_toServicedelegate onTopView:self userModel:userModel];
    }
}


#pragma mark - ----------------------- 其他 -----------------------

#pragma mark 刷新印票数量
- (void)refreshTicketCount:(NSString *)ticketCount
{
    float ticket = ticketCount.floatValue;
//    if (ticket > 1000) {
//        _ticketNumLabel.text = [NSString stringWithFormat:@"%.1f%@",floorf(ticket/1000),ASLocalizedString(@"K")];
//    }else{
//        _ticketNumLabel.text = [NSString stringWithFormat:@"%.0f",ticket];
//    }
    _ticketNumLabel.text = ticketCount;
    [self relayoutOtherContainerViewFrame];
    
    if (_userArray.count < 1) {
        [self refreshAudienceWithRoomID:_groupIdStr];
    }
    
    [self refreshAudienceWithRoomID:_groupIdStr];
}

-(void)refreshHostNumCount:(NSString *)numCount{
    _numRightTitleL.text = numCount;
}

#pragma mark 监听推拉流请求的码率
- (void)monitorRateKBPS
{
    _liveRateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getRateKBPS) userInfo:nil repeats:YES];
}

- (void)getRateKBPS
{
    if (_toSDKDelegate && [_toSDKDelegate respondsToSelector:@selector(refreshKBPS:)])
    {
        [_toSDKDelegate refreshKBPS:self];
    }
}

- (void)goToContribution
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(goToContributionList:)])
    {
        [_toServicedelegate goToContributionList:self];
    }
}

- (void)goToWardPopView{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(goToWardPopView:)]) {
        [_toServicedelegate goToWardPopView:self];
    }
}

-(void)gotoVipPopView{
    
    if (self.clickVipBlock) {
        self.clickVipBlock(YES);
    }
    
//    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(goToVipPopView:)]) {
//        [_toServicedelegate goToVipPopView:self];
//    }
}

- (void)followAction
{
    if (_toServicedelegate && [_toServicedelegate respondsToSelector:@selector(followAchor:)])
    {
        [_toServicedelegate followAchor:self];
    }
}


@end
