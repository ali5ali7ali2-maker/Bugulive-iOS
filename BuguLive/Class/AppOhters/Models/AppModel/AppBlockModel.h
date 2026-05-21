//
//  AppBlockModel.h
//  BuguLive
//
//  Created by xfg on 2017/6/7.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseModel.h"

@interface AppBlockModel : BGBaseModel

+ (instancetype)manager;

@property (nonatomic, strong) NSDictionary *retDict;

@end
