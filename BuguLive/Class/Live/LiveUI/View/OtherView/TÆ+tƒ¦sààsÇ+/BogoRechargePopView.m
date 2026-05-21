//
//  BogoRechargePopView.m
//  BuguLive
//
//  Created by Mac on 2021/9/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargePopView.h"
#import "BogoRechargeScrollView.h"
#import <StoreKit/StoreKit.h>//内购

@interface BogoRechargePopView ()<BogoRechargeDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>

@property(nonatomic, strong) BogoRechargeScrollView *scrollView;
@property (nonatomic, strong) SKProductsRequest * request;

@end

@implementation BogoRechargePopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
    }
    return self;
}

- (void)dealloc{
    if (self.request)
    {
        [self.request cancel];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

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
    [[NetHttpsManager manager] POSTWithParameters:dict SuccessBlock:^(NSDictionary *responseJson) {
        
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
        [FanweMessage alert:ASLocalizedString(@"支付成功")];
    }
    else
    {
        [FanweMessage alert:ASLocalizedString(@"支付失败")];
    }
}

- (void)rechargeScrollView:(BogoRechargeScrollView *)rechargeScrollView didClickCloseBtn:(UIButton *)sender{
    [self hide];
}

-(BogoRechargeScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[BogoRechargeScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW , kScreenH - kRealValue(180))];
        _scrollView.reDelegate = self;
        _scrollView.isRecharge = NO;
    }
    return _scrollView;
}

@end
