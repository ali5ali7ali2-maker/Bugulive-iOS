//
//  BogoGoodDetailShopGoodCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/26.
//

#import "BogoGoodDetailShopGoodCell.h"
#import "UIImageView+WebCache.h"
#import "BogoCommodityDetailModel.h"

@interface BogoGoodDetailShopGoodCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoGoodDetailShopGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100]];
    [self.titleLabel setText:model.title];
}

@end
