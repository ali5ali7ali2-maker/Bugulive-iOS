//
//  BGShopViewController.m
//  BuguLive
//
//  Created by 志刚杨 on 2019/4/1.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGShopViewController.h"
#import "BGMainWebViewController.h"

@interface BGShopViewController ()<MLMSegmentHeadDelegate>

@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) BGMainWebViewController *tmpController;
@property(nonatomic, strong) BGMainWebViewController *tmpController2;
@property(nonatomic, strong) BGMainWebViewController *tmpController3;

@end

@implementation BGShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self segmentStyle1];
    // Do any additional setup after loading the view.
    // 返回按钮
    [self setupBackBtnWithBlock:nil];
    self.view.backgroundColor = kWhiteColor;
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)segmentStyle1 {
    _list = @[ASLocalizedString(@"  VIP会员  "),
              ASLocalizedString(@"  座驾商城  "),
              ASLocalizedString(@"   靓号   ")];
    _segHead = [[MLMSegmentHead alloc] initWithFrame:CGRectMake(0, 0, kScreenW , 60) titles:_list headStyle:SegmentHeadStyleLine layoutStyle:MLMSegmentLayoutCenter];
    //tab颜色
    _segHead.selectColor = kWhiteColor;
    _segHead.delegate = self;
//    kGrayColor;
//    Main_textColor;
    _segHead.lineColor = Main_textColor;
    
    _segHead.fontScale = 1;
    _segHead.lineHeight = 2.3;
    _segHead.fontSize = 14;
    _segHead.slideHeight = 28;
    _segHead.lineScale = .5;
    _segHead.headColor = kClearColor;
    _segHead.bottomLineHeight = 0;
    _segHead.deSelectColor = [UIColor colorWithHexString:@"#666666"];
//    Main_textColor;
    _segHead.centerX = kScreenW / 2;
    
    self.view.backgroundColor = kClearColor;
    _segScroll = [[MLMSegmentScroll alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_segHead.frame), SCREEN_WIDTH, SCREEN_HEIGHT-CGRectGetMaxY(_segHead.frame) - kNavigationBarHeight - 40) vcOrViews:[self vcArr:_list.count]];
    _segScroll.loadAll = NO;
    _segScroll.showIndex = 1;
    
    [MLMSegmentManager associateHead:_segHead withScroll:_segScroll completion:^{
        [self.view addSubview:_segHead];
        [self.view addSubview:_segScroll];
    }];
}

-(void)changeBtnFrom:(UIButton *)btn{
     [btn setBackgroundImage:[UIImage imageNamed:@"mg_new_list_concert"] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(_tmpController.webView.URL == nil)
    {
        _tmpController =[BGMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.members_url isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
        [_tmpController reLoadCurrentWKWebView];
        //        _vc3 =
        //        [FWMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.pay_car isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
    }
    
    if(_tmpController2.webView.URL == nil)
    {
        _tmpController2 =[BGMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.pay_car isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
        [_tmpController2 reLoadCurrentWKWebView];
        _tmpController2.webView.height = kScreenH - kNavigationBarHeight - _segHead.height - 40;
        //        _vc3 =
        //        [FWMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.pay_car isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
    }
    
    if(_tmpController3.webView.URL == nil)
    {
        _tmpController3 =[BGMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.luck_num_url isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
        [_tmpController3 reLoadCurrentWKWebView];
        //        _vc3 =
        //        [FWMainWebViewController webControlerWithUrlStr:[GlobalVariables sharedInstance].appModel.h5_url.pay_car isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
    }
}


#pragma mark - 数据源
- (NSArray *)vcArr:(NSInteger)count {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.members_url;
    _tmpController =[BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
    _tmpController.navTitleStr = ASLocalizedString(@"VIP会员");
    _tmpController.isShowSegHead = YES;
    [arr addObject:_tmpController];
    
    NSString *tmpUrlStr2 = [GlobalVariables sharedInstance].appModel.h5_url.pay_car;
    _tmpController2 =[BGMainWebViewController webControlerWithUrlStr:tmpUrlStr2 isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
    _tmpController2.navTitleStr = ASLocalizedString(@"座驾");
    _tmpController2.isShowSegHead = YES;
    [arr addObject:_tmpController2];
    
    NSString *tmpUrlStr3 = [GlobalVariables sharedInstance].appModel.h5_url.luck_num_url;
    _tmpController3 =[BGMainWebViewController webControlerWithUrlStr:tmpUrlStr3 isShowIndicator:NO isShowNavBar:YES isShowTabBar:YES];
    _tmpController3.navTitleStr = ASLocalizedString(@"靓号");
    _tmpController3.isShowSegHead = YES;
    [arr addObject:_tmpController3];
    
    return arr;
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
