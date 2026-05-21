//
//  BogoAddressAddViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoBaseViewController.h"
@class BogoAddressListModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoAddressAddViewController : BogoBaseViewController

@property(nonatomic, strong) BogoAddressListModel *model;

@property(nonatomic, assign) NSInteger isEdit;

@end

NS_ASSUME_NONNULL_END
