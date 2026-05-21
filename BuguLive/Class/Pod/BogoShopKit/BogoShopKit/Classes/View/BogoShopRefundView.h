//
//  BogoShopRefundView.h
//  BogoShopKit
//
//  Created by 宋晨光 on 2021/9/1.
//

#import <UIKit/UIKit.h>
#import "FDUIKitObjC.h"

#import "BogoRefundReasonModel.h"
//#import <BogoShopKit/shop>
NS_ASSUME_NONNULL_BEGIN

@interface BogoShopRefundView : FDPopView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *listArr;

@property(nonatomic, strong) BogoRefundReasonModel *model;

@property(nonatomic, copy) void (^clickConfirmBlock)(BogoRefundReasonModel *model);

@end

NS_ASSUME_NONNULL_END
