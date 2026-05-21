//
//  GiftModel.h
//  BuguLive
//
//  Created by xfg on 16/5/20.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : NSObject

@property (nonatomic, assign) NSInteger     ID;
@property (nonatomic, assign) NSInteger     diamonds;
@property (nonatomic, copy) NSString        *score_fromat;  // 增加的经验值
@property (nonatomic, copy) NSString        *icon;
@property (nonatomic, assign) NSInteger     is_plus;        // 收到礼物时是否需要叠加
@property (nonatomic, assign) NSInteger     is_much;        // 这个礼物是否可以连发
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, assign) float         score;
@property (nonatomic, assign) NSInteger     sort;
@property (nonatomic, assign) NSInteger     ticket;
@property (nonatomic, assign) BOOL          isSelected;     // 是否选中
@property (nonatomic, assign) NSInteger is_lucky; //是否是幸运礼物
@property (nonatomic, assign) int more_multiple;//中奖最高倍数;
@property (nonatomic, strong) NSArray *list;//分类下面的礼物数组
@property(nonatomic, strong) NSString *type;

@property(nonatomic, strong) NSString *animated_url;
/// 0:普通礼物 1:gif礼物 2:大型动画礼物
@property(nonatomic, assign) NSInteger is_animated;
@property(nonatomic, strong) NSString *num;

@property(nonatomic, strong) NSArray <AnimateConfigModel *>*anim_cfg;



@end
