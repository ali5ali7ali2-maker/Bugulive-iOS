//
//  BogoAddressListViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "FDUIKitObjC.h"
@class BogoAddressListModel;

NS_ASSUME_NONNULL_BEGIN

typedef void(^didSelectCallBack)(BogoAddressListModel *model);

@interface BogoAddressListViewController : FDTableViewController

@property(nonatomic, strong) BogoAddressListModel *model;

- (void)setDidSelectCallBack:(didSelectCallBack)didSelectCallBack;

@end

NS_ASSUME_NONNULL_END
