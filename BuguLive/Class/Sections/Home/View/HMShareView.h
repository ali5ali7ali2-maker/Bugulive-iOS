//
//  HMShareView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/2.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol HMShareViewDelegate <NSObject>

- (void)clickShareViewBtn:(UMSocialPlatformType)type;

- (void)clickShareViewReportBtn;

@end

@interface HMShareView : BGBaseView

@property (nonatomic, assign) id<HMShareViewDelegate> delegate;



/**
 展示分享弹窗
 
 @param superView 父视图
 @param isNeedReport 是否需要举报按钮
 */
- (void)show:(UIView *)superView isNeedReport:(BOOL)isNeedReport;

/**
 隐藏分享弹窗
 */
- (void)hide;

@end

NS_ASSUME_NONNULL_END
