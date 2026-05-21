//
//  BogoOrderManageListViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import <UIKit/UIKit.h>
#import "BogoShopKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderManageListViewController : UITableViewController

@property(nonatomic, assign) BogoOrderManageListViewControllerType type;

@property(nonatomic, assign) BogoOrderManageViewControllerType listType;

@end

NS_ASSUME_NONNULL_END
