//
//  BogoShopFillInfoCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/12.
//

#import "BogoShopFillInfoCell.h"
#import "FDUIKitObjC.h"

@interface BogoShopFillInfoCell ()<QMUITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *nextImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightContraint;
@end

@implementation BogoShopFillInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    
    [self.rightTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.rightTextField.delegate = self;
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
    if (isSee) {
        self.nextImageView.hidden = YES;
    }
}

- (void)setRightTitle:(NSString *)rightTitle{
    _rightTitle = rightTitle;
    [self.rightTitleLabel setText:rightTitle];
    
}

- (void)setRightImage:(UIImage *)rightImage{
    _rightImage = rightImage;
    [self.avatarImageView setImage:rightImage];
}



- (void)setType:(BogoShopFillInfoCellType)type{
    self.avatarImageView.hidden = YES;
    self.rightTitleLabel.hidden = YES;
    self.rightTextField.hidden = YES;
    self.rightContraint.constant = 30;
    self.rightTitleLabel.font = [UIFont systemFontOfSize:11];
    _type = type;
    switch (type) {
        case BogoShopFillInfoCellTypeName:
            self.nextImageView.hidden = YES;
            self.rightTextField.hidden = NO;
            [self.leftTitleLabel setText:@"姓名"];
            self.rightTextField.placeholder = @"请输入真实姓名";
            break;
        case BogoShopFillInfoCellTypeIDNumber:
            self.nextImageView.hidden = YES;
            self.rightTextField.hidden = NO;
            [self.leftTitleLabel setText:@"身份证号"];
            self.rightTextField.placeholder = @"请输入身份证号码";
            break;
        case BogoShopFillInfoCellTypeMobile:
            self.nextImageView.hidden = YES;
            self.rightTextField.hidden = NO;
            [self.leftTitleLabel setText:@"联系方式"];
            self.rightTextField.placeholder = @"请输入手机号码";
            break;
        case BogoShopFillInfoCellTypeType:
            self.rightTitleLabel.hidden = NO;
            self.nextImageView.hidden = NO;
            self.rightTextField.hidden = NO;
            [self.leftTitleLabel setText:@"商铺类型"];
            self.rightTextField.placeholder = @"选择类型";
            
            self.rightTextField.enabled = NO;
            break;
        case BogoShopFillInfoCellTypeAddress:
            self.rightTitleLabel.hidden = NO;
            self.nextImageView.hidden = NO;
            [self.leftTitleLabel setText:@"选择省市"];
//            self.rightTitleLabel.text = @"选择省市";
            self.rightTextField.placeholder = @"选择省市";
            self.rightTextField.enabled = NO;
            self.rightTextField.hidden = NO;
            break;
        case BogoShopFillInfoCellTypeAuth:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"请选择认证类型"];
            self.nextImageView.hidden = NO;
            break;
        case BogoShopFillInfoCellTypeAvatar:
            self.avatarImageView.hidden = NO;
            [self.leftTitleLabel setText:@"头像"];
            break;
        case BogoShopFillInfoCellTypeShopAvatar:
            self.avatarImageView.hidden = NO;
            [self.leftTitleLabel setText:@"店铺头像"];
            break;
        case BogoShopFillInfoCellTypeShopTitle:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"商铺名称"];
            self.nextImageView.hidden = YES;
            self.rightTextField.hidden = NO;
            
            self.rightTextField.placeholder = @"请输入商铺名称";
            break;
        case BogoShopFillInfoCellTypeShopTransfer:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"默认快递"];
            self.nextImageView.hidden = NO;
            break;
        case BogoShopFillInfoCellTypeShopAddress:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"发货地址"];
            self.nextImageView.hidden = NO;
            break;
        case BogoShopFillInfoCellTypeShopRefund:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"退货地址"];
            self.nextImageView.hidden = NO;
            break;
        case BogoShopFillInfoCellTypeSelectTransfer:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"选择快递公司"];
            self.nextImageView.hidden = NO;
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            break;
        case BogoShopFillInfoCellTypeOrderTransfer:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"运费"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderNo:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"订单编号"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderTime:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"下单时间"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderID:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"下单ID"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderPayType:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"支付方式"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRemark:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"备注"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderDeliver:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"配送方式"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderMessage:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"备注"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRefundReason:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"退款原因"];
            self.nextImageView.hidden = NO;
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 30;
            break;
        case BogoShopFillInfoCellTypeOrderRefundAccount:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"退款金额"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];

            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRefundApplyTime:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"申请时间"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRefundNo:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"退款编号"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRefundTransfer:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"退货物流公司"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRefundVoucher:
            self.avatarImageView.hidden = NO;
            [self.leftTitleLabel setText:@"凭证"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeOrderRefundPhone:
            
            
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"电话"];
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];

            self.rightContraint.constant = 10;
            break;
        case BogoShopFillInfoCellTypeAddressArea:
            self.rightTitleLabel.hidden = NO;
            self.nextImageView.hidden = NO;
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            self.rightTitleLabel.textColor = [UIColor qmui_colorWithHexString:@"333333"];
            self.rightTitleLabel.textAlignment = NSTextAlignmentLeft;
            [self.leftTitleLabel setText:@"所在地区"];
            break;
        case BogoShopFillInfoCellTypeGoodDetailAttr:
            self.rightTitleLabel.hidden = NO;
            [self.leftTitleLabel setText:@"规格"];
            [self.rightTitleLabel setText:@"请选择"];
            self.nextImageView.hidden = NO;
            break;
        case BogoShopFillInfoCellTypeOrderSubmitTransfer:
            self.rightTitleLabel.hidden = NO;
            self.rightContraint.constant = 10;
            self.rightTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
            [self.leftTitleLabel setText:@"运费"];
            break;
        case BogoShopFillInfoCellTypeOrderRefundInfo:
            self.rightTitleLabel.hidden = NO;
            self.rightContraint.constant = 10;
            self.rightTitleLabel.font = [UIFont systemFontOfSize:14];
            [self.leftTitleLabel setText:@"退款说明"];
            self.rightTitleLabel.numberOfLines = 0;
            break;
        default:
            break;
    }
}

-(void)textFieldDidChange:(UITextField *)textField{
    
    if (_type == BogoShopFillInfoCellTypeShopTitle) {
        if (textField.text.length > 8) {
            textField.text = [textField.text substringToIndex:8];
            [[FDHUDManager defaultManager] show:@"商铺名称不得多于八个字" ToView:self.superview.superview];
            return;
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopFillInfoCellTextChange:textField:)]) {
        [self.delegate shopFillInfoCellTextChange:self textField:textField];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
