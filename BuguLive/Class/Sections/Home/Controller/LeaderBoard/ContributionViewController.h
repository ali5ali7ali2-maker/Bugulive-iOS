//
//  ContributionViewController.h
//  BuguLive
//
//  Created by yy on 16/10/18.
//  Copyright © 2016年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListDayViewController.h"

#import "MLMSegmentManager.h"

@interface ContributionViewController : BGBaseViewController

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;

@property (nonatomic, strong) SegmentView *contriSegmentView;
@property (assign, nonatomic) BOOL                        isHiddenTabbar;
@property (nonatomic, strong) ListDayViewController       *ContriDayViewController;      //日榜
@property (nonatomic, strong) ListDayViewController       *ContriMonthViewController;    //月榜
@property (nonatomic, strong) ListDayViewController       *ContriTotalViewController;    //总榜

@end
