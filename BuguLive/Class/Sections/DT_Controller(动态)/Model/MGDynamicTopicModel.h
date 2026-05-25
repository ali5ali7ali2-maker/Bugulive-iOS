//
//  MGDynamicTopicModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/4.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MGDynamicTopicSubModel;

@interface MGDynamicTopicModel : MGBaseModel

@property(nonatomic, strong) NSString *t_id;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *num;
@property(nonatomic, strong) NSArray *today_list;
@property(nonatomic, strong) NSString *today;
@property(nonatomic, strong) NSString *img;

+(instancetype)itemWithDic:(NSDictionary *)dic;

@end

@interface MGDynamicTopicSubModel : MGBaseModel

@property(nonatomic, strong) NSString *id;
@property(nonatomic, strong) NSString *cover_url;

@end

NS_ASSUME_NONNULL_END
