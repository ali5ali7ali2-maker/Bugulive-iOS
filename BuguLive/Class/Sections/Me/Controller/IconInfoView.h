//
//  IconInfoView.h
//  BuguLive
//
//  Created by voidcat on 2024/9/12.
//  Copyright © 2024 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IconInfoView : UIView
@property (nonatomic, strong) UIView *ageView;
@property (nonatomic, strong) UIImageView *levelView;
@property (nonatomic, strong) UIImageView *nobleView;
@property (nonatomic, strong) UIImageView *vipView;
@property (nonatomic, strong) UIImageView *certificationView;
- (void)updateConstraintsIfNeeded;
@end

NS_ASSUME_NONNULL_END
