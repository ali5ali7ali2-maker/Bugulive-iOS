//
//  HMCenterPopView.h
//  BuguLive
//
//  Created by 范东 on 2019/1/16.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "BGBaseView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HMCenterPopViewBtnType) {
    HMCenterPopViewBtnTypeLive,
    HMCenterPopViewBtnTypeVideo,
    HMCenterPopViewBtnTypeDynamic,
    HMCenterPopViewBtnTypeClose
};

typedef void(^clickPopViewBtnBlock)(HMCenterPopViewBtnType type);

@interface HMCenterPopView : BGBaseView
@property (weak, nonatomic) IBOutlet QMUIButton *liveBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *videoBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *dynamicBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *voice;

- (void)show:(UIView *)superView;

- (void)hide;

- (void)setClickPopViewBtnBlock:(clickPopViewBtnBlock)clickPopViewBtnBlock;

@end

NS_ASSUME_NONNULL_END
