//
//  BogoCartHeaderView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "BogoCartHeaderView.h"
#import "BogoCommodityDetailModel.h"
#import "BogoShopKit.h"
#import "BogoCartModel.h"
#import "FDUIKitObjC.h"

@interface BogoCartHeaderView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *selectBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *shopNameLabel;

@end

@implementation BogoCartHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundView = ({
    UIView * view = [[UIView alloc] initWithFrame:self.bounds];
    view.backgroundColor = FD_WhiteColor;
    view;
    });
}

- (void)setType:(BogoCartHeaderViewType)type{
    _type = type;
    if (type == BogoCartHeaderViewTypeOrderSubmit) {
        self.selectBtn.enabled = NO;
        [self.selectBtn setImage:imageNamed(@"提交订单_店铺") forState:UIControlStateDisabled];
    }else{
        self.selectBtn.enabled = YES;
        [self.selectBtn setImage:imageNamed(@"shop_cart_未选") forState:UIControlStateNormal];
    }
}

- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    _cartModel.selected = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didClickSelectBtn:)]) {
        [self.delegate headerView:self didClickSelectBtn:sender];
    }
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    [self.shopNameLabel setText:model.shop.title];
    self.selectBtn.selected = model.selected;
}

- (void)setCartModel:(BogoCartModel *)cartModel{
    _cartModel = cartModel;
    [self.shopNameLabel setText:cartModel.title];
    if (_type != BogoCartHeaderViewTypeOrderSubmit) {
        self.selectBtn.selected = cartModel.selected;
    }
}

@end
