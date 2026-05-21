//
//  CurrentLiveInfo.m
//  BuguLive
//
//  Created by xfg on 16/6/1.
//  Copyright © 2016年 xfg. All rights reserved.
//  

#import "CurrentLiveInfo.h"

@implementation Even_wheat

@end
@implementation Wheat_Type_List

@end

@implementation CurrentLiveInfo

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value使用[YYEatModel class]或YYEatModel.class或@"YYEatModel"没有区别
    return @{@"wheat_type_list" : [Wheat_Type_List class]};
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"wheat_type_list":[Wheat_Type_List class]};
}

@end
