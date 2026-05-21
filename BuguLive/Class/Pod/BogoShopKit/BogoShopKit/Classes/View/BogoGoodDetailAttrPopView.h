//
//  BogoGoodDetailAttrPopView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "FDPopView.h"
@class BogoCommodityDetailModel;
@class BogoGoodDetailAttrPopView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailAttrPopViewDelegate <NSObject>

-(void)popView:(BogoGoodDetailAttrPopView *)popView didClickBuyBtn:(UIButton *)sender;
-(void)popView:(BogoGoodDetailAttrPopView *)popView didClickAddCartBtn:(UIButton *)sender;

@end

@interface BogoGoodDetailAttrPopView : FDPopView

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, weak) id<BogoGoodDetailAttrPopViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
