//
//  BogoSearchHistoryCell.h
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/6.
//  Copyright © 2021 xfg. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BogoSearchHistoryCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidthConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameL;

@property (weak, nonatomic) IBOutlet UILabel *idLabel;

@property(nonatomic, strong) LivingModel *model;

@end

NS_ASSUME_NONNULL_END
