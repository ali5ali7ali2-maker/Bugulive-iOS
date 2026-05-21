//
//  MGLoginView.h
//  BuguLive
//
//  Created by 宋晨光 on 2019/7/16.
//  Copyright © 2019年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGLoginView : UIView

@property(nonatomic, strong) UIButton *loginBtn;

@property(nonatomic, strong) UIButton *wxLoginBtn;

@property(nonatomic, strong) UIButton *infoBtn;

@property(nonatomic, strong) UIButton *codeBtn;

@property(nonatomic, strong) UITextField *phoneText;
@property(nonatomic, strong) UITextField *codeText;

@property(nonatomic, copy) void (^clickLoginBlock)(NSInteger i);

@property(nonatomic, strong) UIImageView *bgImgView;

@property(nonatomic, strong) UILabel *otherL;

@property(nonatomic, strong) UIView *loginView;

@property(nonatomic, strong) QMUIButton *wxBtn;

@property(nonatomic, strong) QMUIButton *qqBtn;

@property(nonatomic, strong) NSMutableArray *loginArr;


@end

NS_ASSUME_NONNULL_END
