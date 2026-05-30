//
//  BogoSquareViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/10.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BaseViewController.h"
#import "MLMSegmentManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoSquareViewController : BaseViewController<MLMSegmentHeadDelegate>

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@property(nonatomic, copy) void (^clickSquareBtnBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
