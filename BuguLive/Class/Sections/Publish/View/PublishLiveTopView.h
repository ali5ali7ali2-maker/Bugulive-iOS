//
//  PublishLiveTopView.h
//  BuguLive
//
//  Created by xgh on 2017/8/24.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import "BGBaseView.h"

#import <QMUIButton.h>

@class PublishLiveTopView;

@protocol PublishLiveTopDelegate <NSObject>

- (void)selectedTheClassirmAction;

- (void)closeThePublishLive:(PublishLiveTopView *)topView;

- (void)ispracychangeActionDelegate:(BOOL)ispraicy;

- (void)clickPasswordActionDelegate:(BOOL)password;

- (void)clickShopActionDelegate:(BOOL)shop;

- (void)classifyButtonActionDelegate;
@end


@interface PublishLiveTopView : BGBaseView<UITextFieldDelegate>
@property (nonatomic, assign)BOOL isCanLocation;

@property (nonatomic, assign)BOOL pravicy;

@property (nonatomic, assign)BOOL isShop;

@property (nonatomic, weak) id<PublishLiveTopDelegate>delegate;

@property (nonatomic, strong)QMUIButton *locationBtn;

@property (nonatomic, strong)QMUIButton *pravicyBtn;

@property (nonatomic, strong)QMUIButton *classifyBtn;

@property (nonatomic, strong)QMUIButton *passwordBtn;
@property(nonatomic, strong) NSString *password;

@property (nonatomic, strong)QMUIButton *closeBtn;

@property (nonatomic, copy)NSString *locationCityString;
@property (nonatomic, copy)NSString *provinceSrting;

@property(nonatomic, strong) QMUIButton *shopBtn;



@end
