//
//  BogoCategoryGoodCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/15.
//

#import "BogoCategoryGoodCell.h"
#import "UIImageView+WebCache.h"
#import <YYKit/YYKit.h>
#import "BogoCommodityDetailModel.h"

@interface BogoCategoryGoodCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *saleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoCategoryGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.buyBtn.layer.borderWidth = 1;
    self.buyBtn.layer.borderColor = [UIColor colorWithHexString:@"#F42416"].CGColor;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
//    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue/100]];
    NSString *price = [NSString stringWithFormat:@"￥%.2f",model.price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} range:NSMakeRange(0, @"￥".length)];
    [self.priceLabel setAttributedText:attr];
    
    if (model.sales) {
        [self.saleLabel setText:[NSString stringWithFormat:@"销量 %@",model.sales]];
    }else{
        [self.saleLabel setText:@"销量 0"];
    }
    [self.titleLabel setText:model.title];
    if ([model.title containsString:@"礼包"]) {
        self.buyBtn.hidden = YES;
    }
}

- (IBAction)buyBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodCell:didClickBuyBtn:)]) {
        [self.delegate goodCell:self didClickBuyBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
