//
//  BogoCategoryCell.m
//  BogoShopKit
//
//  Created by bogokj on 2020/4/15.
//

#import "BogoCategoryCell.h"
#import <YYKit/YYKit.h>
#import "BogoCategoryModel.h"

@interface BogoCategoryCell ()

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *titleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *leftView;

@end

@implementation BogoCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BogoCategoryModel *)model{
    _model = model;
    [self.titleLabel setText:model.title];
    self.selected = model.selected;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.leftView.hidden = !selected;
    self.titleLabel.textColor = [UIColor colorWithHexString:selected ? @"#F42416" : @"#777777"];
    // Configure the view for the selected state
}

@end
