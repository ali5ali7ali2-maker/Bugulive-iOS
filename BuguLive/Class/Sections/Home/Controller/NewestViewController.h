//
//  NewestViewController.h
//  BuguLive
//
//  Created by fanwe2014 on 16/7/4.
//  Copyright © 2016年 xfg. All rights reserved.
//
#import "BGNoContentView.h"

@class LivingModel;
@class cuserModel;

@protocol PushToLiveControllerDelegate <NSObject>

// 跳转到直播界面
- (void)pushToLiveController:(LivingModel *)model modelArr:(NSArray *)modelArr isFirstJump:(BOOL)isFirstJump;
// 跳转到热门页
- (void)pushToNextControllerWithModel:(cuserModel *)model;

@end

@interface NewestViewController : BGBaseViewController

@property (nonatomic, weak) id<PushToLiveControllerDelegate>delegate;
@property (nonatomic, assign) CGRect collectionViewFrame;

@property (nonatomic, copy) NSString        *cate_id;       // 话题分类ID

@property (nonatomic, copy) NSString *areaString;
@property (nonatomic, copy) NSString *sexString;
@property (nonatomic, copy) NSString *topicName;

/**
 无内容视图
 */
@property (nonatomic, strong) BGNoContentView *noContentViews;

@property (nonatomic, strong) NSString *types;

- (void)loadDataWithPage:(int)page;

- (void)loadDataFromNet:(int)page;

@end
