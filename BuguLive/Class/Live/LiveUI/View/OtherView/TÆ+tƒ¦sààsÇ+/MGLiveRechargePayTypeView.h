//
//  MGLiveRechargePayTypeView.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/8/5.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLiveRechargePayTypeView : UIView

@property(nonatomic, strong) NSArray *listArr;
@property(nonatomic, strong) UIScrollView *scrollView;


- (void)show:(UIView *)superView;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
