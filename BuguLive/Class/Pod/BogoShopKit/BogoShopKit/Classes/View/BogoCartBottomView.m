//
//  BogoCartBottomView.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/23.
//

#import "BogoCartBottomView.h"
#import "FDUIKitObjC.h"
#import <YYKit/YYKit.h>

@interface BogoCartBottomView ()

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *accountBtn;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *priceLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *allLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation BogoCartBottomView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, FD_ScreenHeight - FD_Bottom_SafeArea_Height - 50, FD_ScreenWidth, 67 + FD_Bottom_SafeArea_Height);
    self.deleteBtn.layer.borderColor = [UIColor colorWithHexString:@"#F46628"].CGColor;
    self.deleteBtn.layer.borderWidth = 1;
    _num = @"0";
}

- (void)setType:(BogoCartBottomViewType)type{
    _type = type;
    if (type == BogoCartBottomViewTypeNormal) {
        self.deleteBtn.hidden = YES;
        self.accountBtn.hidden = NO;
        self.allLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        [self.accountBtn setTitle:[NSString stringWithFormat:@"结算(%@)",_num] forState:UIControlStateNormal];
        self.selectBtn.hidden = NO;
    }else if (type == BogoCartBottomViewTypeOrderSubmit){
        self.deleteBtn.hidden = YES;
        self.accountBtn.hidden = NO;
        self.allLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.selectBtn.hidden = YES;
        [self.accountBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    else{
        self.deleteBtn.hidden = NO;
        self.accountBtn.hidden = YES;
        self.allLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.selectBtn.hidden = NO;
    }
}

- (void)setNum:(NSString *)num{
    _num = num;
    [self.accountBtn setTitle:[NSString stringWithFormat:@"结算(%@)",num] forState:UIControlStateNormal];
}

- (void)setPrice:(NSString *)price{
    _price = price;
    [self.priceLabel setText:[NSString stringWithFormat:@"￥%.2f",price.doubleValue]];
}

- (IBAction)accountBtnAction:(id)sender {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickAccountBtn:)]) {
        [self.delegate bottomView:self didClickAccountBtn:sender];
    }
}

- (IBAction)deleteBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickDeleteBtn:)]) {
        [self.delegate bottomView:self didClickDeleteBtn:sender];
    }
}

- (IBAction)selectBtnAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomView:didClickSelectBtn:)]) {
        [self.delegate bottomView:self didClickSelectBtn:sender];
    }
}

@end
