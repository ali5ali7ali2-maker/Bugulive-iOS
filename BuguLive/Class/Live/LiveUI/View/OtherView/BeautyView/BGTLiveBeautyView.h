//
//  BGTLiveBeautyView.h
//  BuguLive
//
//  Created by xfg on 2017/2/17.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGNameSlider.h"

@class BGTLiveBeautyView;

@protocol FWTLiveBeautyViewDelegate <NSObject>
@required

// 设置美颜类型
- (void)setBeauty:(BGTLiveBeautyView *)beautyView withBeautyName:(NSString *)beautyName;

// 设置美颜的值
- (void)setBeautyValue:(BGTLiveBeautyView *)beautyView;

@end

@interface BGTLiveBeautyView : UIView

@property (nonatomic, weak) id<FWTLiveBeautyViewDelegate> delegate;

@property (nonatomic, strong) UIView                    *beautyBgView;              // 美颜背景视图
@property (nonatomic, strong) UIView                    *beautyBtnContrianerView;   // 美颜按钮背景视图

// 参数调节
@property (nonatomic, readonly) BGNameSlider            *filterParam1;              // 参数1
@property (nonatomic, readonly) BGNameSlider            *filterParam2;              // 参数2
@property (nonatomic, readonly) BGNameSlider            *filterParam3;              // 参数2

@end
