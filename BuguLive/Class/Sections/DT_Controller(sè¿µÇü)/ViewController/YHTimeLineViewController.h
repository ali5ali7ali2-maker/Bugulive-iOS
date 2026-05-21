//
//  YHTimeLineViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/8/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BaseViewController.h"

#import "MLMSegmentManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface YHTimeLineViewController : BaseViewController

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;

-(void)handleSearchEvent;

@end

NS_ASSUME_NONNULL_END
