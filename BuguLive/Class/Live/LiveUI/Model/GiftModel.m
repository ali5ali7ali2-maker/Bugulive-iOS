//
//  GiftModel.m
//  BuguLive
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import "GiftModel.h"

@implementation GiftModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{
             @"ID" : @"id",
             };
}

+(NSDictionary *)mj_objectClassInArray{
    return @{@"anim_cfg":@"AnimateConfigModel"};
}

@end
