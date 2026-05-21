//
//  BogoOrderDetailViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoBaseViewController.h"
#import "BogoShopKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderDetailViewController : BogoBaseViewController

@property(nonatomic, assign) BogoOrderManageViewControllerType listType;

@property(nonatomic, copy) NSString *so_id;

@end

NS_ASSUME_NONNULL_END
