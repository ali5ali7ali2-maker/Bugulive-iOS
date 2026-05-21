//
//  WardPopView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/28.
//  Copyright © 2019 xfg. All rights reserved.
//  守护PopView

#import "BGBaseView.h"
@class WardPopViewModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^clickOpenBtnBlock)(void);
typedef void(^clickWardPopViewCellBlock)(WardPopViewModel *model);

@interface WardPopView : BGBaseView

- (instancetype)initWithFrame:(CGRect)frame UserId:(NSString *)userID ResponseJson:(NSDictionary *)json;

//- (void)show:(UIView *)superView;
//
//- (void)hide;

- (void)setClickOpenBtnBlock:(clickOpenBtnBlock)clickOpenBtnBlock;

- (void)setClickWardPopViewCellBlock:(clickWardPopViewCellBlock)clickWardPopViewCellBlock;

@end

NS_ASSUME_NONNULL_END
