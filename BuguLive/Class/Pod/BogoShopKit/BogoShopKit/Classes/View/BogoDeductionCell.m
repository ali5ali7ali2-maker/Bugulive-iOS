//
//  BogoDeductionCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/8/29.
//

#import "BogoDeductionCell.h"

@interface BogoDeductionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation BogoDeductionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (IBAction)selectBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deductionCell:didClickSelectBtn:)]) {
        [self.delegate deductionCell:self didClickSelectBtn:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
