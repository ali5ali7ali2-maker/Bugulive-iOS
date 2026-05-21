//
//  BogoOrderDetailAddressCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/19.
//

#import "BogoOrderDetailAddressCell.h"
#import "BogoOrderManageListModel.h"

@interface BogoOrderDetailAddressCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation BogoOrderDetailAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoOrderManageListModel *)model{
    _model = model;
    [self.nameLabel setText:[NSString stringWithFormat:@"收货人:  %@%@",model.name,model.tel]];
    [self.addressLabel setText:[NSString stringWithFormat:@"收货地址:  %@",model.address]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
