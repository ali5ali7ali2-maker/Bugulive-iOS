//
//  BogoRechargeRecordModel.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoRechargeRecordModel : NSObject

@property(nonatomic, strong) NSString *ticket;
@property(nonatomic, strong) NSString *diamonds;
@property(nonatomic, strong) NSString *create_time;
@property(nonatomic, strong) NSString *is_success;
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *is_success_status;

@property(nonatomic, strong) NSString *money;

@property(nonatomic, assign) BOOL isRecharge;//YES充值明细，NO消费明细

@end

NS_ASSUME_NONNULL_END
