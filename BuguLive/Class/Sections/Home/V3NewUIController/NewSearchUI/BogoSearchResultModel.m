//
//  BogoSearchResultModel.m
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoSearchResultModel.h"

@implementation BogoSearchResultModel

+(NSDictionary *)mj_objectClassInArray{
    return @{@"user":@"SenderModel",@"dynamic":@"WBModel",@"weibo":@"SmallVideoListModel"};
}

@end
