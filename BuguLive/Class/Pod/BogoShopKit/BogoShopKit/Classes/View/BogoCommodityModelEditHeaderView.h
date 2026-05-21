//
//  BogoCommodityModelEditHeaderView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/16.
//

#import <UIKit/UIKit.h>
@class BogoCommodityModelEditHeaderView;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCommodityModelEditHeaderViewDelegate <NSObject>

- (void)headerView:(BogoCommodityModelEditHeaderView *)headerView didClickDeleteBtn:(UIButton *)sender;

@end

@interface BogoCommodityModelEditHeaderView : UITableViewHeaderFooterView

@property(nonatomic, weak) id<BogoCommodityModelEditHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic, strong) NSIndexPath *indexPath;
@property(nonatomic, assign) BOOL isSee;

@end

NS_ASSUME_NONNULL_END
