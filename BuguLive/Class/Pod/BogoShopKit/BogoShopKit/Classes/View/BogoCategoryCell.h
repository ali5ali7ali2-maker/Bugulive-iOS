//
//  BogoCategoryCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/4/15.
//

#import "FDTableViewCell.h"
@class BogoCategoryModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoCategoryCell : FDTableViewCell

@property(nonatomic, strong) BogoCategoryModel *model;

@end

NS_ASSUME_NONNULL_END
