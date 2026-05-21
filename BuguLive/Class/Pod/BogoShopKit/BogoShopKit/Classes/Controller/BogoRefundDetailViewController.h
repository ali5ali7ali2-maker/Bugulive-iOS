//
//  BogoRefundDetailViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoBaseViewController.h"
#import "BogoShopKit.h"
@class BogoOrderManageListModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoRefundDetailViewController : BogoBaseViewController

@property(nonatomic, copy) NSString *so_id;

@property(nonatomic, assign) BogoOrderManageViewControllerType listType;
@property(nonatomic, strong) BogoOrderManageListModel *orderModel;

@end

NS_ASSUME_NONNULL_END
