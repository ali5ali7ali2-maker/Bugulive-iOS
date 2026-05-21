//
//  BogoOrderDetailCommodityCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoOrderDetailCommodityCell.h"
#import "BogoOrderManageListModel.h"
#import "UIImageView+WebCache.h"
#import <YYKit/YYKit.h>

@interface BogoOrderDetailCommodityCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *attrLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundTypePriceLabel;

@end

@implementation BogoOrderDetailCommodityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoOrderManageListModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_icon]];
    [self.titleLabel setText:model.goods_title];
    [self.attrLabel setText:[NSString stringWithFormat:@"规格：%@",model.attr_name]];
    [self.countLabel setText:[NSString stringWithFormat:@"x%@",model.number]];
    NSString *priceStr = [NSString stringWithFormat:@"实付￥%.2f",model.money.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, @"实付".length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(@"实付".length, @"￥".length)];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightMedium] range:NSMakeRange(@"实付￥".length, priceStr.length - @"实付￥".length )];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"777777"] range:NSMakeRange(0, @"实付".length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(@"实付".length, @"￥".length)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"333333"] range:NSMakeRange(@"实付￥".length, priceStr.length - @"实付￥".length )];
    [self.priceLabel setAttributedText:attr];
    [self.refundTypePriceLabel setAttributedText:attr];
    
    if (self.type == BogoOrderDetailCellTypeApplyRefund) {
        self.priceLabel.hidden = YES;
        self.refundTypePriceLabel.hidden = NO;
    }else{
        self.priceLabel.hidden = NO;
        self.refundTypePriceLabel.hidden = YES;
    }
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
