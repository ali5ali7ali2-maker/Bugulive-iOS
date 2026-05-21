//
//  BogoGoodDetailNavView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDView.h"
@class BogoGoodDetailNavView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailNavViewDelegate <NSObject>

- (void)navView:(BogoGoodDetailNavView *)navView didClickBackBtn:(UIButton *)sender;
- (void)navView:(BogoGoodDetailNavView *)navView didClickShareBtn:(UIButton *)sender;
- (void)navView:(BogoGoodDetailNavView *)navView didClickGoodBtn:(UIButton *)sender;
- (void)navView:(BogoGoodDetailNavView *)navView didClickDetailBtn:(UIButton *)sender;

@end

@interface BogoGoodDetailNavView : FDView

@property(nonatomic, assign) CGFloat backAlpha;

@property(nonatomic, weak) id<BogoGoodDetailNavViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
