//
//  BogoShopDetailTopCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/7.
//

#import "BogoShopDetailTopCell.h"
#import "BogoShopDetailModel.h"
#import "UIImageView+WebCache.h"

@interface BogoShopDetailTopCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *idLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *locationLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *numberLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *firstImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *secondImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *thirdImageView;

@end

@implementation BogoShopDetailTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.shadowColor = [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0].CGColor;
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.shadowOpacity = 1;
    self.bgView.layer.shadowRadius = 6;
}

- (void)setModel:(BogoShopDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.shop_info.logo]];
    [self.titleLabel setText:model.shop_info.title];
    [self.idLabel setText:[NSString stringWithFormat:@"店铺ID:%@",model.shop_info.sid]];
    [self.locationLabel setText:model.shop_info.city];
}

@end
