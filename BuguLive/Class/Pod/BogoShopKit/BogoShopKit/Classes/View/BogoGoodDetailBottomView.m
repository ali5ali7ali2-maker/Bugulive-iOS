//
//  BogoGoodDetailBottomView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoGoodDetailBottomView.h"
#import "FDUIKitObjC.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoCommodityDetailModel.h"

@interface BogoGoodDetailBottomView ()

@property (weak, nonatomic) IBOutlet QMUIButton *shopBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *cartBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *collectBtn;
@property (weak, nonatomic) IBOutlet QMUIButton *serviceBtn;

@end

@implementation BogoGoodDetailBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, FD_ScreenHeight - (50 + FD_Bottom_SafeArea_Height) - FD_Top_Height, FD_ScreenWidth, 50 + FD_Bottom_SafeArea_Height);
    self.shopBtn.imagePosition = QMUIButtonImagePositionTop;
    self.shopBtn.spacingBetweenImageAndTitle = 5;
    self.cartBtn.imagePosition = QMUIButtonImagePositionTop;
    self.cartBtn.spacingBetweenImageAndTitle = 5;
    self.serviceBtn.imagePosition = QMUIButtonImagePositionTop;
    self.serviceBtn.spacingBetweenImageAndTitle = 5;
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    self.collectBtn.selected = model.is_favorite.integerValue;
}

- (IBAction)shopBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickShopBtn:)]) {
        [self.delegate bottomView:self didClickShopBtn:sender];
    }
}

- (IBAction)cartBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickCartBtn:)]) {
        [self.delegate bottomView:self didClickCartBtn:sender];
    }
}

- (IBAction)clickServiceBtn:(QMUIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickServiceBtn:)]) {
        [self.delegate bottomView:self didClickServiceBtn:sender];
    }
    
}


- (IBAction)collectBtnAction:(id)sender {
    
//    GoToUserMsgVCShopKit
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickCollectBtn:)]) {
        [self.delegate bottomView:self didClickCollectBtn:sender];
    }
}

- (IBAction)addCartBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickAddCartBtn:)]) {
        [self.delegate bottomView:self didClickAddCartBtn:sender];
    }
}

- (IBAction)buyBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickBuyBtn:)]) {
        [self.delegate bottomView:self didClickBuyBtn:sender];
    }
}

@end
