//
//  BogoChoiceAreaModel.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/9/25.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoChoiceAreaModel.h"

@implementation BogoChoiceAreaModel
-(NSString *)area_code
{
    return [_area_code stringByReplacingOccurrencesOfString:@"+" withString:@""];

}
@end
