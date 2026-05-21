//
//  UIImage+CY.m
//  BuguLive
//
//  Created by 志刚杨 on 2022/7/27.
//  Copyright © 2022 xfg. All rights reserved.
//

#import "UIImage+CY.h"

@implementation UIImage (CY)
+ (nullable UIImage *)imageNamedL:(NSString *)name
{
    NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:KAppLanguage];
    if([lang isEqualToString:@"zh-Hans"])
    {
        lang = @"";
    }
    else
    {
        lang = @"_en";
    }
    
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",name,lang]];
}
@end
