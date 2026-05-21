//
//  BOGOViewController.m
//  BogoPayKit
//
//  Created by fandongtongxue on 03/25/2020.
//  Copyright (c) 2020 fandongtongxue. All rights reserved.
//

#import "BOGOViewController.h"
#import <MJExtension/MJExtension.h>

@interface BOGOViewController ()

@end

@implementation BOGOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    BogoPayOrderModel *orderModel = [[BogoPayOrderModel alloc]init];
    orderModel.pay_info = @"alipay_sdk=alipay-sdk-php-20161101&app_id=2018030902341613&biz_content=%7B%22body%22%3A%22+%E9%87%91%E9%80%89%E6%B4%97%E6%8A%A4%E5%A5%97%E8%A3%85+%22%2C%22subject%22%3A+%22%E8%B7%91%E8%BD%A6+%E9%87%91%E9%80%89%E6%B4%97%E5%8F%91%E6%B0%B4+%22%2C%22out_trade_no%22%3A+%22100654_20200418153654_73307805%22%2C%22timeout_express%22%3A+%2230m%22%2C%22total_amount%22%3A+%22210.1%22%2C%22product_code%22%3A%22QUICK_MSECURITY_PAY%22%7D&charset=UTF-8&format=json&method=alipay.trade.app.pay&notify_url=http%3A%2F%2Fkh.zhang.shop.anbig.com%2Fapi%2Fnotify%2Falipay_app_notify&sign_type=RSA2&timestamp=2020-04-18+15%3A36%3A54&version=1.0&sign=WxPKuk7AjBF1UI91w9BnfXKNuaBDDz3h8yowjtSU7jwtbctk4bfac9xHCzru%2BX4%2BkgviRKMWdmLBvUe3%2F79PPtlgzLw%2Fgkw3P2VhMRb8YSftFJlLvAecr4%2BQLhwgjFzCvcKWuIHCblbB8mL8RDlu1yCxX4mfquEEdw17FcvRpugFBy7o65IK8yybTvsKaKq9KTZh1WwnZU%2F1tDadrbw0Pp5vE9RDRmA7YJs%2BQGUCz5ZUCT%2FP4%2BIQsNpQcxabHoVkjwVVwf7clsB8g%2B%2FUEJiKLnHINuF5GDs8WqLMevXBql7BOKNwp76FZzbGNetEIagg84rMrOsSHjsK%2B2aUUNQwSg%3D%3D";
    [[BogoPayManager defaultManager] pay:BogoPayTypeAliPay orderModel:orderModel];
    [[BogoPayManager defaultManager] setBogo_payResponseCallBack:^(BogoPayResponseModel * _Nonnull responseModel) {
        NSLog(@"%@",responseModel.mj_keyValues);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
