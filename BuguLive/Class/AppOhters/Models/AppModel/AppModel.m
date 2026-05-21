//
//  AppModel.m
//  ZCTest
//
//  Created by xfg on 16/2/17.
//  Copyright © 2016年 guoms. All rights reserved.
//

#import "AppModel.h"
@implementation VideoClassifiedModel

@end

@implementation AppModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"api_link" : @"ApiLinkModel",
             @"start_diagram" : @"AppAdModel",
             @"video_classified":@"VideoClassifiedModel"
             ,
             @"video_cate":@"DTTopicModel"
             };
}

-(NSString *)open_vip
{
    return @"1";
}

- (NSInteger)fb_app_api
{
    return 1;
}

//-(NSString *)agora_app_id
//{
//    return @"77dcbc8ef6be4feaaf4689099774a936";
//}

-(NSString *)agora_app_id
{
    return @"b1a8b2bc9d644e74bcc2dc27ae6cfda5";
}

//
//- (int)open_sts
//{
//    return 0;
//}

@end
