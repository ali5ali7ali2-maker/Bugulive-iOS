//
//  BogoCartNoDataView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "FDView.h"
@class BogoCartNoDataView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCartNoDataViewDelegate <NSObject>

- (void)noDataView:(BogoCartNoDataView *)noDataView didClickGoBtnAction:(UIButton *)sender;

@end

@interface BogoCartNoDataView : FDView

@property(nonatomic, weak) id<BogoCartNoDataViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
