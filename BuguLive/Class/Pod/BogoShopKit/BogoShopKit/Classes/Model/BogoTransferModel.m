//
//  BogoTransferModel.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoTransferModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoTransferModel

@dynamic key;
@dynamic value;

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"key":@"id",@"value":@"name"};
}

@end
