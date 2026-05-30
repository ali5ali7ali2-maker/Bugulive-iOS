//
//  MGShowLiveWishView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/12/14.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MGLiveWishModel.h"

@class MGShowLiveSubView;

NS_ASSUME_NONNULL_BEGIN

@interface MGShowLiveWishView : UIView<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, assign) BOOL isDragging;
@property(nonatomic, assign) BOOL isDecelerating;


@property(nonatomic, strong) NSTimer *rotateTimer;

@property(nonatomic, assign) CGPoint contentOffsetP;
@property(nonatomic, assign) NSInteger currentPageIndex;

@property(nonatomic, strong) MGShowLiveSubView *topWishView;
@property(nonatomic, strong) MGShowLiveSubView *middleWishView;
@property(nonatomic, strong) MGShowLiveSubView *bottomWishView;



-(void)requestModel:(NSString *)roomIDStr;

-(void)showView;

-(void)relayoutFrameOfSubViews;

@end

@interface MGShowLiveSubView : UIView

@property(nonatomic, strong) UIImageView *iconImgView;
@property(nonatomic, strong) UILabel *nameL;
@property(nonatomic, strong) UIView *tintLineView;
@property(nonatomic, strong) UIView *bgLineView;

@property(nonatomic, strong) UILabel *countL;

@property(nonatomic, strong) MGLiveWishModel *model;

-(void)requestModel;

@end

NS_ASSUME_NONNULL_END
