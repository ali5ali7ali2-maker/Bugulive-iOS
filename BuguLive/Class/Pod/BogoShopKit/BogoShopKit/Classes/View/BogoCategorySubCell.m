//
//  BogoCategoryCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/14.
//

#import "BogoCategorySubCell.h"
#import "BogoCategoryModel.h"
#import "UIImageView+WebCache.h"

@interface BogoCategorySubCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoCategorySubCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCategoryModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"DefaultImg"]];
    [self.titleLabel setText:model.title];
}

@end
