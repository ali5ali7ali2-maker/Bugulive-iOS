//
//  BogoNewSquareViewController.h
//  BuguLive
//
//  Created by Mac on 2021/9/28.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BogoSquareViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoNewSquareViewController : BGBaseViewController

@property(nonatomic, copy) void (^clickSquareBtnBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
