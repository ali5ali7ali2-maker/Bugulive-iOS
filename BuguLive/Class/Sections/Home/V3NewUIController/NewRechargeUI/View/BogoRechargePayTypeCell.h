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

@interface BogoRechargePayTypeCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet QMUIButton *payTypeBtn;
@property (weak, nonatomic) IBOutlet UIImageView *payImageView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property(nonatomic, strong) PayTypeModel *model;

@end

NS_ASSUME_NONNULL_END
