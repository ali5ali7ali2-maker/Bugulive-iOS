//
//  BogoCommodityAddCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/15.
//

#import "BogoCommodityAddCell.h"
#import "BogoCommodityDetailModel.h"
#import <YYKit/YYKit.h>
#import "UIImageView+WebCache.h"
#import <QMUIKit/QMUIKit.h>

@interface BogoCommodityAddCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *countLabel;
@property (unsafe_unretained, nonatomic) IBOutlet QMUIButton *operateBtn;


@end

@implementation BogoCommodityAddCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.operateBtn setTitle:@"添加" forState:UIControlStateNormal];
    [self.operateBtn setTitle:@"已添加" forState:UIControlStateSelected];
    [self.operateBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#EFEFEF"]] forState:UIControlStateNormal];
    
    [self.operateBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#F46628"]] forState:UIControlStateSelected];
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue/100]];
    [self.countLabel setText:[NSString stringWithFormat:@"库存 %@",model.stock_total]];
    self.operateBtn.selected = model.is_distribution.integerValue == 1;
}

- (IBAction)operateBtnAction:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(addCell:didClickOperateBtn:)]){
        [self.delegate addCell:self didClickOperateBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
