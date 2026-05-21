//
//  BogoOrderSubmitAddressCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoOrderSubmitAddressCell.h"
#import "BogoAddressListModel.h"
#import "BogoShopKit.h"
#import "BogoAddressModel.h"

@interface BogoOrderSubmitAddressCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *addLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *addImageView;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *nameLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *telLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *contentLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *addressImageView;

@property(nonatomic, strong) BogoAddressModel *addressModel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *nextImageView;

@end

@implementation BogoOrderSubmitAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoAddressListModel *)model{
    _model = model;
    if (model) {
        self.addLabel.hidden = YES;
        self.addImageView.hidden = YES;
        self.nameLabel.hidden = NO;
        self.telLabel.hidden = NO;
        self.contentLabel.hidden = NO;
        self.addressImageView.hidden = NO;
        self.nextImageView.hidden = NO;
        [self.nameLabel setText:model.name];
        [self.telLabel setText:model.tel];
        [self.contentLabel setText:[NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.district,model.address]];
    }else{
        self.addLabel.hidden = NO;
        self.addImageView.hidden = NO;
        self.nameLabel.hidden = YES;
        self.telLabel.hidden = YES;
        self.contentLabel.hidden = YES;
        self.addressImageView.hidden = YES;
        self.nextImageView.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
