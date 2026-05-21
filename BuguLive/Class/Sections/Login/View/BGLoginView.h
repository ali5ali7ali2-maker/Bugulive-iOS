//
//  BGLoginView.h
//  BuguLive
//
//  Created by bugu on 2019/12/10.
//  Copyright © 2019 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ULGView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BGLoginView : UIView

@property(nonatomic, copy) void (^clickLoginBlock)(NSInteger i);
@property(nonatomic, copy) void (^clickVistorBlock)(BOOL isClickVistoers);
@property(nonatomic, copy) void (^clickReigsterBlock)(BOOL clickRegister);
@property(nonatomic, copy) void (^clickForgetPWBlock)(BOOL clickForget);

@property(nonatomic, strong) UIButton *codeBtn;

@property(nonatomic, strong) UITextField *phoneText;
@property(nonatomic, strong) UITextField *codeText;

@end

NS_ASSUME_NONNULL_END
