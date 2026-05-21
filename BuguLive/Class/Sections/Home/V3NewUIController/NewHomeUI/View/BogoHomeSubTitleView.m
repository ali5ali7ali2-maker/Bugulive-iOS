#import "BogoHomeSubTitleView.h"
#import "Masonry.h"
#import "GameVC.h"
@implementation BogoHomeSubTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (BOOL)isRTL {
    return [UIApplication sharedApplication].userInterfaceLayoutDirection 
           == UIUserInterfaceLayoutDirectionRightToLeft;
}

- (void)setupView {
    [self addSubview:self.listControl];
    [self addSubview:self.pkControl];
    [self addSubview:self.videoControl];
    
    // 使用Masonry进行布局
    [self.listControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kRealValue(7.5));
        make.width.equalTo(@((kScreenW - kRealValue(10 * 2 + 2 * 2)) / 3));
        make.height.equalTo(@(kRealValue(80)));
    }];
    
    [self.pkControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.listControl.mas_right).offset(kRealValue(2));
        make.width.equalTo(@((kScreenW - kRealValue(10 * 2 + 2 * 2)) / 3));
        make.height.equalTo(@(kRealValue(80)));
    }];
    
    [self.videoControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.pkControl.mas_right).offset(kRealValue(7.5));
        make.width.equalTo(@((kScreenW - kRealValue(10 * 2 + 2 * 2)) / 3));
        make.height.equalTo(@(kRealValue(80)));
    }];
    
    // 调整布局以适应RTL
    if ([self isRTL]) {
        [self.listControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self).offset(-kRealValue(12));
            make.width.equalTo(@((kScreenW - kRealValue(10 * 2 + 12 * 2)) / 3));
            make.height.equalTo(@(kRealValue(80)));
        }];
        
        [self.pkControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.listControl.mas_left).offset(-kRealValue(10));
            make.width.equalTo(@((kScreenW - kRealValue(10 * 2 + 12 * 2)) / 3));
            make.height.equalTo(@(kRealValue(80)));
        }];
        
        [self.videoControl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.right.equalTo(self.pkControl.mas_left).offset(-kRealValue(10));
            make.width.equalTo(@((kScreenW - kRealValue(10 * 2 + 12 * 2)) / 3));
            make.height.equalTo(@(kRealValue(80)));
        }];
    }
}

- (UIControl *)listControl {
    if (!_listControl) {
        _listControl = [[UIControl alloc] init];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = ASLocalizedString(@"榜单");
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"bogo_home_top_list"];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"bogo_home_top_subList"];
        imgView.hidden = YES;
        [_listControl addSubview:bgImgView];
        [_listControl addSubview:titleL];
        [_listControl addSubview:imgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_listControl);
        }];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_listControl);
            make.left.equalTo(_listControl).offset(kRealValue(10));
//            make.right.equalTo(imgView.mas_left).offset(-kRealValue(8));
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_listControl);
            make.right.equalTo(_listControl).offset(-kRealValue(8));
            make.width.height.equalTo(@(kRealValue(46)));
        }];
        
        [_listControl addTarget:self action:@selector(clickListBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _listControl;
}

- (UIControl *)pkControl {
    if (!_pkControl) {
        _pkControl = [[UIControl alloc] init];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = ASLocalizedString(@"PK对战");
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"bogo_home_top_pk"];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"bogo_home_top_subPK"];
        imgView.hidden = YES;
        [_pkControl addSubview:bgImgView];
        [_pkControl addSubview:titleL];
        [_pkControl addSubview:imgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_pkControl);
        }];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pkControl);
//            make.left.equalTo(_pkControl).offset(kRealValue(10));
            make.right.equalTo(imgView.mas_left).offset(-kRealValue(8));
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_pkControl);
            make.right.equalTo(_pkControl).offset(-kRealValue(8));
            make.width.height.equalTo(@(kRealValue(46)));
        }];
        
        [_pkControl addTarget:self action:@selector(clickPkBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pkControl;
}

- (UIControl *)videoControl {
    if (!_videoControl) {
        _videoControl = [[UIControl alloc] init];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = ASLocalizedString(@"游戏");
        titleL.font = [UIFont systemFontOfSize:16];
        titleL.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        titleL.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *bgImgView = [[UIImageView alloc] init];
        bgImgView.image = [UIImage imageNamed:@"bogo_home_top_video"];
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.image = [UIImage imageNamed:@"bogo_home_top_subVideo"];
//        imgView.hidden = YES;
        [_videoControl addSubview:bgImgView];
        [_videoControl addSubview:titleL];
        [_videoControl addSubview:imgView];
        
        [bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_videoControl);
        }];
        
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_videoControl);
//            make.left.equalTo(_videoControl).offset(kRealValue(10));
            make.right.equalTo(imgView.mas_left).offset(-kRealValue(8));
        }];
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_videoControl);
            make.right.equalTo(_videoControl).offset(-kRealValue(8));
            make.width.height.equalTo(@(kRealValue(46)));
        }];
        
        [_videoControl addTarget:self action:@selector(clicVideoBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _videoControl;
}

- (void)clickListBtn:(UIControl *)sender {
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    lbVCtr.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate] pushViewController:lbVCtr animated:YES];
}

- (void)clickPkBtn:(UIControl *)sender {
    PKBattleViewController *vc = [PKBattleViewController new];
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
}

- (void)clicVideoBtn:(UIButton *)sender {
    GameVC *vc = [GameVC new];
    
    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];

//    NSMutableDictionary *latestDic = [NSMutableDictionary dictionary];
//    [latestDic setObject:@"2" forKey:@"order"];
//    [latestDic setObject:@"0" forKey:@"cate"];
//    
//    MSmallVideoVC *videoVC = [[MSmallVideoVC alloc] init];
//    videoVC.isHaveNavBar = NO;
//    videoVC.view.height = kScreenH - 64;
//    videoVC.videoCollectionV.height = kScreenH - 64;
//    videoVC.paramDict = latestDic;
//    videoVC.view.backgroundColor = kWhiteColor;
//    [[AppDelegate sharedAppDelegate] pushViewController:videoVC animated:YES];
}

- (void)pushToHomePage:(UserModel *)model {
    SHomePageVC *homeVC = [[SHomePageVC alloc] init];
    homeVC.user_id = model.user_id;
    homeVC.type = 0;
    
    if ([model.is_noble_ranking_stealth isEqualToString:@"1"] && ![model.user_id isEqualToString:[BGIMLoginManager sharedInstance].loginParam.identifier]) {
        [FanweMessage alertHUD:ASLocalizedString(@"不能查看神秘人信息")];
        return;
    }
    
    [[AppDelegate sharedAppDelegate] pushViewController:homeVC animated:YES];
}




@end
