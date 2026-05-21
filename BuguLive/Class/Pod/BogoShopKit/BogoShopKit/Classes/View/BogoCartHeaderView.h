//
//  BogoCartHeaderView.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import <UIKit/UIKit.h>
@class BogoCartHeaderView;
@class BogoCommodityDetailModel;
@class BogoCartModel;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, BogoCartHeaderViewType) {
    BogoCartHeaderViewTypeCart,
    BogoCartHeaderViewTypeOrderSubmit
};

@protocol BogoCartHeaderViewDelegate <NSObject>

-(void)headerView:(BogoCartHeaderView *)headerView didClickSelectBtn:(UIButton *)sender;

@end

@interface BogoCartHeaderView : UITableViewHeaderFooterView

@property(nonatomic, weak) id<BogoCartHeaderViewDelegate>delegate;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, strong) BogoCartModel *cartModel;

@property(nonatomic, assign) NSInteger section;

@property(nonatomic, assign) BogoCartHeaderViewType type;

@end

NS_ASSUME_NONNULL_END
