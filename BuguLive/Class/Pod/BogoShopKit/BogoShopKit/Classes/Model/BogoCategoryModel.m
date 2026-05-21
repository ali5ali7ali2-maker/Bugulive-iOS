//
//  BogoCategoryModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/15.
//

#import "BogoCategoryModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoCategoryModel
@dynamic key;
@dynamic value;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"key":@"sc_id",@"value":@"title",@"parentKey":@"pid",@"parentValue":@"title"};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"children":@"BogoCategoryModel"};
}

@end
