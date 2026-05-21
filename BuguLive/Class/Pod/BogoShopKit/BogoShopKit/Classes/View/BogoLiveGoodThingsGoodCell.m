//
//  BogoLiveGoodThingsGoodCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoLiveGoodThingsGoodCell.h"
#import "BogoLiveGoodThingItemModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BogoLiveGoodThingsGoodCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *originPriceLabel;

@end

@implementation BogoLiveGoodThingsGoodCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoLiveGoodThingItemModelGoods *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",(double)model.price / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
    self.priceLabel.attributedText = attr;
    
    if (model.original_price > 0) {
        NSString *originalPriceStr = [NSString stringWithFormat:@"￥%.2f",(double)model.original_price / 100];
        NSMutableAttributedString *nAttr = [[NSMutableAttributedString alloc]initWithString:originalPriceStr];
        [nAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
        [nAttr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, nAttr.length)];
        self.originPriceLabel.attributedText = nAttr;
    }
}

@end
