//
//  UserHomeModel.m
//
//
//  Created by JSONConverter on 2021/09/17.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import "UserHomeModel.h"

@implementation UserHomeModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"cuser_list":@"UserHomeModelCuser_list",@"user":@"UserHomeModelUser"};
}

@end

@implementation UserHomeModelUser

@end

@implementation UserHomeModelCuser_list

@end
