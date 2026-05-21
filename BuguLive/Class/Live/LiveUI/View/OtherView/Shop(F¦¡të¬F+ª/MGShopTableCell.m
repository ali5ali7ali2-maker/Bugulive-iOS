//
//  MGShopTableCell.m
//  BuguLive
//
//  Created by 宋晨光 on 2020/7/17.
//  Copyright © 2020 xfg. All rights reserved.
//

#import "MGShopTableCell.h"

@implementation MGShopTableCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shopImgView.clipsToBounds = YES;
    self.shopImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.shopImgView.layer.cornerRadius = 4;
    self.shopImgView.layer.masksToBounds = YES;
    
    self.shopBtn.layer.cornerRadius = 30 / 2;
    self.shopBtn.layer.masksToBounds = YES;
    self.shopBtn.layer.borderColor = [UIColor colorWithHexString:@"AF1328"].CGColor;
    self.shopBtn.layer.borderWidth = 0.5f;
    
}

- (void)resetViewWithModel:(MGShopListModel *)model{
    _model = model;
    [self.shopImgView sd_setImageWithURL:[NSURL URLWithString:model.shop_logo]];
    self.shopNameL.text = model.shop_name;
    self.shopNumL.text = model.shop_price;
}

- (IBAction)clickShopBtn:(UIButton *)sender {
    
    if (![_model.shop_url containsString:@"http"]) {
        [BGHUDHelper alert:ASLocalizedString(@"URL不合法")];
        return;
    }
       
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_model.shop_url]];
}

@end
