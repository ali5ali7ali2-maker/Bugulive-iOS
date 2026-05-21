//
//  BogoCommodityManagementListCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/13.
//

#import "BogoCommodityManagementListCell.h"
#import <YYKit/YYKit.h>
#import "BogoCommodityManagementListModel.h"
#import "UIImageView+WebCache.h"

@interface BogoCommodityManagementListCell ()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countAllLabel;
@property (weak, nonatomic) IBOutlet UILabel *countMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@end

@implementation BogoCommodityManagementListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLabel.adjustsFontSizeToFitWidth = YES;
    self.backView.layer.borderWidth = 1;
    self.backView.layer.borderColor = [UIColor colorWithHexString:@"#E6E6E6"].CGColor;
    
    self.leftBtn.layer.borderColor = [UIColor colorWithHexString:@"#FC3205"].CGColor;
    self.leftBtn.layer.borderWidth = 1;
    self.middleBtn.layer.borderColor = [UIColor colorWithHexString:@"#FC3205"].CGColor;
    self.middleBtn.layer.borderWidth = 1;
    self.rightBtn.layer.borderColor = [UIColor colorWithHexString:@"#FC3205"].CGColor;
    self.rightBtn.layer.borderWidth = 1;
}

- (void)setModel:(BogoCommodityManagementListModel *)model{
    _model = model;
    self.leftBtn.hidden = YES;
    self.middleBtn.hidden = YES;
    self.rightBtn.hidden = YES;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];
    [self.countAllLabel setText:[NSString stringWithFormat:@"库存:%@",model.countall]];
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.price.floatValue/100]];
    [self.countMonthLabel setText:[NSString stringWithFormat:@"月售:%@",model.order_count]];
    [self.statusLabel setText:@""];
    switch (model.status.integerValue) {
        case BogoCommodityManagementViewControllerTypeOnSale:
            [self.statusLabel setText:@"售卖中"];
//            self.leftBtn.hidden = _model.is_platform.intValue;
//            self.middleBtn.hidden = NO;
            self.rightBtn.hidden = NO;
//            [self.leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"下架" forState:UIControlStateNormal];
//            [self.middleBtn setTitle:@"删除" forState:UIControlStateNormal];
            break;
        case BogoCommodityManagementViewControllerTypeOffSale:
            [self.statusLabel setText:@"已下架"];
            self.middleBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            [self.middleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"上架" forState:UIControlStateNormal];
//            self.leftBtn.hidden = _model.is_platform.intValue;
//            [self.leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
            break;
        case BogoCommodityManagementViewControllerTypeAll:
            [self.statusLabel setText:@"审核中"];
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"查看" forState:UIControlStateNormal];
            break;
        case BogoCommodityManagementViewControllerTypeEmpty:
            [self.statusLabel setText:@"已售空"];
            self.rightBtn.hidden = NO;
            self.middleBtn.hidden = YES;
            [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
            
            break;
        case BogoCommodityManagementViewControllerTypeAuthFailed:
            [self.statusLabel setText:@"审核未通过"];
            self.rightBtn.hidden = NO;
//            self.middleBtn.hidden = NO;
            [self.rightBtn setTitle:@"删除" forState:UIControlStateNormal];
//            [self.middleBtn setTitle:@"删除" forState:UIControlStateNormal];
            break;
        case BogoCommodityManagementViewControllerTypeAuthSuccess:
            [self.statusLabel setText:@"审核通过"];
            self.middleBtn.hidden = NO;
            self.rightBtn.hidden = NO;
            [self.middleBtn setTitle:@"删除" forState:UIControlStateNormal];
            [self.rightBtn setTitle:@"上架" forState:UIControlStateNormal];
//            self.leftBtn.hidden = YES;
//            [self.leftBtn setTitle:@"编辑" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)btnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickButton:)]) {
        [self.delegate listCell:self didClickButton:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
