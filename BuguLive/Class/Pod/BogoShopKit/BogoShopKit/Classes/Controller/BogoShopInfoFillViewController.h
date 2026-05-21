//
//  BogoShopInfoFillViewController.h
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoBaseViewController.h"
@class BogoShopInfoModel;

NS_ASSUME_NONNULL_BEGIN

@interface BogoShopInfoFillViewController : BogoBaseViewController

@property(nonatomic, assign) NSInteger status;//状态 0申请中，1成功，2失败,

@property(nonatomic, strong) BogoShopInfoModel *model;

@end

NS_ASSUME_NONNULL_END
