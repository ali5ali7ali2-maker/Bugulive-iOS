//
//  BogoCommodityManagementSearchBar.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import <UIKit/UIKit.h>

#import <QMUIKit/QMUIKit.h>
@class BogoCommodityManagementSearchBar;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoCommodityManagementSearchBarDelegate <NSObject>

- (void)searchBar:(BogoCommodityManagementSearchBar *)searchBar didClickSearchBtn:(UIButton *)sender;

@end

@interface BogoCommodityManagementSearchBar : UIView

@property (weak, nonatomic) IBOutlet QMUITextField *textField;

@property(nonatomic, weak) id<BogoCommodityManagementSearchBarDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
