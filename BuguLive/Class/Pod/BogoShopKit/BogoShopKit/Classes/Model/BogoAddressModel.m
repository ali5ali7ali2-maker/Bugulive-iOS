//
//  BogoAddressModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "BogoAddressModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoProvinceModel

@dynamic code;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"code":@"id"};
}

@end

@implementation BogoCityModel

@dynamic code;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"code":@"id"};
}

@end

@implementation BogoAreaModel

@dynamic code;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"code":@"id"};
}

@end

@implementation BogoAddressModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"province_list":@"BogoProvinceModel",@"city_list":@"BogoCityModel",@"county_list":@"BogoAreaModel"};
}

@end
