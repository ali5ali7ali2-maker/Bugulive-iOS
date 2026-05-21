//
//  AccountRechargeModel.m
//  BuguLive
//
//  Created by hym on 2016/10/25.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "AccountRechargeModel.h"

@implementation PayTypeModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"payWayID" : @"id",
             @"descrStr": @"description",
             };
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"rule_list" : @"PayMoneyModel",
             };
}
@end

@implementation PayMoneyModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"payID" : @"id",
             };
}


@end

@implementation AccountRechargeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"pay_list" : @"PayTypeModel",
             @"rule_list" : @"PayMoneyModel",
             };
}

@end
