//
//  BogoPayTypeModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/25.
//

#import "BogoPayTypeModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoPayTypeModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"pt_id":@"id"};
}

@end
