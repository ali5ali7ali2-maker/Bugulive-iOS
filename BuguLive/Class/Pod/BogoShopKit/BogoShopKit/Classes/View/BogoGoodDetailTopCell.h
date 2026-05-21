//
//  BogoGoodDetailTopCell.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "FDTableViewCell.h"
@class BogoCommodityDetailModel;
@class BogoGoodDetailTopCell;
@class SDCycleScrollView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoGoodDetailTopCellDelegate <NSObject>

-(void)topCell:(BogoGoodDetailTopCell *)topCell didClickImage:(NSString *)imageUrl;

@end

@interface BogoGoodDetailTopCell : FDTableViewCell

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property (unsafe_unretained, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;

+ (CGFloat)cellHeightWithModel:(BogoCommodityDetailModel *)model;

@property(nonatomic, weak) id<BogoGoodDetailTopCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
