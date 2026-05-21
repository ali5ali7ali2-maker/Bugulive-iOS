//
//  BogoRechageListCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/5/21.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BogoRechargeRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoRechageListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rechargeTitleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *coinL;

@property(nonatomic, strong) BogoRechargeRecordModel *model;

@end

NS_ASSUME_NONNULL_END
