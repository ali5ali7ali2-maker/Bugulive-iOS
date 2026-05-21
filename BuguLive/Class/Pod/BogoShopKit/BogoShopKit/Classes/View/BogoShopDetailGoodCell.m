//
//  BogoShopDetailGoodCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/7.
//

#import "BogoShopDetailGoodCell.h"
#import "BogoCommodityDetailModel.h"
#import "UIImageView+WebCache.h"

@interface BogoShopDetailGoodCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *saleLabel;

@end

@implementation BogoShopDetailGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];
//    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100]];
    
    
    NSString *price = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} range:NSMakeRange(0, @"￥".length)];
    [self.priceLabel setAttributedText:attr];
    
    [self.saleLabel setText:[NSString stringWithFormat:@"已售:%@",model.total_sales]];
}

@end
