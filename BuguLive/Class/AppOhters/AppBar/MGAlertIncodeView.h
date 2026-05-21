//
//  MGAlertIncodeView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/8/24.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGAlertIncodeView : UIView

@property(nonatomic, strong)  UIImageView *bgImgView;
@property(nonatomic, strong)  UILabel *titleImgView;

@property(nonatomic, strong) UIImageView *textImgView;

@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) UIButton *cancleBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, copy) void (^clickBlock)(NSInteger i);

@end

NS_ASSUME_NONNULL_END
