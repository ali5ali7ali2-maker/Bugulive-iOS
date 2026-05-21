//
//  BogoAlertView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "FDUIKitObjC.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoAlertView : FDPopView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(FDAction *)action;

- (void)show:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
