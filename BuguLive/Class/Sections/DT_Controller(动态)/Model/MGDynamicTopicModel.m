//
//  MGDynamicTopicModel.m
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/4.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "MGDynamicTopicModel.h"

@implementation MGDynamicTopicModel

+(instancetype)itemWithDic:(NSDictionary *)dic
{
    MGDynamicTopicModel *model = [[MGDynamicTopicModel alloc] initWithDictionary:dic];
//    [MGDynamicTopicModel modelWithDictionary:[dic valueForKey:@"data"]];
//
    
    //字典中嵌套数组的处理方式
    NSMutableArray *consultLists = [[NSMutableArray alloc] init];
    NSArray *list1 = [dic valueForKey:@"today_list"];
    for (NSDictionary *subDic in list1)
    {
        [consultLists addObject:[MGDynamicTopicSubModel modelWithDictionary:subDic]];
    }
    model.today_list = consultLists;
    
    
    return model;
}

@end



@implementation MGDynamicTopicSubModel

@end
