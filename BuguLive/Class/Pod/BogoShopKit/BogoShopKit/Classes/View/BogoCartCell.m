//
//  BogoCartCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "BogoCartCell.h"
#import "UIImageView+WebCache.h"
#import "BogoCartModel.h"
#import "BogoCommodityDetailModel.h"
#import "BogoShopKit.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>

@interface BogoCartCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *selectBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *iconImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *attrLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *minusBtn;
@property (weak, nonatomic) IBOutlet UIButton *plusBtn;
@property (weak, nonatomic) IBOutlet UIImageView *numberImageView;

@property (weak, nonatomic) IBOutlet UILabel *submitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *submitNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitNumBottomConstraint;

@end

@implementation BogoCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setType:(BogoCartCellType)type{
    _type = type;
    if (type == BogoCartCellTypeOrderSubmit) {
        self.submitPriceLabel.hidden = YES;
        self.submitNumberLabel.hidden = NO;
        self.submitNumberLabel.font = [UIFont systemFontOfSize:12];
        self.numberLabel.hidden = YES;
        self.minusBtn.hidden = YES;
        self.plusBtn.hidden = YES;
        self.numberImageView.hidden = YES;
        self.priceLabel.hidden = NO;
        self.selectBtn.hidden = YES;
        self.iconLeading.constant = 10;
        self.attrLabel.backgroundColor = [UIColor clearColor];
    }else if(type == BogoCartCellTypeConfirmOrder){
        self.submitPriceLabel.hidden = YES;
        self.submitNumberLabel.hidden = NO;
        self.submitNumberLabel.font = [UIFont systemFontOfSize:12];
        self.submitNumBottomConstraint.constant = 3;
        self.numberLabel.hidden = YES;
        self.minusBtn.hidden = YES;
        self.plusBtn.hidden = YES;
        self.numberImageView.hidden = YES;
        self.priceLabel.hidden = NO;
        self.selectBtn.hidden = YES;
        self.iconLeading.constant = 10;
        
        self.attrLabel.backgroundColor = [UIColor clearColor];
        self.priceLabel.textColor = [UIColor colorWithHexString:@"#333333"];
    }else{
        self.submitPriceLabel.hidden = YES;
        self.submitNumberLabel.hidden = YES;
        self.numberLabel.hidden = NO;
        self.minusBtn.hidden = NO;
        self.plusBtn.hidden = NO;
        self.numberImageView.hidden = NO;
        self.priceLabel.hidden = NO;
        self.selectBtn.hidden = NO;
        self.iconLeading.constant = 40;
    }
}

- (void)setListModel:(BogoCartListModel *)listModel{
    _listModel = listModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:listModel.goods_icon]];
    [self.titleLabel setText:listModel.title];

    [self.attrLabel setText:[NSString stringWithFormat:@"  规格：%@  ",listModel.name]];
    
    if(_type == BogoCartCellTypeConfirmOrder){
        [self.attrLabel setText:[NSString stringWithFormat:@"规格：%@",listModel.name]];
    }
    
    NSString *price = [NSString stringWithFormat:@"￥%.2f",listModel.price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, @"￥".length)];
    [self.priceLabel setAttributedText:attr];
//    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",listModel.price.floatValue / 100]];

    [self.numberLabel setText:[NSString stringWithFormat:@"%ld",listModel.num]];
    [self.submitPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",listModel.price.floatValue / 100]];
    [self.submitNumberLabel setText:[NSString stringWithFormat:@"x%ld",listModel.num]];
    self.selectBtn.selected = listModel.selected;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    [self.titleLabel setText:model.title];

    
    NSString *price = [NSString stringWithFormat:@"￥%.2f",model.attr[model.selectAttrIndex].price.floatValue / 100];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:price];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:11]} range:NSMakeRange(0, @"￥".length)];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"333333"]} range:NSMakeRange(0, attr.length)];
    [self.priceLabel setAttributedText:attr];
//    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.attr[model.selectAttrIndex].price.floatValue / 100]];
    
    
    
    [self.attrLabel setText:[NSString stringWithFormat:@"规格：%@  ",model.attr[model.selectAttrIndex].name]];
    
    if (self.type == BogoCartCellTypeConfirmOrder) {
        [self.attrLabel setText:[NSString stringWithFormat:@"  规格：%@  ",model.attr[model.selectAttrIndex].name]];
    }
    
    
    [self.submitPriceLabel setText:[NSString stringWithFormat:@"￥%.2f",model.attr[model.selectAttrIndex].price.floatValue / 100]];
    [self.submitNumberLabel setText:[NSString stringWithFormat:@"x%ld",model.count]];
    [self.numberLabel setText:[NSString stringWithFormat:@"%ld",model.count]];
    self.numberLabel.textColor = [UIColor colorWithHexString:@"777777"];
    self.numberLabel.font = [UIFont systemFontOfSize:12];
    self.selectBtn.selected = model.selected;
}

- (IBAction)minusBtnAction:(UIButton *)sender {
    NSInteger value = self.numberLabel.text.integerValue - 1;
    if (value == 0) {
        return;
    }
    if (_listModel) {
        //    http://xx.com/api/shopuser/numCart
        [[BogoNetwork shareInstance] POST:@"api/numCartUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"num":@(value),@"id":_listModel.id} success:^(BogoNetworkResponseModel * _Nonnull result) {
            self->_listModel.num = value;
            [self.numberLabel setText:[NSString stringWithFormat:@"%ld",value]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didInputValue:)]) {
                [self.delegate cartCell:self didInputValue:value];
            }
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:[UIApplication sharedApplication].keyWindow];
        }];
    }else{
        [self.numberLabel setText:[NSString stringWithFormat:@"%ld",value]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didInputValue:)]) {
            [self.delegate cartCell:self didInputValue:value];
        }
    }

    
}

- (IBAction)plusBtnAction:(UIButton *)sender {
    NSInteger value = self.numberLabel.text.integerValue + 1;

    if (self.model) {
        if (value > self.model.attr[self.model.selectAttrIndex].stock.integerValue) {

            return;
        }
    }
    
    if (value > 100) {
        return;
    }
    if (_listModel) {
        //    http://xx.com/api/shopuser/numCart
        [[BogoNetwork shareInstance] POST:@"api/numCartUrl" param:@{@"token":[BogoNetwork shareInstance].token,@"num":@(value),@"id":_listModel.id} success:^(BogoNetworkResponseModel * _Nonnull result) {
            self->_listModel.num = value;
            [self.numberLabel setText:[NSString stringWithFormat:@"%ld",value]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didInputValue:)]) {
                [self.delegate cartCell:self didInputValue:value];
            }
        } failure:^(NSString * _Nonnull error) {
            [[FDHUDManager defaultManager] show:error ToView:[UIApplication sharedApplication].keyWindow];
        }];
    }else{
        [self.numberLabel setText:[NSString stringWithFormat:@"%ld",value]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didInputValue:)]) {
            [self.delegate cartCell:self didInputValue:value];
        }
    }
}

- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(cartCell:didClickSelectBtn:)]) {
        [self.delegate cartCell:self didClickSelectBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    UIEdgeInsets insets = {0, 10, 0, 5};
    [self.attrLabel drawTextInRect:UIEdgeInsetsInsetRect(self.titleLabel.frame, insets)];
//    [self.attrLabel drawTextInRect:UIEdgeInsetsInsetRect(self.titleLabel.frame, 0, 10, 0, 10)];
}

@end
