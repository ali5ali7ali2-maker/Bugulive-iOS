//
//  BogoHomeTopView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoHomeTopView.h"
#import "SSearchVC.h"
#import "BGConversationSegmentController.h"

#import "AgreementViewController.h"
#import "PublishLivestViewController.h"
#import "SIdentificationVC.h"
#import "BogoSearchViewController.h"
#import "LeaderboardViewController.h"
@implementation BogoHomeTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self setUpView];
//    }
//    return self;
//}

-(void)setUpView{
    self.topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, self.height)];
    self.topImgView.image = [UIImage imageNamed:@"bogo_home_topImgView"];
    self.topImgView.userInteractionEnabled = YES;
    
//    CAGradientLayer *gl = [CAGradientLayer layer];
//    gl.frame = CGRectMake(0, 0, kScreenW, self.height);
//    gl.startPoint = CGPointMake(0, 0);
//    gl.endPoint = CGPointMake(1, 1);
//    gl.colors = @[(__bridge id)[UIColor colorWithRed:119/255.0 green:52/255.0 blue:254/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:175/255.0 green:26/255.0 blue:251/255.0 alpha:1.0].CGColor];
//    gl.locations = @[@(0.0),@(1.0f)];

//    [self.topImgView.layer addSublayer:gl];
    
//    self.topImgView.backgroundColor = [UIColor colorWithHexString:@""];
    self.searchField.left = kRealValue(12);
    
    self.searchField.top = kStatusBarHeight + 5;
    self.msgBtn.centerY = self.searchField.centerY;
//    = kRealValue(30) + self.searchField.height / 2 + 10;
    
    [self addSubview:self.topImgView];
    self.topImgView.hidden = YES;
    UIButton *searchBtn = [[UIButton alloc] init];
    [searchBtn setImage:[UIImage imageNamed:@"habibi_sousuo"] forState:UIControlStateNormal];
    [self addSubview:searchBtn];
    
    
    UIButton *startLive = [[UIButton alloc] init];
    [startLive setImage:[UIImage imageNamed:@"开播"] forState:UIControlStateNormal];
    [startLive addTarget:self action:@selector(handleLiveEvent) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startLive];
    
    UIButton *paihangBtn = [[UIButton alloc] init];
    [paihangBtn setImage:[UIImage imageNamed:@"hbibi_paihagnbang"] forState:UIControlStateNormal];
    [self addSubview:paihangBtn];
    
    [paihangBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(startLive.mas_left).offset(kRealValue(-10));
        make.size.height.equalTo(@kRealValue(30));
        make.size.width.equalTo(@kRealValue(30));
        make.centerY.equalTo(startLive);
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(paihangBtn.mas_left).offset(kRealValue(-10));
        make.size.height.equalTo(@kRealValue(30));
        make.size.width.equalTo(@kRealValue(30));
        make.centerY.equalTo(startLive);
    }];
    
    [startLive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(kRealValue(-10));
        make.size.height.equalTo(@kRealValue(30));
        make.size.width.equalTo(@kRealValue(30));
        make.top.equalTo(self).offset(kStatusBarHeight + kRealValue(5));
    }];
    
    
    [searchBtn addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [paihangBtn addTarget:self action:@selector(clickPaihang) forControlEvents:UIControlEventTouchUpInside];

    
//    [self addSubview:self.searchField];

//    [self addSubview:self.msgBtn];
}

- (void)handleLiveEvent {
    if(self.delegate && [self.delegate respondsToSelector:@selector(clickLiveBtn)]) {
        [self.delegate clickLiveBtn];
    }
}


- (void)clickPaihang {
    
    LeaderboardViewController *lbVCtr = [[LeaderboardViewController alloc] init];
    lbVCtr.isHiddenTabbar = YES;
    [[AppDelegate sharedAppDelegate]pushViewController:lbVCtr animated:YES];
    

}

-(void)clickMsgBtn:(UIButton *)sender{
    
//    UserModel *userModel = [GlobalVariables sharedInstance].userModel;
    
//    NSString *idStr;  //认证
//    if ([userModel.is_authentication intValue] ==0)
//    {
//        idStr = ASLocalizedString(@"未认证");
//    }
//    if ([userModel.is_authentication intValue] ==1)
//    {
//        idStr = ASLocalizedString(@"等待审核");
//    }
//    if ([userModel.is_authentication intValue] ==2)
//    {
//        idStr = ASLocalizedString(@"已认证");
//    }
//    if ([userModel.is_authentication intValue] ==3)
//    {
//        idStr = ASLocalizedString(@"审核不通过");
//    }
    
    if ([GlobalVariables sharedInstance].appModel.must_authentication.intValue == 1) {
        if ([GlobalVariables sharedInstance].userModel.is_authentication.intValue != 2) {
            [self showAuthView];
            return;
        }
    }

    IMALoginParam *loginParam = [IMALoginParam loadFromLocal];
    if (loginParam.isAgree ==1)
    {
        PublishLivestViewController *pvc = [[PublishLivestViewController alloc] init];
        [[AppDelegate sharedAppDelegate] presentViewController:pvc animated:YES completion:^{
            
        }];
    }
    else
    {
        AgreementViewController *agreeVC = [AgreementViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.agreement_link isShowIndicator:YES isShowNavBar:YES];
        [[AppDelegate sharedAppDelegate] presentViewController:agreeVC animated:YES completion:^{
            
        }];
    }
    
//    BGConversationSegmentController *chatListVC = [[BGConversationSegmentController alloc]init];
//    [[AppDelegate sharedAppDelegate] pushViewController:chatListVC animated:YES];
}

//是否已认证
-(void)showAuthView{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:ASLocalizedString(@"您当前还未实名认证，需要认证后才能开始直播")preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *actionCacel = [UIAlertAction actionWithTitle:ASLocalizedString(@"取消")style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *actionConfirm = [UIAlertAction actionWithTitle:ASLocalizedString(@"立即认证")style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UserModel *userModel = [GlobalVariables sharedInstance].userModel;
        SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
        identificationVC.user_id = userModel.user_id;
        identificationVC.sexString = userModel.sex;
        identificationVC.nameString = userModel.nick_name;
        [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];

    }];
    
    [alertController addAction:actionCacel];
    [alertController addAction:actionConfirm];
    [[AppDelegate sharedAppDelegate].topViewController presentViewController:alertController animated:YES completion:nil];
}

-(void)clickSearch:(UITapGestureRecognizer *)sender{
//    SSearchVC *searchVC = [[SSearchVC alloc]init];
//    searchVC.searchType = @"0";
//    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
    BogoSearchViewController *searchVC = [[BogoSearchViewController alloc]initWithNibName:@"BogoSearchViewController" bundle:[NSBundle mainBundle]];
    [[AppDelegate sharedAppDelegate] pushViewController:searchVC animated:YES];
}

-(UITextField *)searchField{
    if (!_searchField) {
        
        _searchField = [[UITextField alloc]initWithFrame:CGRectMake(kRealValue(12), 0, kScreenW - kRealValue(39) - kRealValue(22) - kRealValue(12 * 2),kRealValue(32))];
        _searchField.text = ASLocalizedString(@"请输入搜索内容");
        _searchField.font = [UIFont systemFontOfSize:14];
        _searchField.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
        _searchField.backgroundColor = kWhiteColor;
        _searchField.layer.cornerRadius = kRealValue(32 / 2);
        _searchField.layer.masksToBounds = YES;
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 33, 33)];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
        imageView.image = [UIImage imageNamed:@"bogo_home_top_search"];
        imageView.center = leftView.center;
        [leftView addSubview:imageView];
        _searchField.leftView = leftView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.delegate = self;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSearch:)];
        [_searchField addGestureRecognizer:tap];
    }
    return _searchField;
}

-(UIButton *)msgBtn{
    if (!_msgBtn) {
        _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_msgBtn setImage:[UIImage imageNamed:@"bogo_home_live_start"] forState:UIControlStateNormal];
        [_msgBtn addTarget:self action:@selector(clickMsgBtn:) forControlEvents:UIControlEventTouchUpInside];
        _msgBtn.frame = CGRectMake(kScreenW - kRealValue(50), 0, kRealValue(30), kRealValue(50));
    }
    return _msgBtn;
}




@end
