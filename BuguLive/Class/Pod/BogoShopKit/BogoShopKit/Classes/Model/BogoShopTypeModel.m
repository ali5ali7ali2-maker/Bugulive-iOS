//
//  BogoShopTypeModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "BogoShopTypeModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoShopTypeModel

@dynamic key;
@dynamic value;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"key":@"sc_id",@"value":@"title"};
}

@end
