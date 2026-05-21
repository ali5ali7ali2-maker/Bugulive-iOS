//
//  AccountItemCell.m
//  BuguLive
//
//  Created by 范东 on 2019/1/15.
//  Copyright © 2019 xfg. All rights reserved.
//

#import "AccountItemCell.h"

@interface AccountItemCell()

@property (weak, nonatomic) IBOutlet UIButton *diamondButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation AccountItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderColor = kAppGrayColor3.CGColor;
    self.layer.borderWidth = 1;
}

- (void)setModel:(PayMoneyModel *)model{
    [self.diamondButton setTitle:[NSString stringWithFormat:@"%ld",model.diamonds] forState:UIControlStateNormal];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%@",model.money_name]];
}

- (void)setSelected:(BOOL)selected{
    self.selectImageView.hidden = !selected;
    self.layer.borderColor = selected ? [UIColor colorWithHexString:@"#CC45FF"].CGColor : kAppGrayColor3.CGColor ;
}

@end
