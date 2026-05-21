//
//  BogoRechargeRecordListController.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BGBaseViewController.h"

typedef enum : NSUInteger {
    BOGO_RECORD_TYPE_RECHARGE,//充值明细
    BOGO_RECORD_TYPE_CONSUMPTION,//消费明细
} BOGO_RECORD_TYPE;

NS_ASSUME_NONNULL_BEGIN

@interface BogoRechargeRecordListController : BGBaseViewController

-(instancetype)initRecordTypeWith:(BOGO_RECORD_TYPE)type;
@property(nonatomic, assign) BOGO_RECORD_TYPE type;

@end

NS_ASSUME_NONNULL_END
