//
//  BogoClassicsListCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/25.
//

#import "BogoClassicsListCell.h"
#import "BogoCommodityDetailModel.h"
#import "UIImageView+WebCache.h"
#import <YYKit/YYKit.h>

@interface BogoClassicsListCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyedLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeLabel;
@property (weak, nonatomic) IBOutlet UIButton *onlineBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation BogoClassicsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.onlineBtn.layer.borderColor = [UIColor colorWithHexString:@"#E6361C"].CGColor;
    self.onlineBtn.layer.borderWidth = 1;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];
    [self.buyedLabel setText:[NSString stringWithFormat:@"   %ld人已买    ",model.count]];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue/100]];
    [self.incomeLabel setText:[NSString stringWithFormat:@"/赚￥%.2f",model.price.floatValue * model.commission.floatValue/10000]];
    if (_marketing_type.integerValue > 1) {
        self.incomeLabel.hidden = model.is_platform.integerValue != 1;
        self.onlineBtn.hidden = model.is_platform.integerValue != 1;
        [self.shareBtn setTitle:model.is_platform.integerValue == 1 ? @"分享购买" : @"立即购买" forState:UIControlStateNormal];
    }else{
        self.onlineBtn.hidden = YES;
        self.incomeLabel.hidden = YES;
        [self.shareBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    }
}

- (IBAction)onlineBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickOnlineBtn:)]) {
        [self.delegate listCell:self didClickOnlineBtn:sender];
    }
}

- (IBAction)shareBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickShareBtn:)]) {
        [self.delegate listCell:self didClickShareBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
