//
//  BogoRechargeViewController.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/7.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargeViewController.h"

#import "BogoRechargeScrollView.h"
#import <StoreKit/StoreKit.h>//内购

#import "BogoRechargeRecordController.h"//收支记录

@interface BogoRechargeViewController ()<BogoRechargeDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property(nonatomic, strong) BogoRechargeScrollView *scrollView;
@property (nonatomic, strong) SKProductsRequest * request;

@end

@implementation BogoRechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setUpView];
    
    self.title =ASLocalizedString( @"充值");
    self.view.backgroundColor = kWhiteColor;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:ASLocalizedString(@"收支记录") style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"],NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"],NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
    
    [self setupBackBtnWithBlock:nil];
    
    
}

-(void)clickRightItem:(UIBarButtonItem *)sender{
    BogoRechargeRecordController *vc = [BogoRechargeRecordController new];
    [[AppDelegate sharedAppDelegate]pushViewController:vc animated:YES];
}

-(void)setUpView{
    
//    [self.scrollView addSubview:self.topView];
    self.scrollView.contentSize = CGSizeMake(0, kScreenH - kTopHeight);
    [self.view addSubview:self.scrollView];
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
    
    WeakSelf
    [self.httpsManager POSTWithParameters:parmDict SuccessBlock:^(NSDictionary *responseJson)
     {
         if ((NSNull *)responseJson != [NSNull null])
         {
            
             weakSelf.scrollView.diamondStr = [NSString stringWithFormat:@"%@",[responseJson objectForKey:@"diamonds"]];
         }
     } FailureBlock:^(NSError *error)
     {
        [FanweMessage alertHUD:ASLocalizedString(@"充值验证失败，请联系客服")];
     }];
}




#pragma marlk  支付宝支付

-(void)alipay:(NSString *)payinfo{
    
    [self alipay:payinfo block:nil];
}

- (void)alipay:(NSString*)payinfo  block:(void(^)(SResBase* resb))block
{
    NSString *appScheme = AlipayScheme;
    
    [[AlipaySDK defaultService] payOrder:payinfo fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        
        SResBase* retobj = nil;
        
        if (resultDic)
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

-(void)checkProid:(NSString *)pro_id{
    // 监听购买结果
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    
    //查询是否允许内付费
    if ([SKPaymentQueue canMakePayments])
    {
        // 执行下面提到的第5步：
        [self getProductInfowithprotectId:pro_id];
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"您已禁止应用内付费购买商品")];
    }
}

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
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if (!receiptData) {
        [FanweMessage alertHUD:ASLocalizedString(@"购买凭证获取失败")];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        return;
    }
    
    NSString *base64String = [receiptData base64EncodedStringWithOptions:0];
    [self shoppingValidation:base64String];
    
    [SVProgressHUD dismiss];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark -- 向自己的服务器验证购买凭证
- (void)shoppingValidation : (NSString *)base64Str
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
//    if (_is_vip)
//    {
//        [dict setObject:@"vip_pay" forKey:@"ctl"];
//    }
//    else
//    {
        [dict setObject:@"pay" forKey:@"ctl"];
//    }
    [dict setObject:@"iappay" forKey:@"act"];
    NSString *userid = [IMAPlatform sharedInstance].host.imUserId;
    [dict setObject:userid forKey:@"user_id"];
    [dict setObject:base64Str forKey:@"receipt-data"];
    [self.httpsManager POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        [self reloadAcount];
        // [FanweMessage alert:ASLocalizedString(@"充值成功")];
    } FailureBlock:^(NSError *error) {
        [FanweMessage alertHUD:ASLocalizedString(@"充值验证失败，请联系客服")];
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
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
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

- (void)receiveChannelTypes:(NSArray<NSNumber *>*)types
{
//    [BGInterface selectChannel:_juBaoModel.withType];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    NSLog(ASLocalizedString(@"释放充值"));
    if (self.request)
    {
        [self.request cancel];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(BogoRechargeScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[BogoRechargeScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH - kTopHeight - MG_BOTTOM_MARGIN)];
        _scrollView.reDelegate = self;
        _scrollView.isRecharge = YES;
    }
    return _scrollView;
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
