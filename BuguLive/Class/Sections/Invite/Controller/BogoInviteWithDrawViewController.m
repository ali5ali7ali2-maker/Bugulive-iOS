//
//  BogoInviteWithDrawViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/6/10.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoInviteWithDrawViewController.h"
#import "BogoInviteDetailTopView.h"
#import "BogoInviteDetailBottomView.h"
#import "BogoInviteWithDrawResponseModel.h"
#import "SIdentificationVC.h"
#import "BogoNetworkKit.h"
#import "BogoWithDrawBindAlipayPopView.h"
#import "BogoShopKit.h"

@interface BogoInviteWithDrawViewController ()<BogoInviteDetailBottomViewDelegate,BogoWithDrawBindAlipayPopViewDelegate>

@property(nonatomic, strong) BogoInviteDetailTopView *topView;
@property(nonatomic, strong) BogoInviteDetailBottomView *bottomView;
@property(nonatomic, strong) BogoInviteWithDrawResponseModel *model;
@property(nonatomic, strong) BogoWithDrawBindAlipayPopView *aliPopView;

@end

@implementation BogoInviteWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =ASLocalizedString( @"提现");
    [self.view addSubview:self.topView];
    self.topView.logBtn.hidden = YES;
    self.topView.withDrawBtn.hidden = YES;
    [self.view addSubview:self.bottomView];
    [self performSelector:@selector(updateLayout) afterDelay:0.25];
    [self requestData];
}

- (void)updateLayout{
    self.topView.height = 98;
    self.bottomView.height = 328;
}

- (void)requestData{
//    /mapi/index.php?ctl=invite_vue&act=reward_new&uid=2
    [[BogoNetwork shareInstance] POSTV4:@"" param:@{@"ctl":@"invite_vue",@"act":@"reward_new"} success:^(id _Nonnull result) {
        self.model = [BogoInviteWithDrawResponseModel mj_objectWithKeyValues:result];
        NSString *money = self.model.data.invite_coin;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"upldateTopViewMoney" object:money];
        self.bottomView.model = self.model;
    } failure:^(NSString * _Nonnull error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    }];
}

#pragma mark - BogoWithDrawBindAlipayPopViewDelegate
- (void)bindPopView:(BogoWithDrawBindAlipayPopView *)bindPopView didClickSubmitBtn:(UIButton *)sender{
//    /mapi/index.php?ctl=invite_vue&act=pinless_add_new&pay=1111@qq.com&pay_name=邮箱
    [[BogoNetwork shareInstance] POSTV4:@"" param:@{@"ctl":@"invite_vue",@"act":@"pinless_add_new",@"pay":bindPopView.accountTextField.text,@"pay_name":bindPopView.nameTextField.text} success:^(id _Nonnull result) {
        [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",result[@"error"]]];
        self.model.data.alipay_name = bindPopView.nameTextField.text;
        self.model.data.alipay_account = bindPopView.accountTextField.text;
        self.bottomView.model = self.model;
    } failure:^(NSString * _Nonnull error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    }];
}

#pragma mark - BogoInviteDetailBottomViewDelegate
- (void)bottomView:(BogoInviteDetailBottomView *)bottomView didClickAuthBtn:(UIButton *)sender{
    if (self.model.data.alipay_name.length) {
        return;
    }
    [self.aliPopView show:[UIApplication sharedApplication].keyWindow type:FDPopTypeCenter];
}

- (void)bottomView:(BogoInviteDetailBottomView *)bottomView didClickAgreementBtn:(UIButton *)sender{
    BGBaseWebViewController *webVC = [BGBaseWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.Withdrawal_agree isShowIndicator:NO isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)bottomView:(BogoInviteDetailBottomView *)bottomView didClickWithDrawBtn:(UIButton *)sender{
    if (!self.model.data.alipay_name.length) {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请先授权微信")];
        return;
    }
//    if (!self.model.data.is_auth) {
//        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请先进行实名认证")];
//        SIdentificationVC *identificationVC = [[SIdentificationVC alloc]init];
////        identificationVC.user_id = self.userModel.user_id;
////        identificationVC.sexString = self.userModel.sex;
////        identificationVC.nameString = self.userModel.nick_name;
//        [[AppDelegate sharedAppDelegate] pushViewController:identificationVC animated:YES];
//        return;
//    }
    if (!self.bottomView.selectModel) {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"请先选择提现金额")];
        return;
    }
//    /mapi/index.php?ctl=invite_vue&act=add_reward&uid=165999&id=12
    [[BogoNetwork shareInstance] POSTV4:@"" param:@{@"ctl":@"invite_vue",@"act":@"add_reward",@"id":self.bottomView.selectModel.id} success:^(id _Nonnull result) {
        [[BGHUDHelper sharedInstance] tipMessage:[NSString stringWithFormat:@"%@",result[@"error"]]];
        [self requestData];
    } failure:^(NSString * _Nonnull error) {
        [[BGHUDHelper sharedInstance] tipMessage:error];
    }];
}

- (BogoWithDrawBindAlipayPopView *)aliPopView{
    if (!_aliPopView) {
        _aliPopView = [kShopKitBundle loadNibNamed:@"BogoWithDrawBindAlipayPopView" owner:nil options:nil].lastObject;
        _aliPopView.delegate = self;
    }
    return _aliPopView;
}

- (BogoInviteDetailTopView *)topView{
    if (!_topView) {
        _topView = [[NSBundle mainBundle] loadNibNamed:@"BogoInviteDetailTopView" owner:nil options:nil].lastObject;
    }
    return _topView;
}

- (BogoInviteDetailBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[NSBundle mainBundle] loadNibNamed:@"BogoInviteDetailBottomView" owner:nil options:nil].lastObject;
        _bottomView.delegate = self;
    }
    return _bottomView;
}

@end
