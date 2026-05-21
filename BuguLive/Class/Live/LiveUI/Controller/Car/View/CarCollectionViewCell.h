//
//  CarCollectionViewCell.h
//  FanweApp
//
//  Created by 志刚杨 on 2017/12/14.
//  Copyright © 2017年 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarItem.h"
@interface CarCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) CarItemModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *carpic;
@property (weak, nonatomic) IBOutlet UILabel *carname;
@property (weak, nonatomic) IBOutlet UILabel *carcoin;
@property (weak, nonatomic) IBOutlet UILabel *exp;



@end
