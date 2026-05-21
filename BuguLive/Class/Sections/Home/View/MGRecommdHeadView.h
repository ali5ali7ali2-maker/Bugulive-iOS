//
//  MGRecommdHeadView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/10.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContributionViewController.h"
#import "ConsumptionViewController.h"
#import "SHomePageVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGRecommdHeadView : UIView<ListDayViewControllerDelegate>

@property(nonatomic, strong) UIControl *regalControl;//富豪
@property(nonatomic, strong) UIControl *charmControl;//魅力


@property(nonatomic, strong) UILabel *regalLabel;
@property(nonatomic, strong) UILabel *charmLabel;

@end

NS_ASSUME_NONNULL_END
