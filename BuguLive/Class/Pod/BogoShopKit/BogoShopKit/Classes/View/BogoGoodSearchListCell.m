//
//  BogoGoodSearchListCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/12.
//

#import "BogoGoodSearchListCell.h"
#import "BogoCommodityDetailModel.h"
#import "UIImageView+WebCache.h"

@interface BogoGoodSearchListCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation BogoGoodSearchListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100]];
}

@end
