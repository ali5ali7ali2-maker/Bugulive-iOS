//
//  FDPopView.h
//  FDUIKitObjC
//
//  Created by fandongtongxue on 2020/2/26.
//

#import "FDView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, FDPopType) {
    FDPopTypeCenter,
    FDPopTypeBottom,
    FDPopTypeTop,
};

@interface FDPopView : FDView

- (void)show:(UIView *)superView type:(FDPopType)type;

- (void)hide;

@end

NS_ASSUME_NONNULL_END
