//
//  BogoRechargePayTypeCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2021/4/8.
//  Copyright © 2021 xfg. All rights reserved.
//

#import "BogoRechargePayTypeCell.h"

@implementation BogoRechargePayTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.payTypeBtn.userInteractionEnabled = NO;
    self.selectBtn.userInteractionEnabled = NO;
    self.payTypeBtn.spacingBetweenImageAndTitle = 5;
}

- (void)setModel:(PayTypeModel *)model{
    
    [self.payLabel setText:model.name];
    
    WeakSelf
    [self.payImageView sd_setImageWithURL:[NSURL URLWithString:model.logo]];
//    [self.payTypeBtn sd_setImageWithURL:[NSURL URLWithString:model.logo] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
////        image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(22), kRealValue(22))];
//        [weakSelf.payTypeBtn setImage:image forState:UIControlStateNormal];
//        weakSelf.payTypeBtn.imageView.size = CGSizeMake(30, 30);
//    }];
    
    if (model.isSelect) {
        [self.selectBtn setImage:[UIImage imageNamed:@"bogo_recharge_selectType"] forState:UIControlStateNormal];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"bogo_recharge_normalType"] forState:UIControlStateNormal];
    }
}

- (UIImage*)scaleImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


@end
