//
//  BogoShopSelectedTopCell.h
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class BogoShopBannerModel;
@class BogoShopSelectedTopCell;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoShopSelectedTopCellDelegate <NSObject>

- (void)topCell:(BogoShopSelectedTopCell *)topCell didClickBannerIndex:(NSInteger)index;

@end

@interface BogoShopSelectedTopCell : UICollectionViewCell

@property(nonatomic, strong) NSArray <BogoShopBannerModel *>*dataArray;

@property(nonatomic, weak) id<BogoShopSelectedTopCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
