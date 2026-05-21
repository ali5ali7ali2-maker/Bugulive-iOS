//
//  BogoHomeViewController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLMSegmentManager.h"
#import "BogoHomeTopView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BogoHomeViewController : UIViewController

@property (nonatomic, assign) MLMSegmentHeadStyle style;
@property (nonatomic, assign) MLMSegmentLayoutStyle layout;
@property (nonatomic, strong) MLMSegmentHead *segHead;
@property (nonatomic, strong) MLMSegmentScroll *segScroll;
@property(nonatomic, weak) id<BogoHomeTopViewDelegate> topViewdelegate;
@end

NS_ASSUME_NONNULL_END
