//
//  BGShopViewController.h
//  BuguLive
//
//  Created by 志刚杨 on 2019/4/1.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BaseViewController.h"
#import "MLMSegmentManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface BGShopViewController : BGBaseViewController

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;

@end

NS_ASSUME_NONNULL_END
