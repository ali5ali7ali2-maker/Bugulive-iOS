//
//  BogoLiveGoodThingsCell.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import <UIKit/UIKit.h>
@class BogoLiveGoodThingItemModel;
@class BogoLiveGoodThingItemModelGoods;
@class BogoLiveGoodThingsCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoLiveGoodThingsCellDelegate <NSObject>

- (void)goodThingsCell:(BogoLiveGoodThingsCell *)goodThingsCell didClickGood:(BogoLiveGoodThingItemModelGoods *)good;
- (void)goodThingsCell:(BogoLiveGoodThingsCell *)goodThingsCell didClickUser:(NSString *)uid;

@end

@interface BogoLiveGoodThingsCell : UICollectionViewCell

@property(nonatomic, strong) BogoLiveGoodThingItemModel *model;

@property(nonatomic, weak) id<BogoLiveGoodThingsCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
