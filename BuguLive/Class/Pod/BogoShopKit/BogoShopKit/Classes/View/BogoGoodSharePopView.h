//
//  BogoGoodSharePopView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/29.
//

#import "FDUIKitObjC.h"
@class BogoGoodSharePopView;
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoGoodSharePopViewType) {
    BogoGoodSharePopViewTypeNormal,
    BogoGoodSharePopViewTypeMarketing
};

@protocol BogoGoodSharePopViewDelegate <NSObject>

- (void)popView:(BogoGoodSharePopView *)popView didClickBtn:(UIButton *)sender;

@end

@interface BogoGoodSharePopView : FDPopView

@property(nonatomic, assign) BogoGoodSharePopViewType type;

@property(nonatomic, strong) BogoCommodityDetailModel *detailModel;

@property(nonatomic, copy) NSString *distribution_id;

@property(nonatomic, weak) id<BogoGoodSharePopViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
