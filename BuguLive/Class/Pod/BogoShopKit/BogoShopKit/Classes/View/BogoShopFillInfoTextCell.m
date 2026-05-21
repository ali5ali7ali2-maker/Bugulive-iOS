//
//  BogoShopFillInfoTextCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopFillInfoTextCell.h"
#import <QMUIKit/QMUIKit.h>

@interface BogoShopFillInfoTextCell ()<UITextFieldDelegate,QMUITextViewDelegate>



@end

@implementation BogoShopFillInfoTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.textField.delegate = self;
    self.rightTextField.delegate = self;
    
}

- (IBAction)textFieldDidChange:(UITextField *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textCell:didChangeText:)]) {
        [self.delegate textCell:self didChangeText:sender];
    }
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
    self.textField.enabled = !isSee;
    self.rightTextField.enabled = !isSee;
}

- (void)setType:(BogoShopFillInfoTextCellType)type{
    self.leftTitleLabel.hidden = YES;
    self.textField.hidden = YES;
    self.rightTextField.hidden = YES;
    _type = type;
    switch (type) {
        case BogoShopFillInfoTextCellTypeDetailAddress:
            self.leftTitleLabel.hidden = NO;
            self.rightTextField.hidden = NO;
            [self.leftTitleLabel setText:@"详细地址"];
            break;
        case BogoShopFillInfoTextCellTypeAddressArea1:
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"所在地区"];
            break;
            
        case BogoShopFillInfoTextCellTypeIDName:
            [self.textField setPlaceholder:@"请输入真实姓名"];
            self.leftTitleLabel.text = @"姓名";
            self.textField.hidden = NO;
            break;
        case BogoShopFillInfoTextCellTypeIDNumber:
            [self.textField setPlaceholder:@"请输入身份证号码"];
            self.leftTitleLabel.text = @"身份证号";
            self.textField.hidden = NO;
            break;
        case BogoShopFillInfoTextCellTypeName:
            [self.textField setPlaceholder:@"请输入商铺名称"];
            self.textField.hidden = NO;
            break;
        case BogoShopFillInfoTextCellTypeEditTransferNo:
            [self.rightTextField setPlaceholder:@"请填写快递单号"];
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"填写快递单号"];
            break;
        case BogoShopFillInfoTextCellTypeAddressName:
            [self.rightTextField setPlaceholder:@"请使用真实姓名"];
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            self.rightTextField.textAlignment = NSTextAlignmentLeft;
            [self.leftTitleLabel setText:@"收货人"];
            break;
        case BogoShopFillInfoTextCellTypeAddressTel:
            [self.rightTextField setPlaceholder:@""];
            self.rightTextField.keyboardType = UIKeyboardTypeNumberPad;
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            self.rightTextField.textAlignment = NSTextAlignmentLeft;
            [self.leftTitleLabel setText:@"手机号码"];
            break;
        case BogoShopFillInfoTextCellTypeOrderSubmitRemark:
            [self.rightTextField setPlaceholder:@"选填"];
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"订单备注"];
        break;
        case BogoShopFillInfoTextCellTypeRefundAddress:
            [self.rightTextField setPlaceholder:@""];
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"详细地址"];
            break;
        case BogoShopFillInfoTextCellTypeSendAddress:
            [self.rightTextField setPlaceholder:@""];
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"详细地址"];
        break;
        case BogoShopFillInfoTextCellTypeShopTitle:
            [self.rightTextField setPlaceholder:@""];
            self.rightTextField.hidden = NO;
            self.leftTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"店铺名称"];
        break;
        default:
            break;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
