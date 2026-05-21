//
//  GameGainModel.h
//  BuguLive
//
//  Created by 布谷 on 2017/8/8.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseModel.h"

@interface GameGainModel : BGBaseModel

@property (nonatomic, copy) NSString * user_diamonds;
@property (nonatomic, copy) NSString * gain;
@property (nonatomic, strong) NSMutableArray *gift_list;

@end
