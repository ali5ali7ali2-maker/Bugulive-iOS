//
//  BogoRechargePayTypeCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountRechargeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BogoRechargePayMoneyCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (weak, nonatomic) IBOutlet QMUIButton *diamondBtn;

@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property(nonatomic, strong) PayMoneyModel *model;

@end

NS_ASSUME_NONNULL_END
