//
//  BogoRechargeScrollView.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargeScrollView.h"
#import "BogoRechargeTopView.h"
#import "BogoRechargePayMoneyCollection.h"
#import "BogoRechargePayTypeCollection.h"


@interface BogoRechargeScrollView ()

@property(nonatomic, strong) BogoRechargeTopView *topView;

@property(nonatomic, strong) BogoRechargePayMoneyCollection *payMoneyView;
@property(nonatomic, strong) BogoRechargePayTypeCollection *payTypeView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, strong) NSMutableArray *rule_list;//支付金额列表


@property(nonatomic, strong) UIButton *selectAgreeBtn;
@property(nonatomic, strong) UIButton *agreeBtn;

@property(nonatomic, strong) UIButton *payBtn;

//弹窗需要
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UIButton *closeBtn;

@end

@implementation BogoRechargeScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
        
        [self loadRechargeData];
    }
    return self;
}

-(void)setUpView{
    self.topView.frame = CGRectMake(0, 0, kScreenW, kRealValue(180));
    
    [self addSubview:self.topView];
    [self addSubview:self.payMoneyView];
    [self addSubview:self.payTypeView];
    
    
    self.selectAgreeBtn.frame = CGRectMake(0, self.payTypeView.bottom, kRealValue(40), kRealValue(40));
    self.agreeBtn.frame = CGRectMake(self.selectAgreeBtn.right, self.selectAgreeBtn.top, kScreenW * 0.5, kRealValue(40));
    self.payBtn.frame = CGRectMake(0, self.agreeBtn.bottom, kRealValue(270), kRealValue(40));
    self.payBtn.centerX = kScreenW / 2;
    [self addSubview:self.selectAgreeBtn];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.payBtn];
    
}

-(void)resetViewFrame{
    
   
    if (self.isRecharge) {
        
        self.contentSize = CGSizeMake(0, kScreenH * 1.2);

    }else{
        self.topView.frame = CGRectMake(0, 0, kScreenW, kRealValue(60));
        self.topView.hidden = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.closeBtn];
        
        self.contentSize = CGSizeMake(0, self.payBtn.bottom + kRealValue(20));
        
    }
    
    NSLog(@"ntSize.heig%f",self.contentSize.height);
    
    self.payMoneyView.top = self.topView.bottom;
    
    self.payMoneyView.height = kRealValue(40) + (self.model.rule_list.count / 3 + 1) * kRealValue(70) + kRealValue(40);
    self.payTypeView.top = self.payMoneyView.bottom;
    self.payTypeView.height = kRealValue(40) + self.model.pay_list.count * kRealValue(40);
    self.agreeBtn.top = self.selectAgreeBtn.top = self.payTypeView.bottom + kRealValue(10);
    self.payBtn.top = self.agreeBtn.bottom + kRealValue(10);
    
    
//    if (!self.isRecharge) {
        self.contentSize = CGSizeMake(0, self.payBtn.bottom + kRealValue(20));
//    }
}

- (void)loadRechargeData
{
    
    self.listArr = [NSMutableArray array];
    self.rule_list = [NSMutableArray array];
    
    NSMutableDictionary * parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pay" forKey:@"ctl"];
    [parmDict setObject:@"recharge" forKey:@"act"];
    
    FWWeakify(self)
    
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        
        FWStrongify(self)
        [self.listArr removeAllObjects];
        [self.rule_list removeAllObjects];
        
        self.model = [AccountRechargeModel mj_objectWithKeyValues:responseJson];
        self.rule_list = [NSMutableArray arrayWithArray:self.model.rule_list];
        
        self.topView.numerLabel.text = [NSString stringWithFormat:@"%ld",self.model.diamonds];
        
        [self resetViewFrame];
        
        
        self.payMoneyView.model = self.model;
        self.payTypeView.model = self.model;
        
    //如果有其它金额充值方式,要在除苹果支付外的其它支付方式里面的每个支付方式列表里添加一个对应的model,添加的model用于表示其它金额支付
        if ([self.model.show_other integerValue] == 1)
        {
            for (int i=0; i<self.model.pay_list.count; ++i)
            {
                PayTypeModel * model = self.model.pay_list[i];
                if (![model.class_name isEqual:@"Iappay"])
                {
                    PayMoneyModel * otherModel = [[PayMoneyModel alloc] init];
                    otherModel.hasOtherPay = YES;
                    if (model.rule_list.count>0)
                    {
                        [model.rule_list addObject:otherModel];
                        self.model.pay_list[i] = model;
                    }
                    else
                    {
                        NSMutableArray * otherArray = [NSMutableArray arrayWithArray:self.model.rule_list];
                        [otherArray addObject:otherModel];
//                        self.otherPayArr = otherArray;
                        break;
                    }
                }
            }
        }
//        PayTypeModel * model = self.model.pay_list.firstObject;
//        if ([model.class_name isEqual:@"Iappay"] && self.model.pay_list.count == 1)
//        {
//            self.rechargeWayView.frame = CGRectMake(0, CGRectGetMaxY(self.rechargeBtn.frame), self.width, 0);
//            self.rechargeWayView.hidden = YES;
//            self.separateView.frame = CGRectMake(10, CGRectGetMaxY(self.rechargeWayView.frame)+20, self.width-20, 0.5);
//        }
//        else
//        {
//            self.rechargeWayView.frame = CGRectMake(0, CGRectGetMaxY(_selectLineView.frame) - kRealValue(5), self.width, 40);
//
//            self.selectAgreeBtn.frame = CGRectMake(kRealValue(15), self.rechargeWayView.bottom + kRealValue(15), kRealValue(20), kRealValue(20));
//            self.agreeBtn.centerY = self.selectAgreeBtn.centerY;
//            self.agreeBtn.left = self.selectAgreeBtn.right;
//            self.rechargeWayView.hidden = NO;
//            self.separateView.frame = CGRectMake(10, _rechargeWayView.bottom + 35, self.width-20, 0.5);
//        }
//        self.listCollectionView.frame = CGRectMake(0, CGRectGetMaxY(self.separateView.frame), self.width, self.height-CGRectGetMaxY(_separateView.frame)-45);
//        if (self.model.pay_list.count>0)
//        {
//            PayTypeModel *model = [self.model.pay_list firstObject];
//            if ([self.model.show_other integerValue] == 1)
//            {
//                if (![model.class_name isEqual:@"Iappay"])
//                {
//                    if (model.rule_list.count>0)
//                    {
//                        self.listArray = model.rule_list;
//                    }
//                    else
//                    {
//                        self.listArray = self.otherPayArr;
//                    }
//                }
//                else
//                {
//                    self.listArray = model.rule_list.count>0 ? model.rule_list: self.model.rule_list;
//                }
//            }
//            else
//            {
//                self.listArray = model.rule_list.count>0 ? model.rule_list: self.model.rule_list;
//            }
//        }
//        self.rechargeWayView.rechargeWayArr =self.model.pay_list;
//        [self.listCollectionView reloadData];
//        [self reloadView];
        
    } FailureBlock:^(NSError *error) {
        [FanweMessage alertHUD:ASLocalizedString(@"加载失败，请重试")];
    }];
}

#pragma mark - 点击事件


-(void)clickAgreenBtn:(UIButton *)sender{
    
    NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.url_recharge_agreement;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

-(void)clickSelectAgreenBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
}

#pragma mark - 点击充值按钮

-(void)clickPayBtn:(UIButton *)sender{
    
    if (!self.selectAgreeBtn.selected) {
        
        [FanweMessage alertHUD:ASLocalizedString(@"请先勾选是否同意用户充值免责协议")];
        
        return;
    }
    
    if ([self.payTypeView.selectModel.class_name isEqualToString:@"Iappay"]) {
        [self payRequestNet:1];
    }else{
        [self payRequestNet:0];
    }
}

#pragma mark 支付请求

//内购传rule_id,money
//支付宝、微信传 pay_id 支付id，rule_id 充值规则id，money 价格

- (void)payRequestNet:(int)indicate
//             wxPayNet:(int)wxIndicate
{
    NSString *payID = [NSString stringWithFormat:@"%ld",self.payTypeView.selectModel.payWayID];
    
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];

    [parmDict setObject:@"pay" forKey:@"ctl"];
    
    [parmDict setObject:@"pay" forKey:@"act"];
    [parmDict setObject:payID forKey:@"pay_id"];
//    if (wxIndicate == 1 && indicate < self.ruleListArr.count)
//    {
//     if (indicate) {
//         PayMoneyModel *model = self.payMoneyView.selectModel;
// //        self.ruleListArr[indicate];
//         [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)model.payID] forKey:@"rule_id"];
        
//         [parmDict setObject:[NSString stringWithFormat:@"%@",model.money] forKey:@"money"];
    
//     }else{
//         PayMoneyModel *model = self.payMoneyView.selectModel;
// //        self.ruleListArr[indicate];
//         [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)model.payID] forKey:@"rule_id"];
        
//         [parmDict setObject:[NSString stringWithFormat:@"%@",model.money] forKey:@"money"];
    
//     }
    PayMoneyModel *model = self.payMoneyView.selectModel;
    [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)model.payID] forKey:@"rule_id"];
    [parmDict setObject:[NSString stringWithFormat:@"%@",model.money] forKey:@"money"];
    [SVProgressHUD show];
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson){
        
        [SVProgressHUD dismiss];
        
        if ([responseJson toInt:@"status"]==1)
        {
            NSDictionary *payDic =[responseJson objectForKey:@"pay"];
            NSDictionary *sdkDic =[payDic objectForKey:@"sdk_code"];
            NSString *sdkType =[sdkDic objectForKey:@"pay_sdk_type"];
            if ([sdkType isEqualToString:@"alipay"])
            {
                //支付宝支付
                NSDictionary *configDic =[sdkDic objectForKey:@"config"];
                Pay_Model * model2 =[Pay_Model mj_objectWithKeyValues: configDic];
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",model2.order_spec, model2.sign, model2.sign_type];
                if (self.reDelegate && [self.reDelegate respondsToSelector:@selector(alipay:)]) {
                    [self.reDelegate alipay:orderString];
                }
//                [self alipay:orderString block:nil];
            }
            else if ([sdkType isEqualToString:@"wxpay"])
            {
                //微信支付
                NSDictionary *configDic =[payDic objectForKey:@"config"];
                NSDictionary *iosDic =[configDic objectForKey:@"ios"];
                Mwxpay * wxmodel =[Mwxpay mj_objectWithKeyValues: iosDic];
                PayReq* req = [[PayReq alloc] init];
                req.openID = wxmodel.appid;
                req.partnerId = wxmodel.partnerid;
                req.prepayId = wxmodel.prepayid;
                req.nonceStr = wxmodel.noncestr;
                req.timeStamp = [wxmodel.timestamp intValue];
                req.package = wxmodel.package;
                req.sign = wxmodel.sign;

                [WXApi sendReq:req completion:^(BOOL success) {
                    
                }];

            }
            else if ([sdkType isEqualToString:@"JubaoWxsdk"] || [sdkType isEqualToString:@"JubaoAlisdk"])
            {
//                NSDictionary *configDic =[sdkDic objectForKey:@"config"];
//                _juBaoModel = [JuBaoModel mj_objectWithKeyValues: configDic];
//                BGParam *param = [[BGParam alloc] init];
//                // playerid：用户在第三方平台上的用户名
//                param.playerid  = _juBaoModel.playerid;
//                // goodsname：购买商品名称
//                param.goodsname = _juBaoModel.goodsname;
//                // amount：购买商品价格，单位是元
//                param.amount    = _juBaoModel.amount;
//                // payid：第三方平台上的订单号，请传真实订单号，方便后续对账，例子里采用随机数，
//                param.payid     = _juBaoModel.payid;
//
//                [BGInterface start:self withParams:param  withDelegate:self];
                //[BGInterface start:self withParams:param withType:model.withType withDelegate:self];
                // 凡伟支付 end

            }
            else if ([sdkType isEqualToString:@"iappay"])
            {
                [SVProgressHUD showWithStatus:ASLocalizedString(@"正在提交iTunes Store,请等待...")];
                NSMutableDictionary *configDic = [NSMutableDictionary new];
                configDic = sdkDic[@"config"];
//                self.pro_id = configDic[@"product_id"];
                
                if (self.reDelegate && [self.reDelegate respondsToSelector:@selector(checkProid:)]) {
                    [self.reDelegate checkProid:configDic[@"product_id"]];
                }
                
            }
            else if ([payDic toInt:@"is_wap"] == 1)
            {
                if ([payDic toInt:@"is_without"] == 1) // 跳转外部浏览器
                {
                    NSURL *url=[NSURL URLWithString:[payDic stringForKey:@"url"]];
                    [[UIApplication sharedApplication] openURL:url];
                }
                else
                {
                    BGMainWebViewController *vc = [BGMainWebViewController webControlerWithUrlStr:[payDic stringForKey:@"url"] isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES];
                    [[AppDelegate sharedAppDelegate] pushViewController:vc animated:YES];
                }
            }
            else
            {
                NSLog(ASLocalizedString(@"错误"));
            }
        }
        else
        {
            NSLog(ASLocalizedString(@"请求失败"));
        }
        
    }FailureBlock:^(NSError *error){
        
        [SVProgressHUD dismiss];
        
    }];
}

-(BogoRechargeTopView *)topView{
    if (!_topView) {
        _topView = [[NSBundle mainBundle]loadNibNamed:@"BogoRechargeTopView" owner:nil options:nil].lastObject;
    }
    return _topView;
}

-(BogoRechargePayMoneyCollection *)payMoneyView{
    if (!_payMoneyView) {
        _payMoneyView = [[BogoRechargePayMoneyCollection alloc]initWithFrame:CGRectMake(0, self.topView.bottom, kScreenW, kRealValue(240))];
    }
    return _payMoneyView;
}

-(BogoRechargePayTypeCollection *)payTypeView{
    if (!_payTypeView) {
        _payTypeView = [[BogoRechargePayTypeCollection alloc]initWithFrame:CGRectMake(0, self.payMoneyView.bottom, kScreenW, kRealValue(380))];
    }
    return _payTypeView;;
}

-(UIButton *)selectAgreeBtn{
    if (!_selectAgreeBtn) {
        _selectAgreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectAgreeBtn setImage:[UIImage imageNamed:@"bogo_recharge_normalAgree"] forState:UIControlStateNormal];
        [_selectAgreeBtn setImage:[UIImage imageNamed:@"bogo_recharge_selectAgree"] forState:UIControlStateSelected];
        [_selectAgreeBtn addTarget:self action:@selector(clickSelectAgreenBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectAgreeBtn;
}

-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        NSString *firstStr = ASLocalizedString(@"同意");
        NSString *secondStr = ASLocalizedString(@" 用户充值免责协议");
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",firstStr,secondStr]];
        
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0,  firstStr.length)];
        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#DE88FF"] range:NSMakeRange(firstStr.length,  secondStr.length)];
          
        
        
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _agreeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        [_agreeBtn setAttributedTitle:attributeString forState:UIControlStateNormal];
        [_agreeBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_agreeBtn addTarget:self action:@selector(clickAgreenBtn:) forControlEvents:UIControlEventTouchUpInside];
            
    }
    return _agreeBtn;
}

-(UIButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"bogo_recharge_payBg"] forState:UIControlStateNormal];
        [_payBtn setTitle:ASLocalizedString(@"立即支付") forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_payBtn addTarget:self action:@selector(clickPayBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (void)closeBtnAction{
    if (self.reDelegate && [self.reDelegate respondsToSelector:@selector(rechargeScrollView:didClickCloseBtn:)]) {
        [self.reDelegate rechargeScrollView:self didClickCloseBtn:self.closeBtn];
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenW, 20)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = ASLocalizedString(@"充值");
    }
    return _titleLabel;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenW - 40, 0, 40, 40)];
        [_closeBtn setImage:[UIImage imageNamed:@"lr_btn_ward_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

@end
