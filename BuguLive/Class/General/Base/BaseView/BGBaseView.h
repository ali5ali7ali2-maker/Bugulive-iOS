//
//  BGBaseView.h
//  BuguLive
//
//  Created by xfg on 2017/6/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BGNoContentView;

@interface BGBaseView : UIView

/**
 网络请求
 */
@property (nonatomic, strong) NetHttpsManager *httpsManager;

/**
 全局参数控制
 */
@property (nonatomic, strong) GlobalVariables *BuguLive;

/**
 指示器
 */
@property (nonatomic, strong) MBProgressHUD   *proHud;

/**
 无内容视图
 */
@property (nonatomic, strong) BGNoContentView *noContentView;

/**
 显示指示器
 */
- (void)showMyHud;

/**
 隐藏指示器
 */
- (void)hideMyHud;

/**
 显示 无内容视图
 */
- (void)showNoContentViewOnView:(UIView *)view;

/**
 隐藏 无内容视图
 */
- (void)hideNoContentViewOnView:(UIView *)view;


@property (nonatomic, strong) UIView *shadowViews;

@property(nonatomic, copy) void (^clickShadowBlock)(BOOL click);

- (void)show:(UIView *)superView;

- (void)show:(UIView *)superView frame:(CGRect)frame;

- (void)hide;


@end
