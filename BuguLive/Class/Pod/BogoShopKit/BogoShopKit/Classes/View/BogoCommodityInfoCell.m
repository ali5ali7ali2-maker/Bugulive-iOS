//
//  BogoCommodityInfoCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/14.
//

#import "BogoCommodityInfoCell.h"
#import <QMUIKit/QMUIKit.h>
#import "BogoCommodityDetailModel.h"

@interface BogoCommodityInfoCell ()<QMUITextFieldDelegate,QMUITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet QMUITextView *textView;

@end

@implementation BogoCommodityInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)setIsSee:(BOOL)isSee{
    _isSee = isSee;
    self.textField.userInteractionEnabled = !isSee;
}

- (void)textFieldDidChange:(QMUITextField *)sender{
    NSLog(@"%s",__func__);
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoCell:didTextFieldChange:)]) {
        [self.delegate infoCell:self didTextFieldChange:sender];
    }
}

- (void)setModel:(BogoCommodityDetailModel *)model{
    _model = model;
    switch (_type) {
        case BogoCommodityInfoCellTypeTitle:
            [self.textField setText:model.title.length ? model.title : @""];
            break;
        case BogoCommodityInfoCellTypeTransferFee:
            [self.textField setText:[NSString stringWithFormat:@"￥%@",model.free_shipping.length ? model.free_shipping : @""]];
            break;
        default:
            break;
    }
}

- (void)setType:(BogoCommodityInfoCellType)type{
    _type = type;
    self.textField.hidden = NO;
    self.textField.keyboardType = UIKeyboardTypeDefault;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    switch (type) {
        case BogoCommodityInfoCellTypeTitle:
            [self.titleLabel setText:@"标题"];
            [self.textField setPlaceholder:@"请输入商品名称"];
            break;
        case BogoCommodityInfoCellTypeSet:
            self.textField.hidden = YES;
            [self.titleLabel setText:@"规格设置"];
            self.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
            break;
        case BogoCommodityInfoCellTypeModelName:
            [self.titleLabel setText:@"规格名称"];
            [self.textField setPlaceholder:@"请输入商品规格"];
            break;
        case BogoCommodityInfoCellTypeModelPrice:
            [self.titleLabel setText:@"价格"];
            [self.textField setPlaceholder:@"请输入商品价格"];
            self.textField.delegate = self;
            self.textField.keyboardType = UIKeyboardTypeDecimalPad;
            //单位是分
            break;
        case BogoCommodityInfoCellTypeModelCount:
            [self.titleLabel setText:@"库存"];
            [self.textField setPlaceholder:@"请输入商品库存"];
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case BogoCommodityInfoCellTypeTransferFee:
            [self.titleLabel setText:@"快递费"];
            [self.textField setPlaceholder:@"请输入快递费"];
            self.textField.delegate = self;
            self.textField.keyboardType = UIKeyboardTypeNumberPad;
            break;
        case BogoCommodityInfoCellTypeRefundDesc:
            [self.titleLabel setText:@"退款说明"];
            self.textField.hidden = YES;
            self.textView.hidden = NO;
            [self.textView setPlaceholder:@"请填写文字说明"];
            self.textView.delegate = self;
            self.textView.maximumTextLength = 30;
            break;
        case BogoCommodityInfoCellTypeRefundPhone:
            [self.titleLabel setText:@"电话"];
            [self.textField setPlaceholder:@"请填写文字说明"];
            self.textField.delegate = self;
            break;
        default:
            break;
    }
}

#pragma mark - QMUITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(infoCell:didTextViewChange:)]) {
        [self.delegate infoCell:self didTextViewChange:textView];
    }
}

#pragma mark - QMUITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"%s",__func__);
    if (_type == BogoCommodityInfoCellTypeTransferFee || _type == BogoCommodityInfoCellTypeModelPrice) {
        if (![textField.text containsString:@"￥"]) {
            [textField setText:[NSString stringWithFormat:@"￥%.2f",textField.text.floatValue]];
        }else{
            if (textField.text.length) {
                [textField setText:[NSString stringWithFormat:@"￥%.2f",[textField.text substringFromIndex:@"￥".length].floatValue]];
            }
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_type == BogoCommodityInfoCellTypeModelPrice) {
        // 1 不能直接输入小数点
        if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )  return NO;
        // 2 输入框第一个字符为“0”时候，第二个字符如果不是“.”,那么文本框内的显示内容就是新输入的字符[textField.text length] == 1  防止例如0.5会变成5
        NSRange zeroRange = [textField.text rangeOfString:@"0"];
        if(zeroRange.length == 1 && [textField.text length] == 1 && ![string isEqualToString:@"."]){
            textField.text = string;
            return NO;
        }
        // 3 保留两位小数
        NSUInteger remain = 2;
        NSRange pointRange = [textField.text rangeOfString:@"."];
        // 拼接输入的最后一个字符
        NSString *tempStr = [textField.text stringByAppendingString:string];
        NSUInteger strlen = [tempStr length];
        // 输入框内存在小数点， 不让再次输入“.” 或者 总长度-包括小数点之前的长度>remain 就不能再输入任何字符
        if(pointRange.length > 0 &&([string isEqualToString:@"."] || strlen - (pointRange.location + 1) > remain))
            return NO;
        // 4 小数点已经存在情况下可以输入的字符集  and 小数点还不存在情况下可以输入的字符集
        NSCharacterSet *numbers = (pointRange.length > 0)?[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] : [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
        NSScanner *scanner = [NSScanner scannerWithString:string];
        NSString *buffer;
        // 判断string在不在numbers的字符集合内
        BOOL scan = [scanner scanCharactersFromSet:numbers intoString:&buffer];
        // 包括输入空格scan为NO， 点击删除键[string length]为0
        if ( !scan && ([string length] != 0) ){
            return NO;
        }
    }
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
