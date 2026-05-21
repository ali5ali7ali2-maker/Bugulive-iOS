//
//  BogoHomeSubTitleView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/3/18.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ContributionListViewController.h"
#import "LeaderboardViewController.h"
#import "MSmallVideoVC.h"
#import "PKBattleViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoHomeSubTitleView : UIView

@property(nonatomic, strong) UIControl *listControl;//榜单
@property(nonatomic, strong) UIControl *pkControl;//pk对战
@property(nonatomic, strong) UIControl *videoControl;//小视频

@end

NS_ASSUME_NONNULL_END
