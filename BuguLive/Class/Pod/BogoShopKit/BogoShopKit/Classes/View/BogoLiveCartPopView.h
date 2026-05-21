//
//  BogoLiveCartPopView.h
//  BuGuDY
//
//  Created by bogokj on 2020/3/28.
//  Copyright © 2020 宋晨光. All rights reserved.
//

#import "FDUIKitObjC.h"
@class BogoLiveCartPopView;
#import "BogoLiveStartGoodListCell.h"
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoLiveCartPopViewDelegate <NSObject>

- (void)popView:(BogoLiveCartPopView *)popView didClickAddBtn:(UIButton *)sender;//点击添加
- (void)popView:(BogoLiveCartPopView *)popView didClickGood:(BogoCommodityDetailModel *)model;//点击商品
- (void)popView:(BogoLiveCartPopView *)popView didRemoveGood:(BogoCommodityDetailModel *)model;//移除商品

- (void)popView:(BogoLiveCartPopView *)popView didClickSayBtn:(BogoCommodityDetailModel *)model;//点击商品

@end

@interface BogoLiveCartPopView : FDPopView

@property(nonatomic, copy) NSString *lid;

@property(nonatomic, weak) id<BogoLiveCartPopViewDelegate>delegate;

@property(nonatomic, assign) BogoLiveStartGoodListCellType type;

@end

NS_ASSUME_NONNULL_END
