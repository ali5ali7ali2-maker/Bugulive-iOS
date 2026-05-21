//
//  RoomUserInfo.m
//  UniversalApp
//
//  Created by bogokj on 2019/8/1.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import "RoomUserInfo.h"

@implementation RoomUserInfo

- (NSString *)description{
    return [NSString stringWithFormat:@"%@",[self mj_JSONObject]];
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"ranking_three":@"RoomUserInfo"};
}

@end
