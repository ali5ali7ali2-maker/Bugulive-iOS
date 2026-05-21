//
//  FDWKUserContentController.m
//  BogoShopKit
//
//  Created by bogokj on 2020/6/5.
//

#import "FDWKUserContentController.h"
#import "BogoAddressWebModel.h"
#import <MJExtension/MJExtension.h>

@interface FDWKUserContentController ()<WKScriptMessageHandler>

@end

@implementation FDWKUserContentController

- (instancetype)init{
    if (self = [super init]) {
        [self addScriptMessageHandler:self name:@"wap_intercept"];
        [self addScriptMessageHandler:self name:@"user_intercept"];
        [self addScriptMessageHandler:self name:@"user_refund_order"];
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@%@",message.name,message.body);
    if ([message.name isEqualToString:@"wap_intercept"]) {
        BogoAddressWebModel *model = [BogoAddressWebModel mj_objectWithKeyValues:message.body];
        [[NSNotificationCenter defaultCenter] postNotificationName:message.name object:model];
    }else if ([message.name isEqualToString:@"user_intercept"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:message.name object:message.body];
    }else if ([message.name isEqualToString:@"user_refund_order"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:message.name object:message.body];
    }
}

- (void)dealloc{
    [self removeScriptMessageHandlerForName:@"wap_intercept"];
    [self removeScriptMessageHandlerForName:@"user_intercept"];
    [self removeScriptMessageHandlerForName:@"user_refund_order"];
}

@end
