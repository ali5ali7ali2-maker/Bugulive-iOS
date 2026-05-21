//
//  MGLiveRechargeView.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/8/5.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGLiveRechargeView.h"

#import "MGLiveRechargeCell.h"

@implementation MGLiveRechargeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kClearColor;
        self.nowMainColor = [UIColor colorWithRed:166/255 green:96/255 blue:255/255 alpha:1];
        self.isSelectAgree = NO;
        self.money = @"0";
        self.listArr = [NSMutableArray array];
        [self setUpView];
        [self requestModel];
    }
    return self;
}

-(void)setUpView{
    
    UIView *bgTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kRealValue(50))];
    bgTopView.backgroundColor = kWhiteColor;
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:bgTopView.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(6,6)];//圆角大小
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = bgTopView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    bgTopView.layer.mask = maskLayer1;
    
//    bgTopView.layer.masksToBounds = YES;
//    bgTopView.layer.cornerRadius = kRealValue(4);
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, bgTopView.bottom,kScreenW, self.height - bgTopView.height)];
    _bgView.backgroundColor = kWhiteColor;
    
    UILabel *titleL = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW / 2, kRealValue(44))];
    titleL.centerX = kScreenW / 2;
    titleL.text = ASLocalizedString(@"钻石充值");
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.font = [UIFont boldSystemFontOfSize:16];
    _titleL = titleL;
    
    UIButton *payTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    payTitleBtn.frame = CGRectMake(0, bgTopView.bottom, kScreenW, kRealValue(40));
    [payTitleBtn setTitle:ASLocalizedString(@"充值")forState:UIControlStateNormal];
    payTitleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [payTitleBtn setTitleColor:self.nowMainColor forState:UIControlStateNormal];
    
    UILabel *balanceL = [[UILabel alloc]init];
    balanceL.frame = CGRectMake(kRealValue(15), payTitleBtn.bottom + kRealValue(5), kScreenW * 0.8, kRealValue(30));
    balanceL.font = [UIFont boldSystemFontOfSize:18];
    balanceL.textColor = [UIColor colorWithHexString:@"#333333"];
    _balanceL = balanceL;
    
    [self addSubview:bgTopView];
    [self addSubview:self.bgView];
    [self addSubview:payTitleBtn];
    [self addSubview:titleL];
    [self addSubview:_balanceL];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, balanceL.bottom, kScreenW, kRealValue(200)) collectionViewLayout:layout];
    [_collectionView registerClass:[MGLiveRechargeCell class] forCellWithReuseIdentifier:NSStringFromClass([MGLiveRechargeCell class])];
    _collectionView.backgroundColor = kWhiteColor;
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _collectionView.bottom + kRealValue(15), kScreenW, kRealValue(50))];;
    _scrollView.backgroundColor = kWhiteColor;;
    _scrollView.contentSize = CGSizeMake(kScreenW * 1.2, 0);
    [self addSubview:self.scrollView];
    
    
    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    selectBtn.frame = CGRectMake(_balanceL.left, _scrollView.bottom + kRealValue(10), kRealValue(20), kRealValue(20));
    [selectBtn addTarget:self action:@selector(clickSelectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setImage:[UIImage imageNamed:@"com_radio_selected_1"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"com_radio_selected_2"] forState:UIControlStateSelected];
    
    UILabel *agreeLabel = [[UILabel alloc]initWithFrame:CGRectMake(selectBtn.right + kRealValue(10), 0, kScreenW *0.7, kRealValue(20))];
    agreeLabel.centerY = selectBtn.centerY;
    agreeLabel.userInteractionEnabled = YES;
    NSString *firstStr = ASLocalizedString(@"同意");
    NSString *secondStr = ASLocalizedString(@" 用户充值免责协议");
    
    NSString *contentStr = [NSString stringWithFormat:@"%@%@",firstStr,secondStr];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:contentStr];
    
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(0,  firstStr.length)];
    [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#9D63FF"] range:NSMakeRange(firstStr.length,  secondStr.length)];
    agreeLabel.attributedText = attributeString;
    agreeLabel.font = [UIFont systemFontOfSize:12];
    
    UITapGestureRecognizer *tapLabel = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAgreement:)];
    [agreeLabel addGestureRecognizer:tapLabel];
    
    [self addSubview:selectBtn];
    [self addSubview:agreeLabel];
}

-(void)clickSelectBtn:(UIButton *)sender{
    sender.selected = !sender.selected;
    self.isSelectAgree = sender.selected;
}

-(void)clickAgreement:(UITapGestureRecognizer *)sender{
    NSString *tmpUrlStr = [GlobalVariables sharedInstance].appModel.h5_url.url_recharge_agreement;
    BGMainWebViewController *tmpController = [BGMainWebViewController webControlerWithUrlStr:tmpUrlStr isShowIndicator:YES isShowNavBar:YES isShowBackBtn:YES isShowCloseBtn:NO];
    [[AppDelegate sharedAppDelegate] pushViewController:tmpController animated:YES];
}

-(void)requestModel{
    
    self.ruleListArr = [NSMutableArray array];
    
    NSMutableDictionary * parmDict = [NSMutableDictionary dictionary];
    [parmDict setObject:@"pay" forKey:@"ctl"];
    [parmDict setObject:@"recharge" forKey:@"act"];
    FWWeakify(self)
    [[NetHttpsManager manager]POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson) {
        FWStrongify(self)
        self.model = [AccountRechargeModel mj_objectWithKeyValues:responseJson];
        self.balanceL.text = [NSString stringWithFormat:ASLocalizedString(@"余额：%ld"),self.model.diamonds];
        if (self.model.pay_list.count)
        {
            PayTypeModel *model = [self.model.pay_list firstObject];
            if (model)
            {
                model.isSelect = YES;
            }
//            self.row = 1;
//            self.ruleListArr = [NSMutableArray arrayWithArray:self.model.pay_list];
//            self.ruleListArr = [NSMutableArray arrayWithArray:self.model.pay_list];
            self.ruleListArr = model.rule_list.count>0 ? model.rule_list : self.model.rule_list;
//            model.rule_list.count>0 ? model.rule_list : self.model.rule_list;
            [self resetScrollView];
            CGFloat viewWidth = kRealValue(200);
            _scrollView.contentSize = CGSizeMake(viewWidth * 3 * 1.1, 0);
        }
        
        if (self.model.rule_list.count) {

            self.listArr = [NSMutableArray arrayWithArray:self.model.rule_list];
//            self.ruleListArr = model.rule_list.count>0 ? model.rule_list : self.model.rule_list;
            [self.collectionView reloadData];
        }
        
    } FailureBlock:^(NSError *error) {
        
    }];
}

-(void)resetScrollView{
    [self.scrollView removeAllSubViews];
    
    CGFloat viewWidth = kRealValue(200);
    
    self.payBtnArray = [NSMutableArray array];
    
    for (int i = 0; i < self.model.pay_list.count; i ++ ) {
        
        PayTypeModel *model = [self.model.pay_list objectAtIndex:i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(kRealValue(15) + (viewWidth + 10) * i, 0, viewWidth, kRealValue(30))];
        [btn setTitle:model.name forState:UIControlStateNormal];
        btn.tag = 1000 + i;
        [btn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        [btn setTitleColor:self.nowMainColor forState:UIControlStateNormal];
        btn.backgroundColor = self.nowMainColor;
        btn.layer.cornerRadius = kRealValue(30 / 2);
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor = self.nowMainColor.CGColor;
        btn.layer.borderWidth = 0.5f;
        
        if (i == 0) {
            btn.selected = YES;
            btn.backgroundColor = self.nowMainColor;
        }else{
            btn.selected = NO;
            btn.backgroundColor = kWhiteColor;
        }
        
        [btn addTarget:self action:@selector(clickPayTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [self.payBtnArray addObject:btn];
        [self.scrollView addSubview:btn];
    }
}

-(void)clickPayTypeBtn:(UIButton *)sender{
    
    PayTypeModel *model = [self.model.pay_list objectAtIndex:sender.tag - 1000];

    for (PayTypeModel *model in self.model.pay_list)
    {
        model.isSelect = NO;
    }
    model.isSelect = YES;
    
    for (UIButton *btn in self.payBtnArray) {
        if (btn == sender) {
            sender.selected = YES;
            btn.backgroundColor = self.nowMainColor;
        }else{
            btn.selected = NO;
            btn.backgroundColor = kWhiteColor;
        }
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MGLiveRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MGLiveRechargeCell" forIndexPath:indexPath];
    if (indexPath.item < self.listArr.count) {
        PayMoneyModel *model = self.listArr[indexPath.item];
        [cell resetViewWithModel:model];
        cell.control.userInteractionEnabled = NO;
//        [cell.control addTarget:self action:@selector(clickControl:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isSelectAgree) {
        [FanweMessage alertHUD:ASLocalizedString(@"请先勾选是否同意用户充值免责协议")];
        return;
    }
    
    PayMoneyModel *model = self.listArr[indexPath.item];
    self.money = model.money_name;
    
    MGLiveRechargeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MGLiveRechargeCell" forIndexPath:indexPath];
    cell.selected = !cell.isSelected;
    
    [self payRequestNet:(int)indexPath.row wxPayNet:1];
//        __weak MGLiveRechargeView *weakSelf = self;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            weakSelf.hsClick = YES;
//        });
}

-(void)clickControl:(UIControl *)sender{
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat viewWidth = (kScreenW - kRealValue(15 * 4)) / 3;
    return CGSizeMake(viewWidth, kRealValue(70));
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}




#pragma mark 支付请求
- (void)payRequestNet:(int)indicate wxPayNet:(int)wxIndicate
{
    NSString *payID = @"";
    for (PayTypeModel *model in self.model.pay_list)
    {
        if (model.isSelect)
        {
            payID = [NSString stringWithFormat:@"%ld",(long)model.payWayID];
        }
    }
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
    
    [parmDict setObject:@"pay" forKey:@"ctl"];
    
    
    [parmDict setObject:@"pay" forKey:@"act"];
    [parmDict setObject:payID forKey:@"pay_id"];
    if (wxIndicate == 1 && indicate < self.ruleListArr.count)
    {
        PayMoneyModel *model = self.ruleListArr[indicate];
        [parmDict setObject:[NSString stringWithFormat:@"%ld",(long)model.payID] forKey:@"rule_id"];
        
        [parmDict setObject:[NSString stringWithFormat:@"%@",model.money] forKey:@"money"];
    }
    else
    {
        [parmDict setObject:self.money forKey:@"money"];
    }
    
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
                Pay_Model * model2 = [Pay_Model mj_objectWithKeyValues: configDic];
                NSString *orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",model2.order_spec, model2.sign, model2.sign_type];
                [self alipay:orderString block:nil];
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
                // 监听购买结果
                [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
                NSMutableDictionary *configDic = [NSMutableDictionary new];
                configDic = sdkDic[@"config"];
                self.pro_id = configDic[@"product_id"];
                //查询是否允许内付费
                if ([SKPaymentQueue canMakePayments])
                {
                    // 执行下面提到的第5步：
                    [self getProductInfowithprotectId:self.pro_id];
                }
                else
                {
                    [FanweMessage alert:ASLocalizedString(@"您已禁止应用内付费购买商品")];
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


#pragma marlk  支付宝支付
- (void)alipay:(NSString*)payinfo  block:(void(^)(SResBase* resb))block
{
    NSString *appScheme = AlipayScheme;
    
    [[AlipaySDK defaultService] payOrder:payinfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        SResBase* retobj = nil;
        
        if ( resultDic )
        {
            if ( [[resultDic objectForKey:@"resultStatus"] intValue] == 9000 )
            {
                retobj = [[SResBase alloc]init];
                retobj.msuccess = YES;
                retobj.mmsg = ASLocalizedString(@"支付成功");
                retobj.mcode = 1;
                //                block(retobj);
                [FanweMessage alert:[NSString stringWithFormat:@"%@",retobj.mmsg]];
                
                [self reloadAcount];
            }
            else
            {
                retobj = [SResBase infoWithString: [resultDic objectForKey:@"memo" ]];
                [FanweMessage alert:ASLocalizedString(@"支付失败")];
            }
        }
        else
        {
            retobj = [SResBase infoWithString: ASLocalizedString(@"支付出现异常")];
            [FanweMessage alert:ASLocalizedString(@"支付异常")];
        }
        
    }];
}

#pragma mark -- 苹果内购服务，下面的ProductId应该是事先在itunesConnect中添加好的，已存在的付费项目。否则查询会失败。
- (void)getProductInfowithprotectId:(NSString *)proId
{
    //这里填你的产品id，根据创建的名字
    //ProductIdofvip
    //ProductId
    NSMutableArray *proArr = [NSMutableArray new];
    [proArr addObject:proId];
    NSSet * set = [NSSet setWithArray:proArr];
    
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    self.request.delegate = self;
    [self.request start];
    
    NSLog(@"%@",set);
    NSLog(ASLocalizedString(@"请求开始请等待..."));
}

#pragma mark - 以上查询的回调函数，以上查询的回调函数
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSArray *myProduct = response.products;
    if (myProduct.count == 0)
    {
        [[BGHUDHelper sharedInstance] tipMessage:ASLocalizedString(@"无法获取产品信息，购买失败。")];
        [SVProgressHUD dismiss];
        return;
    }
    NSLog(@"productID:%@", response.invalidProductIdentifiers);
    NSLog(ASLocalizedString(@"产品付费数量:%lu"),(unsigned long)[myProduct count]);
    SKPayment * payment = [SKPayment paymentWithProduct:myProduct[0]];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - others SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased://交易完成
                NSLog(@"transactionIdentifier = %@", transaction.transactionIdentifier);
                [SVProgressHUD dismiss];
                [self completeTransaction:transaction];
                //[queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(ASLocalizedString(@"交易失败"));
                [self failedTransaction:transaction];
                //[queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://恢复已购买商品
                NSLog(ASLocalizedString(@"恢复已购买商品"));
                [self restoreTransaction:transaction];
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing://商品添加进列表
                NSLog(ASLocalizedString(@"商品添加进列表"));
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    // Your application should implement these two methods.
    NSLog(ASLocalizedString(@"---------进入了这里"));
    //    NSString * productIdentifier = transaction.payment.productIdentifier;
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData *data = [productIdentifier dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [data base64EncodedStringWithOptions:0];
    if ([productIdentifier length] > 0) {
        // 向自己的服务器验证购买凭证
        [self shoppingValidation:base64String];
    }
    // Remove the transaction from the payment queue.
    [SVProgressHUD dismiss];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark -- 向自己的服务器验证购买凭证
- (void)shoppingValidation : (NSString *)base64Str
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    [dict setObject:@"pay" forKey:@"ctl"];
    
    [dict setObject:@"iappay" forKey:@"act"];
    NSString *userid = [IMAPlatform sharedInstance].host.imUserId;
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:base64Str forKey:@"receipt-data"];
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [self reloadAcount];
        // [FanweMessage alert:ASLocalizedString(@"充值成功")];
    } FailureBlock:^(NSError *error) {
        
    }];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    [SVProgressHUD dismiss];
    if(transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(ASLocalizedString(@"购买失败"));
    }
    else
    {
        NSLog(ASLocalizedString(@"用户取消交易"));
        //[FanweMessage alert:ASLocalizedString(@"您已经取消交易")];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
    // 对于已购商品，处理恢复购买的逻辑
    //[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

// 支付结果的通知：
- (void)receiveResult:(NSString*)payid result:(BOOL)success message:(NSString*)message
{
    if ( success == YES )
    {
        [self reloadAcount];
        [FanweMessage alert:ASLocalizedString(@"支付成功")];
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"支付失败")];
    }
}

//支付成功刷新账户
- (void)paySuccess
{
    [self reloadAcount];
}

#pragma marlk 刷新账户
- (void)reloadAcount
{
    NSMutableDictionary *parmDict = [NSMutableDictionary dictionary];
//    if (_is_vip)
//    {
//        [parmDict setObject:@"vip_pay" forKey:@"ctl"];
//        [parmDict setObject:@"purchase" forKey:@"act"];
//    }
//    else
//    {
        [parmDict setObject:@"pay" forKey:@"ctl"];
        [parmDict setObject:@"recharge" forKey:@"act"];
//    }
    __weak MGLiveRechargeView *weakSelf = self;
    [[NetHttpsManager manager] POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ((NSNull *)responseJson != [NSNull null])
         {
//             if (_is_vip)
//             {
//                 weakSelf.model.vip_expire_time = [responseJson objectForKey:@"vip_expire_time"];
//                 weakSelf.model.is_vip = [responseJson integerForKey:@"is_vip"];
//             }
//             else
//             {
                 weakSelf.model.diamonds = [[responseJson objectForKey:@"diamonds"] doubleValue];
//             }
             self.balanceL.text = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"diamonds"]];
//             [weakSelf.tableView reloadData];
         }
     } FailureBlock:^(NSError *error)
     {
         
     }];
}

- (void)receiveChannelTypes:(NSArray<NSNumber *>*)types
{
//    [BGInterface selectChannel:_juBaoModel.withType];
}

- (BOOL)shouldAutorotate
{
    return YES;
}



#pragma mark - Show And Hide
- (void)show:(UIView *)superView{
    
    [self requestModel];
    
    [superView addSubview:self.shadowView];
    [superView addSubview:self];

    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH - self.height;
    }];
}

- (void)hide{
    
    
    
//    if (self.clickHideLiveWishBlock) {
//        self.clickHideLiveWishBlock();
//    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.shadowView.alpha = 1;
        self.y = kScreenH;
    } completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (UIView *)shadowView{
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        _shadowView.backgroundColor = kClearColor;
        _shadowView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}


@end
