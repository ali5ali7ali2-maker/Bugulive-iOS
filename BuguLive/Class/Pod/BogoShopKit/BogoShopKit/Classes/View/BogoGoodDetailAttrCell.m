//
//  BogoGoodDetailAttrCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/3/24.
//

#import "BogoGoodDetailAttrCell.h"
#import "BogoCommodityDetailModel.h"
#import <YYKit/YYKit.h>

@interface BogoGoodDetailAttrCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BogoGoodDetailAttrCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
}

- (void)setModel:(BogoCommodityDetailAttrModel *)model{
    _model = model;
    [self.titleLabel setText:model.name];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.titleLabel.textColor = [UIColor colorWithHexString:selected ? @"ffffff" : @"#777777"];
    self.titleLabel.backgroundColor = [UIColor colorWithHexString:selected ? @"#F42416" : @"#F4F4F4"];
}

@end
