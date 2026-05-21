//
//  SHomeNavView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/4/26.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHomeNavView : UIView

@property(nonatomic, strong) UIButton *backBtn;

@property(nonatomic, strong) UIButton *rightBtn;


@property(nonatomic, copy) void(^clickBtnBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
