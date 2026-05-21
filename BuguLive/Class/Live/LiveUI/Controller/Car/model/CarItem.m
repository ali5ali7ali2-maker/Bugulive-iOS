//
//  CarItem.m
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "CarItem.h"


@implementation CarModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"list" : @"CarItemModel",
             };
}

@end
@implementation CarItemModel



+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"carID" : @"id",
             };
}


@end
