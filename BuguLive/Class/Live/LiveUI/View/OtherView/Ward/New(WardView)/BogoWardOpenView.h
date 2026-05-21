//
//  BogoWardOpenView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseView.h"

@class WardPrivilegeButton;
NS_ASSUME_NONNULL_BEGIN

typedef void(^clickFAQBtnBlock)(void);
typedef void(^clickWardListBtnBlock)(void);
typedef void(^clickOpenViewBtnBlock)(NSString *currentId);
typedef void(^clickPrivilegeBtnBlock)(NSString *htmlString, WardPrivilegeButton *button, BOOL isLast);

@interface BogoWardOpenView : BGBaseView

- (instancetype)initWithFrame:(CGRect)frame UserId:(NSString *)userId;

- (void)show:(UIView *)superView;

- (void)hide;

- (void)setClickFAQBtnBlock:(clickFAQBtnBlock)clickFAQBtnBlock;

- (void)setClickWardListBtnBlock:(clickWardListBtnBlock)clickWardListBtnBlock;

- (void)setClickOpenViewBtnBlock:(clickOpenViewBtnBlock)clickOpenBtnBlock;

- (void)setClickPrivilegeBtnBlock:(clickPrivilegeBtnBlock)clickPrivilegeBtnBlock;


@end

NS_ASSUME_NONNULL_END
