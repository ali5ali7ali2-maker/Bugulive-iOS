//
//  BogoYounthModePopView.h
//  AFNetworking
//
//  Created by 宋晨光 on 2021/9/11.
//

#import <UIKit/UIKit.h>

#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoYounthModePopView : FDPopView

@property(nonatomic, strong) UIView *bgView;
@property(nonatomic, strong) UIImageView *topImgView;
@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UILabel *contentL;

@property(nonatomic, strong) UIButton *inYounthBtn;
@property(nonatomic, strong) UIButton *confirmBtn;

@property(nonatomic, copy) void (^clickInYounthBlock)(BOOL isComeIn);

@end

NS_ASSUME_NONNULL_END
