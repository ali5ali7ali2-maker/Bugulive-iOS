//
//  BogoRefundReasonModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoRefundReasonModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoRefundReasonModel

@dynamic key;
@dynamic value;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"key":@"id",@"value":@"reason_name"};
}

@end
