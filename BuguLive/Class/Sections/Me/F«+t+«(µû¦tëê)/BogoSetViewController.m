//
//  BogoSetViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/26.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSetViewController.h"

#import "SetTableViewCell.h"
#import "AccountSecurityViewController.h"
#import "FollowerViewController.h"
#import "LoginViewController.h"
#import "LoginOutModel.h"
#import "PushManageViewController.h"
#import "RecommendedPersonViewController.h"

#import "LanguageViewController.h"

#import "BogoLanguageAlertView.h"

#import "BogoSetPriviteNobleViewController.h"
#import "BogoSetAccountViewController.h"

@interface BogoSetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, strong) BogoLanguageAlertView *languageView;

@end

@implementation BogoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = ASLocalizedString(@"系统设置");
    
    [self setupBackBtnWithBlock:nil];
    
    
    
    [self setModel];
    
    [self.view addSubview:self.tableView];
}
    
-(void)setModel{
    if ([[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"1"]) {
        _listArr = [NSMutableArray arrayWithObjects:@[ASLocalizedString(@"账号与安全")],@[ASLocalizedString(@"黑名单管理"),ASLocalizedString(@"隐私特权设置"),ASLocalizedString(@"消息推送设置"),ASLocalizedString(@"切换语言")],@[ASLocalizedString(@"帮助与反馈"),ASLocalizedString(@"清理缓存"),ASLocalizedString(@"检查更新"),ASLocalizedString(@"关于我们")],@[ASLocalizedString(@"退出登录")], nil];
    }else{
        _listArr = [NSMutableArray arrayWithObjects:@[ASLocalizedString(@"账号与安全")],@[ASLocalizedString(@"黑名单管理"),ASLocalizedString(@"消息推送设置"),ASLocalizedString(@"切换语言")],@[ASLocalizedString(@"帮助与反馈"),ASLocalizedString(@"清理缓存"),ASLocalizedString(@"检查更新"),ASLocalizedString(@"关于我们")],@[ASLocalizedString(@"退出登录")], nil];
    }
}

- (void)setupBackBtnWithBlock:(BackBlock)backBlock
{
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(onReturnBtnPress) image:@"com_arrow_vc_back" highImage:@"com_arrow_vc_back"];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}



#pragma mark -- 返回区头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 0 ? 0 : 5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 5)];
    headView.backgroundColor = kAppSpaceColor2;
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.zebo.zebolive"])
    {
        SetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        
        if([cell.setText.text isEqualToString:ASLocalizedString(@"切换语言")])
        {
            return kRealValue(0.01);
        }
        else
        {
            
        }

    }
    
    return kRealValue(44);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
        {
            return 1;
        }
            break;
        case 1:
        {
            if ([[GlobalVariables sharedInstance].appModel.open_noble isEqualToString:@"1"]) {
                return 4;
            }
            else
                return 3;
        }
            break;
        case 2:
        {
            return 4;
        }
            break;
        case 3:
        {
            return 1;
        }
            break;
            
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
    
    [cell configurationCellWithSection:indexPath.section row:indexPath.row distribution_module:self.BuguLive.appModel.distribution_module];
    
    if (indexPath.section == 3) {
        cell.setText.textColor = [UIColor colorWithHexString:@"#9152F8"];
    }
    
    
    cell.line.hidden = NO;
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.row == 3) || (indexPath.section == 2 && indexPath.row == 3) || indexPath.section == 3) {
        cell.line.hidden = YES;
    }
    cell.loginBack.textColor = [UIColor colorWithHexString:@"#9152F8"];
    
    if([[[NSBundle mainBundle]bundleIdentifier] isEqualToString:@"com.zebo.zebolive"])
    {
        if([cell.setText.text isEqualToString:ASLocalizedString(@"切换语言")])
        {
            cell.hidden = YES;
        }
        else
        {
            cell.hidden = NO;
        }

    }
    
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionArr = self.listArr[indexPath.section];
    NSString *contentStr = sectionArr[indexPath.row];
    
    if ([contentStr isEqualToString:ASLocalizedString(@"账号与安全")]) {
        //账户安全点击事件
        BogoSetAccountViewController *acVC = [[BogoSetAccountViewController alloc]init];
//        acVC.userid = self.userID;
        [self.navigationController pushViewController:acVC animated:YES];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"黑名单管理")]) {
        // 黑名单点击事件
        FollowerViewController *followVC = [[FollowerViewController alloc]init];
        followVC.type = @"3";
        followVC.user_id = self.userID;
        [self.navigationController pushViewController:followVC animated:YES];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"隐私特权设置")]) {
        BogoSetPriviteNobleViewController *vc = [BogoSetPriviteNobleViewController new];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"消息推送设置")]) {
        // 推送管理点击事件
        PushManageViewController *pushManageVC = [[PushManageViewController alloc]init];
        pushManageVC.userId = self.userID;
        [self.navigationController pushViewController:pushManageVC animated:YES];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"切换语言")]) {
        [self gotoLanguage];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"帮助与反馈")]) {
        // 帮助与反馈点击事件
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_help_feedback isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
        tmpController.navTitleStr = ASLocalizedString(@"帮助与反馈");
        [self.navigationController pushViewController:tmpController animated:YES];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"清理缓存")]) {
        // 帮助与反馈点击事件
        SetTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [[[SDWebImageManager sharedManager] imageCache] clearWithCacheType:SDImageCacheTypeAll completion:^{
            [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
        }];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"检查更新")]) {
        [self checkUpdate];
        return;
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"关于我们")]) {
        // 关于我们
        BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:self.BuguLive.appModel.h5_url.url_about_we isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
        tmpController.navTitleStr = ASLocalizedString(@"关于我们");
        [self.navigationController pushViewController:tmpController animated:YES];
    }
    if ([contentStr isEqualToString:ASLocalizedString(@"退出登录")]) {
        [self loginOutAction];
        return;
    }
}


- (void)gotoLanguage {
    
    
    [self.languageView show:[AppDelegate sharedAppDelegate].topViewController.view.superview.superview];
    
}

-(void)checkUpdate{
    if (self.BuguLive.appModel.version.has_upgrade == 1)
    {
        self.BuguLive.ios_down_url = self.BuguLive.appModel.version.ios_down_url;
        
        // 强制升级:forced_upgrade ; 0:非强制升级，可取消; 1:强制升级
        if (self.BuguLive.appModel.version.forced_upgrade == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.BuguLive.ios_down_url]];
        }
        else
        {
            FWWeakify(self)
            [FanweMessage alert:ASLocalizedString(@"提示")message:ASLocalizedString(@"发现新版本，需要升级吗？")destructiveAction:^{
                
                FWStrongify(self)
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.BuguLive.ios_down_url]];
                
            } cancelAction:^{
                
            }];
        }
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"当前已是最新版本！")];
    }
    
    if (!self.BuguLive.appModel.short_name || [self.BuguLive.appModel.short_name isEqualToString:@""])
    {
        self.BuguLive.appModel.short_name = ShortNameStr;
    }

}

-(void)loginOutAction{
    // 退出登录
    
    NSString * preferredLang = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLanguage];

    
    NSString*appDomain = [[NSBundle mainBundle]bundleIdentifier];
    [[NSUserDefaults standardUserDefaults]removePersistentDomainForName:appDomain];
    [self setNetworing];

    [[NSUserDefaults standardUserDefaults] setObject:preferredLang forKey:KAppLanguage];

    [[LocalizationSystem sharedLocalSystem] setLanguage:@"en"];

    [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en",nil] forKey:@"AppleLanguages"];
    [[LocalizationSystem sharedLocalSystem] setLanguage:@"en"];

    [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:KAppLanguage];
    

}

#pragma mark -- 退出登录
- (void)setNetworing
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"login" forKey:@"ctl"];
    [parmDict setObject:@"loginout" forKey:@"act"];
    if (self.userID.length > 0)
    {
        [parmDict setObject:self.userID forKey:@"to_user_id"];
    }
    
    FWWeakify(self)
    [self.httpsManager POSTWithParameters:parmDict  SuccessBlock:^(NSDictionary *responseJson) {
        if ([responseJson toInt:@"status"] == 1)
        {
            FWStrongify(self)
            [self.tableView reloadData];
//            [self.navigationController popViewControllerAnimated:YES];
            [self.navigationController popViewControllerAnimated:NO];
            [[IMAPlatform sharedInstance] logout:^{
                [[AppDelegate sharedAppDelegate] enterLoginUI];
            } fail:^(int code, NSString *msg) {
                [[AppDelegate sharedAppDelegate] enterLoginUI];
            }];
            
            [AppViewModel loadInit];
        }else
        {
            [FanweMessage alertHUD:[responseJson toString:@"error"]];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(BogoLanguageAlertView *)languageView{
    if (!_languageView) {
        _languageView = [[BogoLanguageAlertView alloc]initWithFrame:CGRectMake(kRealValue(20), 0, kScreenW - kRealValue(20 * 2), kRealValue(250))];
    }
    return _languageView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - kTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SetTableViewCell"];
        
        
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}



@end
