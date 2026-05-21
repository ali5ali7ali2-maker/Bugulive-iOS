//
//  BogoCartViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "BogoBaseViewController.h"
#import "BogoShopKit.h"

#define kBogoCartViewControllerStorageKey @"kBogoCartViewControllerStorageKey"

NS_ASSUME_NONNULL_BEGIN

@interface BogoCartViewController : BogoBaseViewController

@property(nonatomic, assign) BogoShopBuySource source;

@end

NS_ASSUME_NONNULL_END
