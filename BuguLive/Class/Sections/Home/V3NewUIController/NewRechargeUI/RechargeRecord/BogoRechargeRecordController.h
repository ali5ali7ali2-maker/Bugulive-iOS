//
//  BogoRechargeRecordController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"
#import "MLMSegmentManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoRechargeRecordController : BGBaseViewController<MLMSegmentHeadDelegate>

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;



@end

NS_ASSUME_NONNULL_END
