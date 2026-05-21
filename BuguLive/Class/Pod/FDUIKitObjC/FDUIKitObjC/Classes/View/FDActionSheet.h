//
//  FDActionSheet.h
//  FDFoundationObjC
//
//  Created by fandongtongxue on 2020/2/27.
//

#import "FDPopView.h"
@class FDAction;

NS_ASSUME_NONNULL_BEGIN

@interface FDActionSheet : FDPopView

@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *backColor;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(FDAction *)action;

- (void)show:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
