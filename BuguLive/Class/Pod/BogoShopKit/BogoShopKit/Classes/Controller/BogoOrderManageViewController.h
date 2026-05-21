//
//  BogoOrderManageViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import <UIKit/UIKit.h>
#import "BogoShopKit.h"
#import "BogoBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderManageViewController : BogoBaseViewController

@property(nonatomic, assign) BogoOrderManageViewControllerType listType;
@property(nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
