//
//  WinTipView.h
//  BuguLive
//
//  Created by bogokj on 2019/3/23.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WinTipView : BGBaseView

@property (nonatomic, strong) CustomMessageModel *model;

- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
