//
//  NewSmallVideoViewController.h
//  BuguLive
//
//  Created by 范东 on 2019/2/20.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "TYTabButtonPagerController.h"
#import "MLMSegmentManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface NewSmallVideoViewController : UIViewController<MLMSegmentHeadDelegate>

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

NS_ASSUME_NONNULL_END
