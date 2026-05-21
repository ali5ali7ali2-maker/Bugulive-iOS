//
//  BogoShopSelectedButtonCell.m
//  BogoShopKit
//
//  Created by Mac on 2021/7/1.
//

#import "BogoShopSelectedButtonCell.h"

@implementation BogoShopSelectedButtonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)timeBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonCell:didClickTimeBtn:)]) {
        [self.delegate buttonCell:self didClickTimeBtn:sender];
    }
}

- (IBAction)goodBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonCell:didClickGoodBtn:)]) {
        [self.delegate buttonCell:self didClickGoodBtn:sender];
    }
}

- (IBAction)topBtnAction:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(buttonCell:didClickTopBtn:)]) {
        [self.delegate buttonCell:self didClickTopBtn:sender];
    }
}
@end
