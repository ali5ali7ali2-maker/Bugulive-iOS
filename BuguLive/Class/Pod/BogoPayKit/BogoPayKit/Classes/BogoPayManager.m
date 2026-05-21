//
//  BogoPayModuleObjCManager.m
//  BogoPayModuleObjC
//
//  Created by 范东 on 2020/3/14.
//

#import "BogoPayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BogoPayOrderModel.h"
#import "BogoPayResponseModel.h"
#import <MJExtension/MJExtension.h>
#import "FDUIKitObjC.h"
#import <WXApi.h>

@interface BogoPayManager ()<WXApiDelegate>

@end

static NSString * const BogoPayWeChatUniversalLinkInfoPlistKey = @"BogoPayWeChatUniversalLink";

static void BogoRegisterWeChatIfNeeded(NSString *appId) {
    static NSString *registeredAppId = nil;
    if (appId.length == 0) {
        return;
    }
    @synchronized ([BogoPayManager class]) {
        if ([registeredAppId isEqualToString:appId]) {
            return;
        }
        NSString *universalLink = [[NSBundle mainBundle] objectForInfoDictionaryKey:BogoPayWeChatUniversalLinkInfoPlistKey];
        if (![universalLink isKindOfClass:[NSString class]]) {
            universalLink = @"";
        } else {
            universalLink = [universalLink stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        if (universalLink.length > 0) {
            [WXApi registerApp:appId universalLink:universalLink];
            registeredAppId = [appId copy];
            return;
        }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if ([WXApi respondsToSelector:@selector(registerApp:)]) {
            [WXApi performSelector:@selector(registerApp:) withObject:appId];
        }
#pragma clang diagnostic pop
        registeredAppId = [appId copy];
        NSLog(@"Missing %@ in Info.plist, skipping WeChat universal link registration.", BogoPayWeChatUniversalLinkInfoPlistKey);
    }
}

@implementation BogoPayManager

+ (BogoPayManager *)defaultManager{
    static BogoPayManager *defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (void)pay:(BogoPayType)payType orderModel:(BogoPayOrderModel *)orderModel{
    if (payType == BogoPayTypeAliPay) {
        [[AlipaySDK defaultService] payOrder:orderModel.pay_info fromScheme:@"bugupayv1" callback:^(NSDictionary *resultDic) {
            BogoPayResponseModel *model = [BogoPayResponseModel mj_objectWithKeyValues:resultDic];
            model.isSuccess = model.resultStatus.intValue == 9000;
            if (self.bogo_payResponseCallBack) {
                self.bogo_payResponseCallBack(model);
            }
        }];
    }else{
        NSMutableDictionary *paramsDict = [NSMutableDictionary dictionary];
        NSArray *paramArray = [orderModel.pay_info componentsSeparatedByString:@"&"];
        for (NSString *param in paramArray) {
            if (param && param.length) {
                NSArray *parArr = [param componentsSeparatedByString:@"="];
                if (parArr.count == 2) {
                    [paramsDict setObject:parArr[1] forKey:parArr[0]];
                }
            }
        }
        if(paramsDict != nil){
            NSMutableString *retcode = [paramsDict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [paramsDict objectForKey:@"timestamp"];

                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [paramsDict objectForKey:@"partnerid"];
                req.prepayId            = [paramsDict objectForKey:@"prepayid"];
                req.nonceStr            = [paramsDict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [paramsDict objectForKey:@"package"];
                req.sign                = [paramsDict objectForKey:@"sign"];
                BogoRegisterWeChatIfNeeded([paramsDict objectForKey:@"appid"]);
                [WXApi sendReq:req completion:^(BOOL success) {
                    //do nothing

                    if (!success) {
                         [[FDHUDManager defaultManager] show:@"支付失败" ToView:[UIApplication sharedApplication].keyWindow];
                    }
                }];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[paramsDict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
            }
            else{
                [[FDHUDManager defaultManager] show:@"支付失败" ToView:[UIApplication sharedApplication].keyWindow];
            }
        }else{
            [[FDHUDManager defaultManager] show:@"支付失败" ToView:[UIApplication sharedApplication].keyWindow];
        }
    }
}

- (void)handlePayURL:(NSURL *)url callBack:(nonnull bogo_payResponseCallBack)bogo_payResponseCallBack{
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        BogoPayResponseModel *model = [BogoPayResponseModel mj_objectWithKeyValues:resultDic];
        if (bogo_payResponseCallBack) {
            bogo_payResponseCallBack(model);
        }
    }];
}

- (void)onResp:(BaseResp *)resp{
    BogoPayResponseModel *model = [[BogoPayResponseModel alloc]init];
    if([resp isKindOfClass:[PayResp class]]){
            //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg;
            
            switch (resp.errCode) {
                case WXSuccess:
                    strMsg = NSLocalizedString(@"支付结果：成功！", nil);
                    NSLog(NSLocalizedString(@"支付成功－PaySuccess，retcode = %d", nil), resp.errCode);
                    model.isSuccess = YES;
                    break;
                    
                default:
                    strMsg = [NSString stringWithFormat:NSLocalizedString(@"支付结果：失败！retcode = %d, retstr = %@", nil), resp.errCode,resp.errStr];
                    NSLog(NSLocalizedString(@"错误，retcode = %d, retstr = %@", nil), resp.errCode,resp.errStr);
                    model.isSuccess = NO;
                    break;
            }
        if (self.bogo_payResponseCallBack) {
            self.bogo_payResponseCallBack(model);
        }
        }else {
        }
}

@end
