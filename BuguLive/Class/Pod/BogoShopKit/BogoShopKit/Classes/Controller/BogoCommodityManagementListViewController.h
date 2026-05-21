//
//  BogoCommodityManagementListViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import <UIKit/UIKit.h>
#import "BogoShopKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoCommodityManagementListViewController : UITableViewController

@property(nonatomic, assign) BogoCommodityManagementViewControllerType type;

- (void)headerRefresh;


- (void)headerRefreshWithModelArr:(NSArray *)array;


@end

NS_ASSUME_NONNULL_END
