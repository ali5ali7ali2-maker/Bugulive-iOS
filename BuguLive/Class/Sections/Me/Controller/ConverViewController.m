//
//  ConverViewController.m
//  BuguLive
//
//  Created by yy on 16/7/19.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "ConverViewController.h"
#import "payWayTableViewCell.h"
#import "myProfitModel.h"
#import "ConverTableViewCell.h"
#import "ConverDiamondsViewController.h"
#import "MBProgressHUD.h"
#import "FreshAcountModel.h"
#import "ExchangeCoinView.h"

@interface ConverViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,MBProgressHUDDelegate,ExchangeCoinViewDelegate>
{
    ExchangeCoinView            *_exchangeView;      //兑换
    UILabel                     *numberLable;
    UILabel                     *numberSubLabel;
    NSMutableArray              *dataArray;
    UIScrollView                *mainScrollView;
    UIView                      *acountView;
    UITableView                 *converTabelView;
    MBProgressHUD               *hud;
    
    UIWindow                    *_bgWindow;
    UIView                      *_exchangeBgView;
    
    
}

@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, strong) NSString *ticketStr;

@property(nonatomic, strong) UILabel *titleDiamondL;

@end

@implementation ConverViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requetAcountMoney];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title =ASLocalizedString(@"兑换");
    self.view.backgroundColor = kWhiteColor;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshAcount) name:@"refreshAcount" object:nil];
    
    dataArray =[[NSMutableArray alloc]initWithCapacity:0];
    
    [self.view addSubview:self.bgImgView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kRealValue(10), 0, kScreenW, kRealValue(40))];
    label.text = ASLocalizedString(@"兑换钻石:");
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment =NSTextAlignmentLeft;
    label.textColor = kBlackColor;
    _titleDiamondL = label;
    
    
    
    [self creatDisplayView];
    [self requetAcountMoney];
    [self myProfitRequest];
    [self createExchangeCoinView];
    
    [self setupBackBtnWithBlock:nil];
    
    [self setUpView];
    
//    [self requetRatio];
    
    
}

-(void)setUpView{
    
    
    
    self.titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, kStatusBarHeight, kScreenW * 0.6, kRealValue(40))];
    self.titleL.text =ASLocalizedString( @"兑换钻石");
    self.titleL.textAlignment = NSTextAlignmentCenter;
    self.titleL.centerX = kScreenW / 2;
    self.titleL.textColor = kWhiteColor;
    [self.view addSubview:self.titleL];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"back_w"] forState:UIControlStateNormal];
    self.backBtn.frame = CGRectMake(0, kStatusBarHeight, kRealValue(30), kRealValue(30));
    self.backBtn.centerY = self.titleL.centerY;
    [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshAcount
{
    [self requetAcountMoney];
}

- (void)creatDisplayView
{
    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    mainScrollView.backgroundColor = kClearColor;
    mainScrollView.delegate =self;
    mainScrollView.scrollsToTop =YES;
    mainScrollView.scrollEnabled =YES;
    mainScrollView.userInteractionEnabled = YES;
    mainScrollView.showsVerticalScrollIndicator =NO;
    [self.view addSubview:mainScrollView];
    
    acountView = [[UIView alloc]initWithFrame:CGRectMake(0, kTopHeight, kScreenW,kRealValue(120))];
    acountView.backgroundColor = kClearColor;
    [mainScrollView addSubview:acountView];
    
    UILabel *acountBalanceLabel =[[UILabel alloc]initWithFrame:CGRectMake(kRealValue(12), kRealValue(20), kScreenW * 0.4, kRealValue(20))];
    acountBalanceLabel.text =ASLocalizedString(@"账户余额：");
    acountBalanceLabel.font =[UIFont systemFontOfSize:14];
    acountBalanceLabel.textColor = kWhiteColor;
    [acountView addSubview:acountBalanceLabel];
    
    numberLable =[[UILabel alloc]initWithFrame:CGRectMake(acountBalanceLabel.left, acountBalanceLabel.bottom, kScreenW *0.5, kRealValue(35))];
    numberLable.textAlignment =NSTextAlignmentLeft;
    numberLable.textColor = kWhiteColor;
    numberLable.font = [UIFont systemFontOfSize:24];
    
//    numberSubLabel =[[UILabel alloc]initWithFrame:CGRectMake(90, acountBalanceLabel.bottom, kScreenW *0.32, kRealValue(35))];
//    numberSubLabel.textAlignment =NSTextAlignmentLeft;
//    numberSubLabel.textColor = kWhiteColor;
//    numberSubLabel.font = [UIFont systemFontOfSize:24];
    
    [acountView addSubview:numberLable];
}

- (void)creatTabelView
{
    converTabelView =[[UITableView alloc]initWithFrame:CGRectMake(0, acountView.bottom, kScreenW, dataArray.count *kRealValue(60) + kRealValue(50))];
    converTabelView.delegate =self;
    converTabelView.dataSource =self;
    if (@available(iOS 15.0, *)) {
        converTabelView.sectionHeaderTopPadding = 0;
    }
    [converTabelView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    converTabelView.backgroundColor = kClearColor;
    converTabelView.scrollEnabled = NO;
    [mainScrollView addSubview:converTabelView];
    
    [converTabelView registerNib:[UINib nibWithNibName:@"ConverTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIButton *writeMoneyButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW *0.093, dataArray.count *kRealValue(60) + kRealValue(40) + kScreenH *0.0176 + acountView.height + kRealValue(82), kRealValue(160), kRealValue(40))];
//    [writeMoneyButton setBackgroundImage:[UIImage imageNamed:@"bogo_recharge_customMoney"] forState:UIControlStateNormal];
    writeMoneyButton.centerX = kScreenW / 2;
    [writeMoneyButton setTitle:ASLocalizedString(@"自定义金额")forState:UIControlStateNormal];
    [writeMoneyButton setTitleColor:kAppMainColor forState:UIControlStateNormal];
    writeMoneyButton.layer.borderColor =[kAppMainColor CGColor];
    writeMoneyButton.layer.borderWidth =1;
    writeMoneyButton.layer.masksToBounds =YES;
    writeMoneyButton.layer.cornerRadius = 20;
    [writeMoneyButton addTarget:self action:@selector(writeMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
    [mainScrollView addSubview:writeMoneyButton];
    
    mainScrollView.contentSize =CGSizeMake(kScreenW, kScreenH *0.25 + writeMoneyButton.height + writeMoneyButton.frame.origin.y);
}

#pragma mark    创建兑换视图
- (void)createExchangeCoinView
{
    _bgWindow = [[UIApplication sharedApplication].delegate window];
    
    if (!_exchangeView)
    {
        _exchangeBgView                    = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _exchangeBgView.backgroundColor    = kGrayTransparentColor4;
        _exchangeBgView.hidden             = YES;
        [_bgWindow addSubview:_exchangeBgView];
        
        UITapGestureRecognizer  *bgViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeBgViewTap)];
        [_exchangeBgView addGestureRecognizer:bgViewTap];
        
        _exchangeView                      = [ExchangeCoinView EditNibFromXib];
        _exchangeView.exchangeType         = 2;
        _exchangeView.delegate             = self;
        _exchangeView.frame                = CGRectMake((kScreenW - 270)/2, kScreenH, 270, 246);
        [_exchangeView createSomething];
        [_bgWindow addSubview:_exchangeView];
    }
}

#pragma mark-----tabelview代理方法
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerSectionID = @"headerSectionID";
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerSectionID];
    
    
    if (headerView == nil)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(40))];
        headerView.backgroundColor = kWhiteColor;
        
        [headerView addSubview:_titleDiamondL];
        headerView.xks_cornerRadius = 10;
        [headerView xks_addCornerAtPostion:UIRectCornerTopLeft|UIRectCornerTopRight];
        
//        view.backgroundColor = kRedColor;
        
//        [headerView addSubview:label];
    }
    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kRealValue(40);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (dataArray.count>0) {
        return dataArray.count ;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return kRealValue(60);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"Cell";
    ConverTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[ConverTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.lineLabel.backgroundColor =kBackGroundColor;
    myProfitModel *proFitModel = [dataArray objectAtIndex:indexPath.row];
    
    cell.label.text = [NSString stringWithFormat:ASLocalizedString(@"%@ %@"),proFitModel.diamonds,[GlobalVariables sharedInstance].appModel.diamond_name];
//    cell.lettLabel.text = [NSString stringWithFormat:@"%@%@",proFitModel.ticket,self.BuguLive.appModel.ticket_name];
//    cell.lettLabel.textColor = kAppMainColor;
//    cell.lettLabel.layer.borderWidth =1;
//    cell.lettLabel.layer.borderColor =[kAppMainColor CGColor];
//    cell.lettLabel.layer.masksToBounds =YES;
//    cell.lettLabel.layer.cornerRadius =15;
    
    [cell.rightBtn setTitle:[NSString stringWithFormat:@"%@%@",proFitModel.ticket,self.BuguLive.appModel.ticket_name] forState:UIControlStateNormal];
    
    return cell;
}

#pragma mark 点击兑换项目
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当离开某行时，让某行的选中状态消失
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    myProfitModel *proFitModel = [dataArray objectAtIndex:indexPath.row];
    NSUserDefaults *userDefaults =[NSUserDefaults standardUserDefaults];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",proFitModel.ID ]forKey:@"converID"];
    [userDefaults setObject:[NSString stringWithFormat:@"%@",proFitModel.ticket ]forKey:@"Ticket"];
    [userDefaults synchronize];
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    hud.delegate = self;
    [self.view addSubview:hud];
    [hud showAnimated:YES];
    [self converDiamondsRequest];
}

#pragma section头部跟着视图一起移动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat sectionHeaderHeight = 20;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}

#pragma mark 自定义金额
- (void)writeMoneyAction:(UIButton *)sender
{
    [_exchangeView requetRatio];
    [UIView animateWithDuration:0.3 animations:^{
        _exchangeBgView.hidden = NO;
//        [_exchangeView.diamondLeftTextfield becomeFirstResponder];
        _exchangeView.ticket = self.ticketStr;
//        numberLable.text;
        
        _exchangeView.diamondLabel.text =[NSString stringWithFormat:ASLocalizedString(@"账户余额:%@"),_exchangeView.ticket];
        _exchangeView.frame = CGRectMake((kScreenW - 270)/2, (kScreenH - 246)/2, 270, 246);
    }];
}

#pragma marlk 我的收益兑换初始化
- (void)myProfitRequest
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ((NSNull *)responseJson != [NSNull null])
        {
            if ([responseJson toInt:@"status"] ==1)
            {
                NSMutableArray *exchageArray =[responseJson objectForKey:@"exchange_rules"];
                if (exchageArray !=nil)
                {
                    for (int i =0; i<exchageArray.count; i++)
                    {
                        NSDictionary *ruleDic =[exchageArray objectAtIndex:i];
                        myProfitModel *proFitModel =[myProfitModel mj_objectWithKeyValues:ruleDic];
                        [dataArray addObject:proFitModel];
                        
                    };
                    [self creatTabelView];
                }
                FreshAcountModel *model3 =[[FreshAcountModel alloc]init];
                model3 =[FreshAcountModel mj_objectWithKeyValues:responseJson];
                
                //兑换比例
                if (model3.ratio != nil&& ![model3.ratio isEqual:[NSNull null]]) {
                    NSString *convertStr = [NSString stringWithFormat:ASLocalizedString(@"兑换钻石1:%@比例兑换(结果取整去零)"),model3.ratio];
                    NSMutableAttributedString *attr  = [[NSMutableAttributedString alloc]initWithString:convertStr];
//                    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16 weight:UIFontWeightMedium] range:NSMakeRange(0,ASLocalizedString( @"兑换钻石").length)];
//                    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(0,ASLocalizedString( @"兑换钻石").length)];
//                    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular] range:NSMakeRange(@"兑换钻石".length, convertStr.length -ASLocalizedString( @"兑换钻石").length)];
//                    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"aaaaaa"] range:NSMakeRange(@"兑换钻石".length, convertStr.length -ASLocalizedString( @"兑换钻石").length)];
                    self.titleDiamondL.attributedText = attr;
                }
                
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

#pragma marlk 请求账户余额
- (void)requetAcountMoney
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"exchange" forKey:@"act"];
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if ((NSNull *)responseJson != [NSNull null])
        {
            if ([responseJson toInt:@"status"] ==1)
            {
                FreshAcountModel *model =[[FreshAcountModel alloc]init];
                model =[FreshAcountModel mj_objectWithKeyValues:responseJson];
                
                
                NSString *messageStr = [NSString stringWithFormat:@"%@%@",model.useable_ticket,self.BuguLive.appModel.ticket_name];
                self.ticketStr = messageStr;

                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:messageStr];
                
                [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24.0]} range:NSMakeRange(0, model.useable_ticket.length)];
                [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:NSMakeRange(model.useable_ticket.length, self.BuguLive.appModel.ticket_name.length)];
                [numberLable setAttributedText:attr];
            }
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

//#pragma marlk 获得钻石兑换比例
//- (void)requetRatio
//{
//
//    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
//
//
//    [parmDict setObject:@"user_center" forKey:@"ctl"];
//    [parmDict setObject:@"exchange" forKey:@"act"];
//    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
//     {
//         if ((NSNull *)responseJson != [NSNull null])
//         {
//             if ([responseJson toInt:@"status"] ==1)
//             {
//                 FreshAcountModel *model3 =[[FreshAcountModel alloc]init];
//                 model3 =[FreshAcountModel mj_objectWithKeyValues:responseJson];
//
//                 //兑换比例
//                 if (model3.ratio != nil&& ![model3.ratio isEqual:[NSNull null]]) {
//                     self.titleDiamondL.text = [NSString stringWithFormat:ASLocalizedString(@"兑换比例: %@"),model3.ratio];
//                 }
//
//             }
//         }
//
//     } FailureBlock:^(NSError *error)
//     {
//
//     }];
//
//}

#pragma marlk 砖石兑换
- (void)converDiamondsRequest
{
    NSString *charge = [[NSUserDefaults standardUserDefaults]objectForKey:@"converID"];
    NSString *Ticket =[[NSUserDefaults standardUserDefaults ]objectForKey:@"Ticket"];
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"user_center" forKey:@"ctl"];
    [parmDict setObject:@"do_exchange" forKey:@"act"];
    [parmDict setObject:charge forKey:@"rule_id"];
    [parmDict setObject:Ticket forKey:@"ticket"];
    
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        if (hud)
        {
            [hud hideAnimated:YES];
        }
        if ([responseJson toInt:@"status"] == 1)
        {
            [self requetAcountMoney];
        }
        [FanweMessage alertHUD:[responseJson objectForKey:@"error"]];
        
    } FailureBlock:^(NSError *error) {
        
        if (hud)
        {
            [hud hideAnimated:YES];
        }
        
    }];
}

- (void)exchangeViewDownWithExchangeCoinView:(ExchangeCoinView *)exchangeCoinView
{
    if (_exchangeView == exchangeCoinView)
    {
        [_exchangeView.diamondLeftTextfield resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{
            [_exchangeView.diamondLeftTextfield resignFirstResponder];
            _exchangeView.diamondLeftTextfield.text = nil;
            _exchangeView.coinLabel.text = [NSString stringWithFormat:@"0%@",self.BuguLive.appModel.diamond_name];
            _exchangeView.frame = CGRectMake((kScreenW - 270)/2, kScreenH, 270, 246);
        } completion:^(BOOL finished) {
            _exchangeBgView.hidden = YES;
            _exchangeView.diamondLeftTextfield.text = nil;
            _exchangeView.coinLabel.text = [NSString stringWithFormat:@"0%@",self.BuguLive.appModel.diamond_name];
        }];
    }
}

- (void)exchangeBgViewTap
{
    [self exchangeViewDownWithExchangeCoinView:_exchangeView];
}

-(UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(200) + kTopHeight)];
        _bgImgView.image = [UIImage imageNamed:@"bogo_recharge_diamond_top_BgImg"];
        _bgImgView.clipsToBounds = YES;
//        _bgImgView.layer.cornerRadius = 20;
        _bgImgView.layer.masksToBounds = YES;
        _bgImgView.userInteractionEnabled = YES;
        _bgImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImgView;
}

@end
