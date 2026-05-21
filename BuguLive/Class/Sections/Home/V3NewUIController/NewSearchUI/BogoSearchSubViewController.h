//
//  BogoSearchSubViewController.h
//  BuguLive
//
//  Created by Mac on 2021/9/27.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BogoSearchSubViewController;
@class BogoSearchHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoSearchSubViewControllerDelegate <NSObject>

- (void)subVC:(BogoSearchSubViewController *)subVC headerView:(BogoSearchHeaderView *)headerView didClickAllBtn:(UIButton *)sender;

@end

typedef NS_ENUM(NSInteger, BogoSearchSubViewControllerType) {
    BogoSearchSubViewControllerTypeAll = 0,
    BogoSearchSubViewControllerTypeUser = 1,
    BogoSearchSubViewControllerTypeVideo = 2,
    BogoSearchSubViewControllerTypeDynamic = 3
};

@interface BogoSearchSubViewController : BGBaseViewController

@property(nonatomic, assign) BogoSearchSubViewControllerType type;

@property(nonatomic, copy) NSString *keyword;

@property(nonatomic, weak) id<BogoSearchSubViewControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
