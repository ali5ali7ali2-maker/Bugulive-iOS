//
//  BogoCommodityTransferViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoCommodityTransferViewController : BogoBaseViewController

@property(nonatomic, copy) NSString *so_id;


@property(nonatomic, copy) void (^clickTransferBlock)(BOOL isSuccess);

@end

NS_ASSUME_NONNULL_END
