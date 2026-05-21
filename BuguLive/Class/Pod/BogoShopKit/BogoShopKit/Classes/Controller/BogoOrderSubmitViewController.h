//
//  BogoOrderSubmitViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoBaseViewController.h"
@class BogoCommodityDetailModel;
#import "BogoShopKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoOrderSubmitViewController : BogoBaseViewController

//通过别人分享出来的链接进入需要传uid
@property(nonatomic, copy) NSString *uid;

//分销商品，需要传入分销id
@property(nonatomic, copy) NSString *distribution_id;

@property(nonatomic, strong) BogoCommodityDetailModel *model;

@property(nonatomic, strong) NSArray *cartDataArray;

@property(nonatomic, assign) BogoShopBuySource source;

@end

NS_ASSUME_NONNULL_END
