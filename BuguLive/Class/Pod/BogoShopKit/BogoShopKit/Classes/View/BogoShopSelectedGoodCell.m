//
//  BogoShopSelectedGoodCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoShopSelectedGoodCell.h"
#import <YYKit/YYKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "BogoCommodityDetailModel.h"

@interface BogoShopSelectedGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@end

@implementation BogoShopSelectedGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithHexString:@"e6e6e6"].CGColor;
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.titleLabel.text = model.title;
//    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",model.price.doubleValue/100];
    
    NSString *price = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, @"￥".length)];
    [self.priceLabel setAttributedText:attr];
    
    self.saleLabel.text = [NSString stringWithFormat:@"已售%@件",model.sales];
}

@end
