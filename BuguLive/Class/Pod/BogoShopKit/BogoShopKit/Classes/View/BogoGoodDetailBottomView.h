//
//  BogoGoodDetailBottomView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDView.h"

@class BogoGoodDetailBottomView;
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailBottomViewDelegate <NSObject>

-(void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickShopBtn:(UIButton *)sender;
-(void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickCartBtn:(UIButton *)sender;
-(void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickCollectBtn:(UIButton *)sender;
-(void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickAddCartBtn:(UIButton *)sender;
-(void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickBuyBtn:(UIButton *)sender;
- (void)bottomView:(BogoGoodDetailBottomView *)bottomView didClickServiceBtn:(UIButton *)sender;
@end

@interface BogoGoodDetailBottomView : FDView

@property(nonatomic, weak) id<BogoGoodDetailBottomViewDelegate>delegate;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@end

NS_ASSUME_NONNULL_END
