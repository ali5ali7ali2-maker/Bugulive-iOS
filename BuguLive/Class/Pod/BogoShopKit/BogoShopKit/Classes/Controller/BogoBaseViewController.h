//
//  BogoBaseViewController.h
//  UniversalApp
//
//  Created by bogokj on 2019/11/5.
//  Copyright © 2019 voidcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoRankSubViewControllerType) {
    BogoRankSubViewControllerTypeCharm,
    BogoRankSubViewControllerTypeWealth,
};

@interface BogoBaseViewController : UIViewController

- (void)backBtnAction:(UIButton *)sender;

@property(nonatomic, assign) BOOL isHideBack;

@end

NS_ASSUME_NONNULL_END
