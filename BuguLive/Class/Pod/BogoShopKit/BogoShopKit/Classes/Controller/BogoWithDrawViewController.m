//
//  BogoWithDrawViewController.m
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoWithDrawViewController.h"
#import "BogoWithDrawTypeCell.h"
#import "BogoWithDrawTopCell.h"
#import "BogoWithDrawMoneyCell.h"
#import "BogoWithDrawBindAlipayPopView.h"
//#import "BogoMoneyDetailViewController.h"
//#import "BogoWithDrawResponseModel.h"
#import "FDUIKitObjC.h"
#import "BogoShopKit.h"
#import <YYKit/YYKit.h>
#import "BogoShopKit.h"
#import "BogoShopWithDrawModel.h"
#import <MJExtension/MJExtension.h>
#import "BogoVirsualDetailViewController.h"
#import "BogoNetwork.h"
#import "BogoNetworkResponseModel.h"
@interface BogoWithDrawViewController ()<UITableViewDelegate,UITableViewDataSource,BogoWithDrawBindAlipayPopViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *withDrawBtn;
@property(nonatomic, strong) BogoWithDrawBindAlipayPopView *bindPopView;
@property(nonatomic, strong) BogoShopWithDrawModel *model;
@property(nonatomic, assign) NSInteger withDrawType;


@end

@implementation BogoWithDrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"提现";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(logBtnAction)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"],NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"],NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoWithDrawTopCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoWithDrawTopCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoWithDrawTypeCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoWithDrawTypeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BogoWithDrawMoneyCell" bundle:kShopKitBundle] forCellReuseIdentifier:@"BogoWithDrawMoneyCell"];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = self.withDrawBtn.bounds;
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:158/255.0 green:100/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:239/255.0 green:96/255.0 blue:246/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [self.withDrawBtn.layer insertSublayer:gl atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)logBtnAction{
    BogoVirsualDetailViewController *moneyVC = [[BogoVirsualDetailViewController alloc]initWithNibName:NSStringFromClass([BogoVirsualDetailViewController class]) bundle:kShopKitBundle];
    [self.navigationController pushViewController:moneyVC animated:YES];
}

- (void)requestData{
//    /shopapi/pay/withdrawalUrl?uid=165999&token=dbb5e1a7327a551baaffac3d83c75775
    [[BogoNetwork shareInstance] POST:@"pay/withdrawalUrl" param:nil success:^(BogoNetworkResponseModel * _Nonnull result) {
        BogoShopWithDrawModel *model = [BogoShopWithDrawModel mj_objectWithKeyValues:result.data];
        self.model = model;
        [self.tableView reloadData];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (IBAction)withDrawBtnAction:(UIButton *)sender {
//    if (self.withDrawType == 0) {
//        [[FDHUDManager defaultManager] show:@"未选择提现方式" ToView:self.view];
//        return;
//    }
    BogoWithDrawMoneyCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    if (!cell.textField.text.length) {
        [[FDHUDManager defaultManager] show:@"请输入提现金额" ToView:self.view];
        return;
    }
    if (cell.textField.text.integerValue == 0) {
        [[FDHUDManager defaultManager] show:@"请输入正确的提现金额" ToView:self.view];
        return;
    }
//    /shopapi/pay/withBtnUrl?token=dbb5e1a7327a551baaffac3d83c75775&money=1
    [[BogoNetwork shareInstance] POST:@"pay/withBtnUrl" param:@{@"money":cell.textField.text} success:^(BogoNetworkResponseModel * _Nonnull result) {
        [[FDHUDManager defaultManager] show:result.msg ToView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

- (IBAction)agreementBtnAction:(UIButton *)sender {
//    RootWebViewController *webVC = [[RootWebViewController alloc]initWithUrl:@"http://baidu.com"];
//    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - BogoWithDrawBindAlipayPopViewDelegate
- (void)bindPopView:(BogoWithDrawBindAlipayPopView *)bindPopView didClickSubmitBtn:(UIButton *)sender{
//    http://192.168.1.141/mapi/public/index.php/api/Userinfo_api/vue_add_binding_account
    [[BogoNetwork shareInstance] POST:@"pay/bingAccountUrl" param:@{@"name":bindPopView.nameTextField.text,@"account":bindPopView.accountTextField.text} success:^(BogoNetworkResponseModel * _Nonnull result) {
        self.model.account.name = bindPopView.nameTextField.text;
        [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
        [bindPopView hide];
    } failure:^(NSString * _Nonnull error) {
        [[FDHUDManager defaultManager] show:error ToView:self.view];
    }];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            BogoWithDrawTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoWithDrawTopCell" forIndexPath:indexPath];
            if (self.model) {
                cell.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.model.income.doubleValue/100];
            }
            return cell;
        }
            break;
        case 1:
        {
            BogoWithDrawMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoWithDrawMoneyCell" forIndexPath:indexPath];
//            if (self.model) {
//                cell.model = self.model;
//            }
            return cell;
        }
            break;
        case 2:
        {
            BogoWithDrawTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BogoWithDrawTypeCell" forIndexPath:indexPath];
            if (indexPath.row == 0) {
                cell.nameLabel.text = @"支付宝";
                [cell.iconImageView setImage:imageNamed(@"shop_支付宝")];
                if (self.model) {
                    cell.statusLabel.text = self.model.account.name.length ? self.model.account.name : @"去绑定";
                    cell.statusLabel.textColor = [UIColor colorWithHexString:self.model.account.name.length ? @"#777777" : @"F42416"];
                }
//                if (self.withDrawType == 2) {
//                    cell.selected = YES;
//                }
            }else{
                cell.nameLabel.text = @"微信";
                [cell.iconImageView setImage:[UIImage imageNamed:@"提现_微信"]];
//                if (self.model) {
//                    cell.statusLabel.text = self.model.data.is_wechat ? self.model.data.realname : @"去授权";
//                    cell.statusLabel.textColor = [UIColor colorWithHexString:self.model.data.is_wechat ? @"#777777" : @"F42416"];
//                    [cell.authImageView sd_setImageWithURL:[NSURL URLWithString:self.model.data.wechat_img]];
//                }
//                if (self.withDrawType == 3) {
//                    cell.selected = YES;
//                }
            }
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 130;
            break;
        case 1:
            return 50;
            break;
        case 2:
            return 50;
            break;
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section > 0 ? 42 : 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 42)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, FD_ScreenWidth, 22)];
    label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label.textColor = [UIColor colorWithHexString:@"333333"];
    if (section == 1) {
        label.text = @"提现金额";
    }else if (section == 2){
        label.text = @"选择提现方式";
    }
    [view addSubview:label];
    return view;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return section == 1 ? 4 : 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    if (section > 1) {
//        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, FD_ScreenWidth, 4)];
//        view.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
//        return view;
//    }
//    return nil;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            if (!self.model.account.name.length) {
                [self.bindPopView show:[UIApplication sharedApplication].keyWindow type:FDPopTypeCenter];
            }else{
                
            }
        }else{
//            if (self.model.data.is_wechat) {
//                self.withDrawType = 3;
//                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//            }else{
//                [tableView deselectRowAtIndexPath:indexPath animated:YES];
//                [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:self completion:^(id result, NSError *error) {
//                    if (error) {
//                        [[HUDHelper sharedInstance] tipMessage:error.localizedDescription];
//                    } else {
//                        UMSocialUserInfoResponse *resp = result;
//
//                        // 授权信息
//                        NSLog(@"Wechat uid: %@", resp.uid);
//                        NSLog(@"Wechat openid: %@", resp.openid);
//                        NSLog(@"Wechat unionid: %@", resp.unionId);
//                        NSLog(@"Wechat accessToken: %@", resp.accessToken);
//                        NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
//                        NSLog(@"Wechat expiration: %@", resp.expiration);
//
//                        // 用户信息
//                        NSLog(@"Wechat name: %@", resp.name);
//                        NSLog(@"Wechat iconurl: %@", resp.iconurl);
//                        NSLog(@"Wechat gender: %@", resp.unionGender);
//
//                        // 第三方平台SDK源数据
//                        NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
//            //            /mapi/public/index.php/api/record_api/wx_apply?uid=200688&token=00479232c93c6f4fede640e8c7b627ce&openid=1234567890987654321&account=yoko-ono-&name=@yokoono~
//                        [CYNET POSTv4C:@"record_api" a:@"wx_apply" parameters:@{@"openid":resp.openid,@"name":resp.name,@"img":resp.iconurl} success:^(id responseObject) {
//                            NSLog(NSLocalizedString(@"绑定微信成功",nil));
//                            self.model.data.is_wechat = 1;
//                            self.model.data.wechat_img = resp.iconurl;
//                            self.model.data.realname = resp.name;
//                            self.withDrawType = 3;
//                            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationAutomatic];
//                        } failure:^(NSString *error) {
//                            [[HUDHelper sharedInstance] tipMessage:error];
//                        }];
//                    }
//                }];
//            }
        }
    }
}

- (BogoWithDrawBindAlipayPopView *)bindPopView{
    if (!_bindPopView) {
        _bindPopView = [kShopKitBundle loadNibNamed:@"BogoWithDrawBindAlipayPopView" owner:nil options:nil].lastObject;
        _bindPopView.delegate = self;
    }
    return _bindPopView;
}

@end
