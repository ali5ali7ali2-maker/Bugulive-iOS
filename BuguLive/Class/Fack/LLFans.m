//
//  LLFans.m
//  BuguLive
//
//  Created by 志刚杨 on 2019/11/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "LLFans.h"

@implementation LLFans
+(BOOL)isLikeMe
{
    if(![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]])
    {
        return NO;
    }
    
    return YES;
}
@end
