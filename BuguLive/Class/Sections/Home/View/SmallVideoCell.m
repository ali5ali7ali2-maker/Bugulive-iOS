//
//  SmallVideoCell.m
//  BuguLive
//
//  Created by 丁凯 on 2017/8/17.
//  Copyright © 2017年 xfg. All rights reserved.

#import "SmallVideoCell.h"
#import "SmallVideoListModel.h"

@implementation SmallVideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.smallImgView.layer.cornerRadius  = 25*kScaleWidth/2;
    self.bottomView.layer.cornerRadius    = self.bottomView.height/2;
    self.smallImgView.layer.masksToBounds = YES;
    self.bottomView.layer.masksToBounds   = YES;
    self.bottomView.backgroundColor       = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    self.bigImgView.layer.cornerRadius = 5;
    self.bigImgView.layer.masksToBounds = YES;
    
    self.isCheckView.layer.cornerRadius = 5;
    self.isCheckView.layer.masksToBounds = YES;
    
    self.smallImgView.hidden = YES;
    self.isCheckView.hidden = YES;
    
    self.watchNum.imagePosition = QMUIButtonImagePositionLeft;
    self.watchNum.spacingBetweenImageAndTitle = 2;
    
    self.headImg.layer.cornerRadius = 22 / 2;
    self.headImg.layer.masksToBounds = YES;
//    self.nickNameBtn.imagePosition = QMUIButtonImagePositionLeft;
//    self.nickNameBtn.spacingBetweenImageAndTitle = 2;
}

- (void)creatCellWithModel:(SmallVideoListModel *)model andRow:(int)row
{
    if (![BGUtils isBlankString:model.is_audit]) {
        self.isCheckView.hidden = [model.is_audit isEqualToString:@"1"];
    }
    [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:model.photo_image] placeholderImage:kDefaultPreloadImgSquare];
    [self.smallImgView sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:kDefaultPreloadHeadImg];
    
    
    
    
    self.nameLabel.text = model.nick_name;
//    model.nick_name;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.video_count];
    [attr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11.0]} range:NSMakeRange(0, model.video_count.length)];
    CGFloat width =[model.video_count sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]}].width;
    self.bottomViewConstraintW.constant = width + 38;
    self.numLbale.attributedText = attr;
    
//    [self.nickNameBtn setTitle:model.nick_name forState:UIControlStateNormal];
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.head_image] placeholderImage:nil];
    
    
//    WeakSelf
//    [self.nickNameBtn sd_setImageWithURL:[NSURL URLWithString:model.head_image] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
////        CGSize size = image.size;
////        self.widthConstraint.constant = size.width / 3;
////        self.heightConstraint.constant = size.height / 3;
//        image = [weakSelf scaleImage:image scaleToSize:CGSizeMake(kRealValue(22), kRealValue(22))];
//        [weakSelf.nickNameBtn setImage:image forState:UIControlStateNormal];
//    }];
    
    self.titleL.text = model.content;
    [self.watchNum setTitle:model.video_count forState:UIControlStateNormal];
    
}


- (UIImage*)scaleImage:(UIImage *)image scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
