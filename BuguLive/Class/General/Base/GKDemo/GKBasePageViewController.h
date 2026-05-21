//
//  GKBasePageViewController.h
//  GKPageScrollViewDemo
//
//  Created by QuintGao on 2018/12/11.
//  Copyright © 2018 QuintGao. All rights reserved.
//

#import "GKDemoBaseViewController.h"
#import "GKPageScrollView.h"
#import "GKBaseListViewController.h"
#import "JXCategoryView.h"
#import "BGNoContentView.h"
#import "NewestViewController.h"
#import "BogoHomeTopView.h"
#import "BogoJXCategoryView.h"
@class LivingModel;
@class cuserModel;

NS_ASSUME_NONNULL_BEGIN

@interface GKBasePageViewController : GKDemoBaseViewController<GKPageScrollViewDelegate>

// pageScrollView
@property (nonatomic, strong) GKPageScrollView  *pageScrollView;

@property (nonatomic, strong) BogoJXCategoryView   *segmentView;
@property (nonatomic, strong) UIScrollView          *scrollView;

@property (nonatomic, strong) NSArray           *childVCs;
@property (nonatomic, strong) NSString *types;


@property (nonatomic, weak) id<PushToLiveControllerDelegate>delegate;
@property(nonatomic, weak) id<BogoHomeTopViewDelegate> topViewdelegate;

@property (nonatomic, assign) CGRect collectionViewFrame;

@property (nonatomic, copy) NSString        *cate_id;       // 话题分类ID

@property (nonatomic, copy) NSString *areaString;
@property (nonatomic, copy) NSString *sexString;
@property (nonatomic, copy) NSString *topicName;

- (void)loadDataWithPage:(int)page;

- (void)loadDataFromNet:(int)page;
@end

NS_ASSUME_NONNULL_END
