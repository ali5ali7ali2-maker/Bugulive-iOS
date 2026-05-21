//
//  BogoSetAccountViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/26.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSetAccountViewController.h"
#import "SetTableViewCell.h"
#import "BogoSetAccountModel.h"
#import "BogoLoginViewController.h"
#import <UMShare/UMShare.h>

#import "BogoYoungModeVideoViewController.h"
#import "BogoYouthModeViewController.h"
//青少年模式弹窗
#import "BogoYounthModePopView.h"

//注销账户
#import "BogoLogoutTextViewController.h"
//第三方登录-绑定手机号
#import "BogoThirdLoginViewController.h"

#import "BogoThirdLoginViewController.h"
@interface BogoSetAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArr;
@property(nonatomic, strong) NSMutableArray *thirdArr;

@property(nonatomic, strong) BogoSetAccountModel *model;

@property(nonatomic, strong) BogoYounthModePopView *youthView;


@end

@implementation BogoSetAccountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = ASLocalizedString(@"账号与安全");
    
    [self setupBackBtnWithBlock:nil];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor,
                                                             NSFontAttributeName:[UIFont systemFontOfSize:15]
    } forState:UIControlStateNormal];
    
    
    
    self.thirdArr = [NSMutableArray array];
    if ([GlobalVariables sharedInstance].appModel.has_qq_login == 1)//QQ
    {
        [self.thirdArr addObject:ASLocalizedString(@"QQ")];
    }
    
    if ([GlobalVariables sharedInstance].appModel.has_wx_login == 1)//微信
    {
        [self.thirdArr addObject:ASLocalizedString(@"微信")];
    }

    if (self.thirdArr.count > 0) {

        _listArr = [NSMutableArray arrayWithObjects:@[ASLocalizedString(@"手机号"),ASLocalizedString(@"登录密码") ],self.thirdArr,@[ASLocalizedString(@"青少年模式"),ASLocalizedString(@"注销账号")], nil];
    }else{
        _listArr = [NSMutableArray arrayWithObjects:@[ASLocalizedString(@"手机号"),ASLocalizedString(@"登录密码")],@[ASLocalizedString(@"青少年模式"),ASLocalizedString(@"注销账号")], nil];
    }
    

    [self setModel];
    

    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)setupBackBtnWithBlock:(BackBlock)backBlock
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

-(void)setModel{
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"account_security" forKey:@"act"];
    [paramDic setObject:@"login" forKey:@"ctl"];
    [paramDic setObject:[BGIMLoginManager sharedInstance].loginParam.identifier forKey:@"uid"];
    
    [[NetHttpsManager manager] POSTWithParameters:paramDic SuccessBlock:^(NSDictionary *responseJson) {
        
        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
            self.model = [BogoSetAccountModel modelWithDictionary:[responseJson valueForKey:@"data"]];
            
            [self.tableView reloadData];
        }else{
            
            [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
        }
        
        
        
    } FailureBlock:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - UITableView Datasource

#pragma mark -- 返回区头的高度

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 30)];
    headView.backgroundColor = kAppSpaceColor2;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenW / 2, 30)];

    if (section == 1 && self.thirdArr.count > 0) {

        label.text = ASLocalizedString(@"绑定第三方账号");
    }else{
        label.text = ASLocalizedString(@"安全");
    }
    
    label.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    label.font = [UIFont systemFontOfSize:11];

    [headView addSubview:label];
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 2;
    if (self.thirdArr.count > 0 && section == 1) return self.thirdArr.count;
    if (section == 1 || section == 2) return 2;
    return 0;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    
//    if (self.thirdArr.count > 0 && indexPath.section == 1){
//        return 0;
//    }
    
    return kRealValue(44);

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
    NSArray *sectionArr = self.listArr[indexPath.section];
//    cell.setText.text = [NSString stringWithFormat:@"%@", sectionArr[indexPath.row]];
    

    
    
    cell.setText.text = sectionArr[indexPath.row];
    cell.nobleOpenSwitch.hidden = YES;
    cell.comeBackIMG.hidden = NO;
    cell.labOutLogin.hidden = YES;
    cell.memoryText.hidden = NO;
    
    if (indexPath.row == 0) {
        cell.line.hidden = NO;
    }
    
    if (indexPath.section == 1 && self.thirdArr.count == 1) {
        cell.line.hidden = YES;
    }
    
    [self setCellMemoryTextWithCell:cell indexPath:indexPath];

    return cell;
}

-(void)setCellMemoryTextWithCell:(SetTableViewCell *)cell indexPath:(NSIndexPath *)indexPath{
    
    if (!self.model) {
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSString *phoneNum = self.model.mobile;
        if (phoneNum.length < 10) {
            return;
        }
        
        
        cell.memoryText.text = [NSString stringWithFormat:@"%@****%@",[phoneNum substringToIndex:3],[phoneNum substringFromIndex:phoneNum.length - 4]];
    }
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        cell.memoryText.text = ASLocalizedString(@"修改");
        return;
    }
    
    
    BOOL isHaveQQ = NO;
    BOOL isHaveWeiXin = NO;
    
    if ([GlobalVariables sharedInstance].appModel.has_qq_login == 1)//QQ
    {
        isHaveQQ = YES;
    }
    
    if ([GlobalVariables sharedInstance].appModel.has_wx_login == 1)//微信
    {
        isHaveWeiXin = YES;
    }
    if (isHaveQQ) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.memoryText.text = StrValid(self.model.QQ) ? self.model.QQ : ASLocalizedString(@"去绑定");
            cell.memoryText.textColor = StrValid(self.model.QQ) ? [UIColor colorWithHexString:@"#AAAAAA"] : [UIColor colorWithHexString:@"#F42416"];
        }
    }
    if (isHaveQQ && isHaveWeiXin) {
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.memoryText.text = StrValid(self.model.QQ) ? self.model.QQ : ASLocalizedString(@"去绑定");
            cell.memoryText.textColor = StrValid(self.model.QQ) ? [UIColor colorWithHexString:@"#AAAAAA"] : [UIColor colorWithHexString:@"#F42416"];
        }
        if (indexPath.section == 1 && indexPath.row == 1) {
            cell.memoryText.text = StrValid(self.model.wx) ? self.model.wx : ASLocalizedString(@"去绑定");
            cell.memoryText.textColor = StrValid(self.model.wx) ? [UIColor colorWithHexString:@"#AAAAAA"] : [UIColor colorWithHexString:@"#F42416"];
        }
    }else if (isHaveWeiXin){
        if (indexPath.section == 1 && indexPath.row == 0) {
            cell.memoryText.text = StrValid(self.model.wx) ? self.model.wx : ASLocalizedString(@"去绑定");
            cell.memoryText.textColor = StrValid(self.model.wx) ? [UIColor colorWithHexString:@"#AAAAAA"] : [UIColor colorWithHexString:@"#F42416"];
        }
    }
    
    NSInteger thirdIndex = self.thirdArr.count > 0 ? 2 : 1 ;

    
    if (indexPath.section == thirdIndex && indexPath.row == 0) {
        cell.memoryText.text = self.model.is_young.integerValue == 0 ? ASLocalizedString(@"未开启"): ASLocalizedString(@"已开启");
        cell.memoryText.textColor = [UIColor colorWithHexString:@"#AAAAAA"];

    }else if (indexPath.section == thirdIndex && indexPath.row == 1) {
        cell.memoryText.text = ASLocalizedString(@"注销账号后无法恢复，请谨慎操作");
        cell.memoryText.textColor = [UIColor colorWithHexString:@"#AAAAAA"];
    }
    
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.setText.text isEqualToString:ASLocalizedString(@"手机号")]) {
        BogoLoginViewController *vc = [BogoLoginViewController new];
        vc.loginType = BOGO_LOGIN_TYPE_PHONE_CONFIRM;
        vc.phoneNum = self.model.mobile;
        vc.tel_code = [self.model.tel_code containsString:@"?"] ? self.model.tel_code : [NSString stringWithFormat:@"+%@",self.model.tel_code];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    
    if ([cell.setText.text isEqualToString:ASLocalizedString(@"登录密码")]) {
        if(self.model.mobile.length == 0 || 1)
        {
            //先跳绑定
            BogoThirdLoginViewController *vc = [BogoThirdLoginViewController new];
            vc.bindSuccess = ^{
                [self setModel];
            };
            [self.navigationController pushViewController:vc animated:YES];
            return;
        }
        BogoLoginViewController *vc = [BogoLoginViewController new];
        vc.loginType = BOGO_LOGIN_TYPE_FORGET_CODE;
        vc.phoneNum = self.model.mobile;
        BogoChoiceAreaModel *areaModel = [[BogoChoiceAreaModel alloc] init];
        areaModel.area_code = self.model.tel_code;
        vc.areaModel = areaModel;
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    if ([cell.setText.text isEqualToString:ASLocalizedString(@"QQ")]) {
        
        
    }
    if ([cell.setText.text isEqualToString:ASLocalizedString(@"微信")]) {
        [self getWxLoginUserinfo];
        
    }
    if ([cell.setText.text isEqualToString:ASLocalizedString(@"青少年模式")]) {
        [self.youthView show:self.view type:FDPopTypeCenter];
        
    }
    if ([cell.setText.text isEqualToString:ASLocalizedString(@"注销账号")]) {
        
        BogoLogoutTextViewController *vc = [BogoLogoutTextViewController new];
        vc.phoneNum = self.model.mobile;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(void)getWxLoginUserinfo{
    
    if (StrValid(self.model.wx)) {
        
        [FanweMessage alert:ASLocalizedString(@"提示") message:ASLocalizedString(@"确定解除账号与微信的关联吗?") destructiveAction:^{
            [self unBlindWXWithType:@"2"];
        } cancelAction:^{
            
        }];
        
        return;
    }
    
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
           if (error) {
               NSDictionary *dic = error.userInfo;
               if (dic) {
                   [FanweMessage alertHUD:[dic objectForKey:@"message"]];
               }else{
                   [FanweMessage alertHUD:ASLocalizedString(@"操作失败")];
               }
               
           } else {
               UMSocialUserInfoResponse *resp = result;
               // 授权信息
               NSLog(@"Wechat uid: %@", resp.uid);
               NSLog(@"Wechat openid: %@", resp.openid);
               NSLog(@"Wechat unionid: %@", resp.unionId);
               NSLog(@"Wechat accessToken: %@", resp.accessToken);
               NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
               NSLog(@"Wechat expiration: %@", resp.expiration);
               // 用户信息
               NSLog(@"Wechat name: %@", resp.name);
               NSLog(@"Wechat iconurl: %@", resp.iconurl);
               NSLog(@"Wechat gender: %@", resp.unionGender);
               // 第三方平台SDK源数据
               NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
               
               [self blindWXName:resp.name openID:resp.openid];
               
           }
       }];
}

//解除微信绑定
-(void)unBlindWXWithType:(NSString *)type{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"unbound_account" forKey:@"act"];
    [paramDic setObject:@"login" forKey:@"ctl"];
    [paramDic setObject:[BGIMLoginManager sharedInstance].loginParam.identifier forKey:@"uid"];
    [paramDic setObject:type forKey:@"type"];//解绑类型【1QQ；2微信】
    
    
    [[NetHttpsManager manager] POSTWithParameters:paramDic SuccessBlock:^(NSDictionary *responseJson) {
        
//        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
//            self.model = [BogoSetAccountModel modelWithDictionary:[responseJson valueForKey:@"data"]];
//            [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
//
//        }else{
            
            [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
//        }
        
        [self setModel];
        
    } FailureBlock:^(NSError *error) {
        [FanweMessage alertHUD:error.description];
    }];
}
//微信绑定
-(void)blindWXName:(NSString *)wxName openID:(NSString *)openID{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setObject:@"wxopenid" forKey:@"act"];
    [paramDic setObject:@"login" forKey:@"ctl"];
    [paramDic setObject:wxName forKey:@"wx_name"];
    [paramDic setObject:openID forKey:@"wx_openid"];
    
    
    [[NetHttpsManager manager] POSTWithParameters:paramDic SuccessBlock:^(NSDictionary *responseJson) {
        
//        if ([[responseJson valueForKey:@"status"] integerValue] == 1) {
//            self.model = [BogoSetAccountModel modelWithDictionary:[responseJson valueForKey:@"data"]];
//            [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
//
//        }else{
            
            [FanweMessage alertHUD:[responseJson valueForKey:@"error"]];
//        }
        
        [self setModel];
        
    } FailureBlock:^(NSError *error) {
        [FanweMessage alertHUD:error.description];
    }];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SetTableViewCell"];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(BogoYounthModePopView *)youthView{
    if (!_youthView) {
        _youthView = [[BogoYounthModePopView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(254 + 62 / 2))];
        WeakSelf
        _youthView.clickInYounthBlock = ^(BOOL isComeIn) {
            
            BogoYouthModeViewController *vc = [BogoYouthModeViewController new];
            
            [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];

            [weakSelf.youthView hide];
        };
    }
    return _youthView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
