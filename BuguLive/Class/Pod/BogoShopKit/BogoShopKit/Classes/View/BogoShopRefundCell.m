//
//  BogoShopRefundCell.m
//  BogoShopKit
//
//  Created by 宋晨光 on 2021/9/2.
//

#import "BogoShopRefundCell.h"

@implementation BogoShopRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoRefundReasonModel *)model{
    _model = model;
    _titleL.text = model.value;
    self.selectBtn.selected = model.isSelect;
}

- (IBAction)clickSelectBtn:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    _model.isSelect =  sender.selected;
    if (self.clickSelectModelBlock) {
        self.clickSelectModelBlock(_model);
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
