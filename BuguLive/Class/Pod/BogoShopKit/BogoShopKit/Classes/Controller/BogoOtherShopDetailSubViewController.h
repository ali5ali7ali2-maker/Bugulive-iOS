//
//  BogoOtherShopDetailSubViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/8/29.
//

#import "FDViewController.h"
@class BogoOtherShopDetailSubViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol BogoOtherShopDetailSubViewControllerDelegate <NSObject>

- (void)shopDetailVC:(BogoOtherShopDetailSubViewController *)shopDetailVC didHeaderRefresh:(NSDictionary *)param;
- (void)shopDetailVC:(BogoOtherShopDetailSubViewController *)shopDetailVC didFooterRefresh:(NSDictionary *)param;

@end

@interface BogoOtherShopDetailSubViewController : FDViewController

@property(nonatomic, weak) id<BogoOtherShopDetailSubViewControllerDelegate>delegate;

@property(nonatomic, assign) NSInteger type;

@property(nonatomic, copy) NSString *user_id;

@property(nonatomic, strong) NSMutableArray *dataArray;

- (void)headerRefresh;

- (void)reloadData:(NSArray *)dataArray;

@end

NS_ASSUME_NONNULL_END
