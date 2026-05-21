//
//  WardOpenView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/29.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"
@class WardPrivilegeButton;
NS_ASSUME_NONNULL_BEGIN

typedef void(^clickFAQBtnBlock)(void);
typedef void(^clickWardListBtnBlock)(void);
typedef void(^clickOpenViewBtnBlock)(NSString *currentId);
typedef void(^clickPrivilegeBtnBlock)(NSString *htmlString, WardPrivilegeButton *button, BOOL isLast);

@interface WardOpenView : BGBaseView

- (instancetype)initWithFrame:(CGRect)frame UserId:(NSString *)userId;

- (void)show:(UIView *)superView;

- (void)hide;

- (void)setClickFAQBtnBlock:(clickFAQBtnBlock)clickFAQBtnBlock;

- (void)setClickWardListBtnBlock:(clickWardListBtnBlock)clickWardListBtnBlock;

- (void)setClickOpenViewBtnBlock:(clickOpenViewBtnBlock)clickOpenBtnBlock;

- (void)setClickPrivilegeBtnBlock:(clickPrivilegeBtnBlock)clickPrivilegeBtnBlock;

@end

NS_ASSUME_NONNULL_END
