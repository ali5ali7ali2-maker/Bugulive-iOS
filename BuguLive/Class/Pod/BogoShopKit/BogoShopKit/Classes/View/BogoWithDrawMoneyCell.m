//
//  BogoWithDrawMoneyCell.m
//  UniversalApp
//
//  Created by Mac on 2021/6/12.
//  Copyright © 2021 voidcat. All rights reserved.
//

#import "BogoWithDrawMoneyCell.h"
//#import "BogoWithDrawResponseModel.h"

@interface BogoWithDrawMoneyCell ()

@end

@implementation BogoWithDrawMoneyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//- (void)textFieldDidChange:(UITextField *)textField{
//    NSString *money = textField.text;
//    NSString *fee = [NSString stringWithFormat:@"%.2f",money.floatValue * self.model.data.with_comm.floatValue];
//    NSString *real = [NSString stringWithFormat:@"%.2f",money.floatValue - fee.floatValue];
//    self.feeLabel.text = fee;
//    self.realLabel.text = real;
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
