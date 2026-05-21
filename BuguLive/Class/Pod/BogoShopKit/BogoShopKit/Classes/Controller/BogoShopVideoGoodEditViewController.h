//
//  BogoShopVideoGoodEditViewController.h
//  BogoShopKit
//
//  Created by Mac on 2021/8/17.
//

#import "BogoShopKit.h"
@class BogoShopVideoGoodEditViewController;
@class BogoCommodityDetailModel;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoShopVideoGoodEditViewControllerDelegate <NSObject>

- (void)editVC:(BogoShopVideoGoodEditViewController *)editVC didFinishEdit:(NSString *)text;

@end

@interface BogoShopVideoGoodEditViewController : BogoBaseViewController

@property(nonatomic, weak) id<BogoShopVideoGoodEditViewControllerDelegate>delegate;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@end

NS_ASSUME_NONNULL_END
