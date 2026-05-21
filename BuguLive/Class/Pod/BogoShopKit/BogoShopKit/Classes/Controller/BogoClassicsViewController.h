//
//  BogoClassicsViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/25.
//

#import "FDUIKitObjC.h"
@class BogoClassicsViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoClassicsViewControllerDelegate <NSObject>

- (void)classicsVC:(BogoClassicsViewController *)classicsVC didClickMessageBtn:(UIButton *)sender;
- (void)classicsVC:(BogoClassicsViewController *)classicsVC didNeedLogin:(UIButton *)sender;

@end

@interface BogoClassicsViewController : FDViewController

@property(nonatomic, weak) id<BogoClassicsViewControllerDelegate>delegate;

@property(nonatomic, copy) NSString *marketing_type;

@end

NS_ASSUME_NONNULL_END
