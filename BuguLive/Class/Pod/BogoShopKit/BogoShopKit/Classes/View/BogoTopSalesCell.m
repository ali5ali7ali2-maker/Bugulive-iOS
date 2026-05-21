//
//  BogoTopSalesCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoTopSalesCell.h"
#import "BogoTitleGradientLayerView.h"
#import "BogoShopKit.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface BogoTopSalesCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property(nonatomic, strong) BogoTitleGradientLayerView *layerView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation BogoTopSalesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    if (model.is_platform.integerValue) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"  %@",model.title]];
//        NSAttributedString *spaceAttr = [[NSAttributedString alloc]initWithString:@" "];
//        [attr insertAttributedString:spaceAttr atIndex:0];
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        self.layerView.nameLabel.text = @"自营";
        UIImage *image = [self.layerView convertViewToImage];
        attachment.image = image;
        attachment.bounds = CGRectMake(0, -5, image.size.width, image.size.height);
        NSAttributedString *imageAttr = [NSAttributedString attributedStringWithAttachment:attachment];
        [attr insertAttributedString:imageAttr atIndex:0];
        self.nameLabel.attributedText = attr;
    }else{
        self.nameLabel.text = model.title;
    }
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",model.price.doubleValue/100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:priceStr];
    [attr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, @"￥".length)];
    self.priceLabel.attributedText = attr;
    self.saleLabel.text = [NSString stringWithFormat:@"销量：%@",model.sales];
}

- (BogoTitleGradientLayerView *)layerView{
    if (!_layerView) {
        _layerView = [kShopKitBundle loadNibNamed:NSStringFromClass([BogoTitleGradientLayerView class]) owner:nil options:nil].lastObject;
    }
    return _layerView;
}

@end
