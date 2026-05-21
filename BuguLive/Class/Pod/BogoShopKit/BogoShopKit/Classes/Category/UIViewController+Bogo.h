//
//  UIViewController+Bogo.h
//  BuGuDY
//
//  Created by bogokj on 2020/4/20.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (Bogo)<BackButtonHandlerProtocol>

//添加返回按钮
- (void)addBackButton;
@end

NS_ASSUME_NONNULL_END
