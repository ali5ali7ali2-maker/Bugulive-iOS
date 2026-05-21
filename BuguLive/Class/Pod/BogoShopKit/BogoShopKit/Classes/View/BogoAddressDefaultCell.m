//
//  BogoAddressDefaultCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/21.
//

#import "BogoAddressDefaultCell.h"
#import "BogoAddressListModel.h"

@interface BogoAddressDefaultCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UISwitch *defaultSwitch;

@end

@implementation BogoAddressDefaultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoAddressListModel *)model{
    _model = model;
    self.defaultSwitch.on = model.status.integerValue == 1;
}

- (IBAction)defaultSwitchAction:(UISwitch *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultCell:didValueChanged:)]) {
        [self.delegate defaultCell:self didValueChanged:sender];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
