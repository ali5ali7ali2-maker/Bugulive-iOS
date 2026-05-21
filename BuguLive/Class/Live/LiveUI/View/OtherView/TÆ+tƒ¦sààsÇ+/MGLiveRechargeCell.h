//
//  MGLiveRechargeCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2020/8/5.
//  Copyright © 2020 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountRechargeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MGLiveRechargeCell : UICollectionViewCell

@property(nonatomic, strong) PayMoneyModel *model;

@property(nonatomic, strong) UIControl *control;
@property(nonatomic, strong) UILabel *titleL;
@property(nonatomic, strong) UILabel *subTitleL;

-(void)resetViewWithModel:(PayMoneyModel *)model;

@end

NS_ASSUME_NONNULL_END
