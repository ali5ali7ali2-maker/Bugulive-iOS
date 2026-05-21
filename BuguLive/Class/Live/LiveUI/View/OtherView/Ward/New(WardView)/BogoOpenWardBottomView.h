//
//  BogoOpenWardBottomView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/10/9.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoOpenWardBottomView : UIView

@property(nonatomic, strong) UILabel *myDiamondL;
@property(nonatomic, strong) QMUIButton *timeBtn;

@property(nonatomic, strong) QMUIButton *openBtn;

//我是不是这主播的守护 1是守护者2不是
@property(nonatomic, strong) NSString *is_guartian;
@property(nonatomic, strong) NSString *guartian_time;
@property(nonatomic, strong) NSString *diamondStr;

@property(nonatomic, strong) NSString *guartian_icon;

@property(nonatomic, copy) void (^clickOpenBtnBlock)(BOOL isClick);

@end

NS_ASSUME_NONNULL_END
