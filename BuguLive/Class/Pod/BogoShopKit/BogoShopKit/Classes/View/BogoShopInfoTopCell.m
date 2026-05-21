//
//  BogoShopInfoTopCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/17.
//

#import "BogoShopInfoTopCell.h"
#import "BogoShopInfoModel.h"

@interface BogoShopInfoTopCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *todayIncomeLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *allIncomeLabel;

@end

@implementation BogoShopInfoTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoShopInfoModel *)model{
    _model = model;
    [self.todayIncomeLabel setText:model.income];
    [self.allIncomeLabel setText:model.income_total];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
