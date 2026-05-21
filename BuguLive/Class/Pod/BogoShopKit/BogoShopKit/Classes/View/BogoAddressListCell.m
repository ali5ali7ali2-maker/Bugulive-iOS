//
//  BogoAddressListCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/20.
//

#import "BogoAddressListCell.h"
#import "BogoAddressListModel.h"

@interface BogoAddressListCell ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *telLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *addressLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *defaultBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressLeading;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@end

@implementation BogoAddressListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)editBtnAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(listCell:didClickEditBtn:)]) {
        [self.delegate listCell:self didClickEditBtn:sender];
    }
}

- (void)setModel:(BogoAddressListModel *)model{
    _model = model;
    [self.nameLabel setText:model.name];
    [self.telLabel setText:model.tel];
    [self.addressLabel setText:[NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address]];
    self.defaultBtn.hidden = !model.status.integerValue;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectImageView.hidden = !selected;
    self.nameLeading.constant = selected ? 40 : 10;
    self.addressLeading.constant = selected ? 40 : 10;
    // Configure the view for the selected state
}

@end
