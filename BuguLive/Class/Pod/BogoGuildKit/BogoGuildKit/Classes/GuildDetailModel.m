//
//  GuildDetailModel.m
//
//
//  Created by JSONConverter on 2021/09/28.
//  Copyright © 2021年 JSONConverter. All rights reserved.
//

#import "GuildDetailModel.h"
#import <MJExtension/MJExtension.h>

@implementation GuildDetailModel

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"family_info":@"GuildDetailModelFamily_info",@"lists":@"GuildDetailModelLists"};
}

@end

@implementation GuildDetailModelLists

@end

@implementation GuildDetailModelFamily_info

@end
