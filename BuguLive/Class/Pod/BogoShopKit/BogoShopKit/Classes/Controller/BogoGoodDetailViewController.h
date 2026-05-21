//
//  BogoGoodDetailViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoBaseViewController.h"
#import "BogoShopKit.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoGoodDetailViewController : BogoBaseViewController

@property(nonatomic, copy) NSString *gid;

//如果通过他人分享来进入，需要传
@property(nonatomic, copy) NSString *uid;

//分销商品，需要传入分销id
@property(nonatomic, copy) NSString *distribution_id;

@property(nonatomic, assign) BogoShopBuySource source;

@end

NS_ASSUME_NONNULL_END
