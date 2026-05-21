//
//  BogoNetworkInitModel.m
//  BogoNetworkKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoNetworkInitModel.h"
#import <MJExtension/MJExtension.h>

@implementation BogoNetworkInitUrlModel

@end

@implementation BogoNetworkInitModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"vue_url":@"BogoNetworkInitUrlModel",@"h5_url":@"BogoNetworkInitUrlModel"};
}

@end
