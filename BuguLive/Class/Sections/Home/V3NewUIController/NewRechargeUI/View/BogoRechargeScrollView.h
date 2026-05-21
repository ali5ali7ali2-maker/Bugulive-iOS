//
//  BogoRechargeScrollView.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRechargeModel.h"
@class BogoRechargeScrollView;


@protocol BogoRechargeDelegate <NSObject>

- (void)alipay:(NSString *)payinfo;
- (void)getProductInfowithprotectId:(NSString *)proId;

-(void)checkProid:(NSString *)pro_id;

- (void)rechargeScrollView:(BogoRechargeScrollView *)rechargeScrollView didClickCloseBtn:(UIButton *)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BogoRechargeScrollView : UIScrollView

@property(nonatomic, strong) AccountRechargeModel *model;

@property(nonatomic, strong) id<BogoRechargeDelegate> reDelegate;

@property(nonatomic, strong) NSString *diamondStr;

@property(nonatomic, assign) BOOL isRecharge;

@end

NS_ASSUME_NONNULL_END
