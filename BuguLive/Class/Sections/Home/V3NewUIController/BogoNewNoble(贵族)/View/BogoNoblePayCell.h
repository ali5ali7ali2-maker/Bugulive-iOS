//
//  BogoNoblePayCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/24.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BogoNoblePayModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BogoNoblePayCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *bgButton;
@property (weak, nonatomic) IBOutlet QMUIButton *diamondBtn;

@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property(nonatomic, strong) BogoNoblePayListModel *model;

@end

NS_ASSUME_NONNULL_END
